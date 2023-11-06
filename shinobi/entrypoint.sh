#!/bin/bash
set -eux

cronKey="$(head -c 1024 < /dev/urandom | sha256sum | awk '{print substr($1,1,29)}')"
mkdir -p libs/customAutoLoad
if [ -e "/config/conf.json" ]; then
    cp /config/conf.json conf.json
elif [ ! -e "./conf.json" ]; then
    cp conf.sample.json conf.json
fi

if [ -e "/config/super.json" ]; then
    cp /config/super.json super.json
elif [ ! -e "./super.json" ]; then
    cp super.sample.json super.json
    cp super.json /config/super.json
fi

# Waiting database connection
echo "Wait for database server" ...
wait-for "$DB_HOST:3306"

# Try create
#echo "Create database schema if it does not exists ..."
#mysql -u $DB_USER -h $DB_HOST --password="$DB_PASSWORD" -e "source sql/framework.sql" $DB_DATABASE || true

# Set database to conf.json
echo "Update mysql connection"
node tools/modifyConfiguration.js thisIsDocker=true db="{\"host\": \"$DB_HOST\", \"user\": \"$DB_USER\", \"password\": \"$DB_PASSWORD\", \"database\": \"$DB_DATABASE\", \"port\": \"3306\" }"
echo "Copy generated conf.json from /config/conf.json to /Shinobi/conf.json"
cp /config/conf.json conf.json

# Execute Command echo "Starting Shinobi ..."
echo "Starting Shinobi"
exec "$@"