#!/bin/sh
set -eu

# version_greater A B returns whether A > B
version_greater() {
    [ "$(printf '%s\n' "$@" | sort -t '.' -n -k1,1 -k2,2 -k3,3 -k4,4 | head -n 1)" != "$1" ]
}

# return true if specified directory is empty
directory_empty() {
    [ -z "$(ls -A "$1/")" ]
}

run_as() {
    if [ "$(id -u)" = 0 ]; then
        su -p www-data -s /bin/sh -c "$1"
    else
        sh -c "$1"
    fi
}

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    local varValue=$(env | grep -E "^${var}=" | sed -E -e "s/^${var}=//")
    local fileVarValue=$(env | grep -E "^${fileVar}=" | sed -E -e "s/^${fileVar}=//")
    if [ -n "${varValue}" ] && [ -n "${fileVarValue}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    if [ -n "${varValue}" ]; then
        export "$var"="${varValue}"
    elif [ -n "${fileVarValue}" ]; then
        export "$var"="$(cat "${fileVarValue}")"
    elif [ -n "${def}" ]; then
        export "$var"="$def"
    fi
    unset "$fileVar"
}

if expr "$1" : "apache" 1>/dev/null; then
    if [ -n "${APACHE_DISABLE_REWRITE_IP+x}" ]; then
        a2disconf remoteip
    fi
fi

if expr "$1" : "apache" 1>/dev/null || [ "$1" = "php-fpm" ] || [ "${NEXTCLOUD_UPDATE:-0}" -eq 1 ]; then
    installed_version="0.0.0.0"
    if [ -f /var/www/html/version.php ]; then
        # shellcheck disable=SC2016
        installed_version="$(php -r 'require "/var/www/html/version.php"; echo implode(".", $OC_Version);')"
    fi
    # shellcheck disable=SC2016
    image_version="$(php -r 'require "/usr/src/nextcloud/version.php"; echo implode(".", $OC_Version);')"

    if version_greater "$installed_version" "$image_version"; then
        echo "Can't start Nextcloud because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
        exit 1
    fi

    if version_greater "$image_version" "$installed_version"; then
        echo "Initializing nextcloud $image_version ..."
        if [ "$installed_version" != "0.0.0.0" ]; then
           if [ "${image_version%%.*}" -gt "$((${installed_version%%.*} + 1))" ]; then
                    echo "Can't start Nextcloud because upgrading from $installed_version to $image_version is not supported."
                    echo "It is only possible to upgrade one major version at a time. For example, if you want to upgrade from version 14 to 16, you will have to upgrade from version 14 to 15, then from 15 to 16."
                    exit 1
          fi
          echo "Upgrading nextcloud from $installed_version ..."
          run_as 'php /var/www/html/occ app:list' | sed -n "/Enabled:/,/Disabled:/p" > /tmp/list_before
        fi
        if [ "$(id -u)" = 0 ]; then
            rsync_options="-rlDog --chown www-data:root"
        else
            rsync_options="-rlD"
        fi

        # If another process is syncing the html folder, wait for
        # it to be done, then escape initalization.
        # You need to define the NEXTCLOUD_INIT_LOCK environment variable
        lock=/var/www/html/nextcloud-init-sync.lock
        count=0
        limit=10

        if [ -f "$lock" ] && [ -n "${NEXTCLOUD_INIT_LOCK+x}" ]; then
            until [ ! -f "$lock" ] || [ "$count" -gt "$limit" ]
            do
                count=$((count+1))
                wait=$((count*10))
                echo "Another process is initializing Nextcloud. Waiting $wait seconds..."
                sleep $wait
            done
            if [ "$count" -gt "$limit" ]; then
                echo "Timeout while waiting for an ongoing initialization"
                exit 1
            fi
            echo "The other process is done, assuming complete initialization"
        else
            # Prevent multiple images syncing simultaneously
            touch $lock
            rsync $rsync_options --delete --exclude-from=/upgrade.exclude /usr/src/nextcloud/ /var/www/html/

            for dir in config data custom_apps themes; do
                if [ ! -d "/var/www/html/$dir" ] || directory_empty "/var/www/html/$dir"; then
                    rsync $rsync_options --include "/$dir/" --exclude '/*' /usr/src/nextcloud/ /var/www/html/
                fi
            done
            rsync $rsync_options --include '/version.php' --exclude '/*' /usr/src/nextcloud/ /var/www/html/

            # Install
            if [ "$installed_version" = "0.0.0.0" ]; then
                echo "New nextcloud instance, Please run the web-based installer on first connect!"
            # Upgrade
            else
                run_as 'php /var/www/html/occ upgrade'

                run_as 'php /var/www/html/occ app:list' | sed -n "/Enabled:/,/Disabled:/p" > /tmp/list_after
                echo "The following apps have been disabled:"
                diff /tmp/list_before /tmp/list_after | grep '<' | cut -d- -f2 | cut -d: -f1
                rm -f /tmp/list_before /tmp/list_after

            fi

            # Initialization done, reset lock
            rm $lock
            echo "Initializing finished"
        fi
    fi

    # Update htaccess after init if requested
    if [ -n "${NEXTCLOUD_INIT_HTACCESS+x}" ]; then
        run_as 'php /var/www/html/occ maintenance:update:htaccess'
    fi

fi

exec "$@"
