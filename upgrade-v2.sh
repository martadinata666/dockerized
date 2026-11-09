#!/usr/bin/env bash
# upgrade-v2.sh - one script that replaces upgrade.sh + the 16 make-image.sh files.
#
#   * every version lives once, in the VERSIONS block below (or on the command line)
#   * every image's build command is a function here (copied from its make-image.sh)
#   * same order and groups as upgrade.sh: ESSENTIAL, ADDITIONAL (auto), MANUAL
#
# Usage:
#   ./upgrade-v2.sh                      # = essential (what upgrade.sh did)
#   ./upgrade-v2.sh essential|auto|manual|extra|all
#   ./upgrade-v2.sh stash heimdall       # specific images, always built in dependency order
#   ./upgrade-v2.sh -n all               # dry run: print commands only
#   ./upgrade-v2.sh -s PHP_VERSION=8.5.13 php-fpm apache nginx
#   ./upgrade-v2.sh -m node              # run the folder's own make-image.sh instead
#   ./upgrade-v2.sh list
#
# Options: -n dry-run | -k keep going after a failure | -s KEY=VALUE override a version
#          -m use each folder's make-image.sh | --no-prune | --no-push | -h help

set -uo pipefail

# Repo location: DOCKER_PATH if set (as in upgrade.sh), otherwise the folder of this script.
ROOT="${DOCKER_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
REGISTRY="${REGISTRY:-192.168.0.2:6060/dedyms}"

DRY_RUN=0 KEEP_GOING=0 LEGACY=0 PRUNE=1 OUT="--push"
targets=()

# ---------------------------------------------------------------- argument parsing
usage() { sed -n '2,19p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; }
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run)    DRY_RUN=1 ;;
    -k|--keep-going) KEEP_GOING=1 ;;
    -m|--make-image) LEGACY=1 ;;
    --no-prune)      PRUNE=0 ;;
    --no-push)       OUT="--load" ;;
    -s|--set)        [ $# -ge 2 ] && [[ "$2" == *=* ]] || { echo "-s needs KEY=VALUE" >&2; exit 2; }
                     export "$2"; shift ;;
    -h|--help)       usage; exit 0 ;;
    -*)              echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)               targets+=("$1") ;;
  esac
  shift
done

# ---------------------------------------------------------------- VERSIONS (edit here)
# Each value can also be overridden with an environment variable or -s KEY=VALUE.
: "${DEBIAN_VERSION:=13}"                      # debian + mariadb base            (was VERSION in debian, mariadb)
: "${FFMPEG_MAJOR:=9}"                         # ffmpeg tag; also used by node, stash, unmanic (was 4 copies)
: "${FFMPEG_GIT_TAG:=n${FFMPEG_MAJOR}.0}"      # https://git.ffmpeg.org/ffmpeg.git
: "${PHP_VERSION:=8.5.12}"                     # php-fpm full version
: "${PHP_TAG:=${PHP_VERSION%.*}}"              # 8.5 -> php-fpm tag, and apache/nginx FROM php-fpm:<tag>
: "${RUST_VERSION:=1.99.1}"
: "${RUSTUP_VERSION:=1.29.3}"
: "${NEXTCLOUD_RELEASE:=v35.0.2}"              # pinned on purpose: Nextcloud has many simultaneous versions
: "${UNMANIC_RELEASE:=staging}"
# Fetched from GitHub when not set: NODE_RELEASE NVM_RELEASE HEIMDALL_RELEASE STASH_VERSION
#                                   PUSH_RELEASE (nextcloud notify_push) QBIT_RELEASE

# ---------------------------------------------------------------- helpers
run() { echo "+ $*"; [ "$DRY_RUN" = 1 ] || "$@"; }
bx()  { run docker buildx build "$@"; }

need() {   # need <folder> <file...>
  local d="$1" f ok=0; shift
  for f in "$@"; do [ -f "$ROOT/$d/$f" ] || { echo "  missing: $d/$f" >&2; ok=1; }; done
  return $ok
}

need_tools() { command -v curl >/dev/null && command -v jq >/dev/null || { echo "  curl and jq are needed to look up versions (or set them with -s)" >&2; return 1; }; }

gh_latest() {   # gh_latest owner/repo -> tag name; fails on empty/null instead of building with "null"
  local v
  need_tools || { [ "$DRY_RUN" = 1 ] && { echo "<latest:$1>"; return 0; }; return 1; }
  v="$(curl --silent --fail "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name)" || v=""
  if [ -z "$v" ] || [ "$v" = null ]; then
    [ "$DRY_RUN" = 1 ] && { echo "<latest:$1>"; return 0; }
    echo "  could not fetch latest release of $1 (set the value with -s)" >&2; return 1
  fi
  echo "$v"
}
node_lts() {
  local v
  need_tools || { [ "$DRY_RUN" = 1 ] && { echo "v<lts>.0.0"; return 0; }; return 1; }
  v="$(curl --silent --fail "https://api.github.com/repos/nodejs/node/releases" \
        | jq -r 'first(.[] | select(.name | contains("LTS"))) | .tag_name')" || v=""
  if [ -z "$v" ] || [ "$v" = null ]; then
    [ "$DRY_RUN" = 1 ] && { echo "v<lts>.0.0"; return 0; }
    echo "  could not fetch the node LTS release (set NODE_RELEASE with -s, e.g. v24.0.0)" >&2; return 1
  fi
  echo "$v"
}

# ---------------------------------------------------------------- images (one function each)
# --- ESSENTIAL ---------------------------------------------------------------
up_debian() {      # base of everything. Check the debian version.
  need debian Dockerfile Dockerfile.dev || return 1; cd "$ROOT/debian" || return 1
  bx --build-arg "VERSION=$DEBIAN_VERSION" . -f Dockerfile \
     -t "$REGISTRY/debian:latest" -t "$REGISTRY/debian:$DEBIAN_VERSION" $OUT || return 1
  bx . -f Dockerfile.dev -t "$REGISTRY/debian:dev" $OUT
}
up_ffmpeg() {      # check ffmpeg version https://git.ffmpeg.org/ffmpeg.git
  need ffmpeg Dockerfile || return 1; cd "$ROOT/ffmpeg" || return 1
  bx --build-arg "FFMPEG_VERSION=$FFMPEG_GIT_TAG" . -f Dockerfile \
     -t "$REGISTRY/ffmpeg:$FFMPEG_MAJOR" $OUT
}
up_php-fpm() {     # check php version
  need php-fpm Dockerfile || return 1; cd "$ROOT/php-fpm" || return 1
  bx --build-arg "PHP_VERSION=$PHP_VERSION" . -f Dockerfile \
     -t "$REGISTRY/php-fpm:$PHP_TAG" $OUT --progress=plain
}
up_node() {        # auto latest LTS
  need node nvm/Dockerfile nvm/Dockerfile.dev nvm/Dockerfile.ffmpeg || return 1; cd "$ROOT/node" || return 1
  local rel="${NODE_RELEASE:-}" nvm="${NVM_RELEASE:-}" short img="$REGISTRY/node"
  [ -n "$rel" ] || rel="$(node_lts)" || return 1
  [ -n "$nvm" ] || nvm="$(gh_latest nvm-sh/nvm)" || return 1
  local node_release="${rel#v}"; short="${node_release:0:2}"
  echo "node $rel (tag $short, lts), nvm $nvm"
  bx --build-arg "NODE_RELEASE=$node_release" --build-arg "NVM_RELEASE=$nvm" $OUT \
     -t "$img:$short" -t "$img:lts" . -f nvm/Dockerfile || return 1
  bx --build-arg "NODE_RELEASE=$node_release" --build-arg "NVM_RELEASE=$nvm" $OUT \
     -t "$img:$short-dev" -t "$img:lts-dev" . -f nvm/Dockerfile.dev || return 1
  bx --build-arg "NODE_RELEASE=$node_release" --build-arg "NVM_RELEASE=$nvm" \
     --build-arg "FFMPEG_VERSION=$FFMPEG_MAJOR" $OUT \
     -t "$img:$short-ffmpeg" -t "$img:lts-ffmpeg" . -f nvm/Dockerfile.ffmpeg
}
up_apache() {      # update php version if php-fpm changed
  need apache Dockerfile || return 1; cd "$ROOT/apache" || return 1
  bx --build-arg "VERSION=$PHP_TAG" . -f Dockerfile -t "$REGISTRY/apache:fpm" $OUT --pull
}
up_nginx() {
  need nginx fpm/Dockerfile || return 1; cd "$ROOT/nginx" || return 1
  bx --build-arg "VERSION=$PHP_TAG" . -f fpm/Dockerfile -t "$REGISTRY/nginx:mainline-fpm" $OUT --pull
}
up_mariadb() {     # LTS manually generated, just update base image
  need mariadb-docker 12.3/Dockerfile.debian || return 1; cd "$ROOT/mariadb-docker" || return 1
  bx --build-arg "VERSION=$DEBIAN_VERSION" . -f 12.3/Dockerfile.debian \
     -t "$REGISTRY/mariadb:lts" $OUT --progress=plain
}

# --- ADDITIONAL: can be automated ---------------------------------------------
up_qbittorrent-nox() {   # (debian)
  need qbittorrent-nox Dockerfile || return 1; cd "$ROOT/qbittorrent-nox" || return 1
  local rel="${QBIT_RELEASE:-}" img="$REGISTRY/qbittorrent-nox"
  [ -n "$rel" ] || rel="$(gh_latest userdocs/qbittorrent-nox-static)" || return 1
  bx --build-arg "QBVERSION=$rel" $OUT -t "$img" -t "$img:$rel" . -f Dockerfile
}
up_stash() {             # (yacron, ffmpeg) - update ffmpeg if needed
  need stash Dockerfile || return 1; cd "$ROOT/stash" || return 1
  local rel="${STASH_VERSION:-}"
  [ -n "$rel" ] || rel="$(gh_latest stashapp/stash)" || return 1
  echo "$rel"
  bx --build-arg "STASHVERSION=$rel" --build-arg "VERSION=$FFMPEG_MAJOR" \
     . -f Dockerfile -t "$REGISTRY/stash:latest" $OUT --progress=plain
}
up_python-http-server() {   # (debian)
  need python-http-server Dockerfile || return 1; cd "$ROOT/python-http-server" || return 1
  bx . -f Dockerfile -t "$REGISTRY/python-http-server" $OUT
}

# --- MANUAL due to importance ---------------------------------------------------
up_shinobi() {     # (node)
  need shinobi Dockerfile || return 1; cd "$ROOT/shinobi" || return 1
  bx . -f Dockerfile -t "$REGISTRY/shinobi:git" $OUT
}
up_heimdall() {    # (nginx) - maybe needs a newer php version
  need heimdall Dockerfile || return 1; cd "$ROOT/heimdall" || return 1
  local rel="${HEIMDALL_RELEASE:-}"
  [ -n "$rel" ] || rel="$(gh_latest linuxserver/heimdall)" || return 1
  echo "$rel"
  bx --build-arg "RELEASE=$rel" . -f Dockerfile -t "$REGISTRY/heimdall:$rel" $OUT --pull
}
up_unmanic() {     # (ffmpeg, node)
  need unmanic Dockerfile || return 1; cd "$ROOT/unmanic" || return 1
  bx --build-arg "RELEASE=$UNMANIC_RELEASE" . --build-arg "FFMPEG_VERSION=$FFMPEG_MAJOR" \
     -f Dockerfile -t "$REGISTRY/unmanic:git" $OUT
}
up_nextcloud() {   # (apache, ffmpeg-static)
  need nextcloud Dockerfile || return 1; cd "$ROOT/nextcloud" || return 1
  local push="${PUSH_RELEASE:-}" rel="${NEXTCLOUD_RELEASE#v}"
  [ -n "$push" ] || push="$(gh_latest nextcloud/notify_push)" || return 1
  echo "$NEXTCLOUD_RELEASE"; echo "$rel"; echo "$push"
  bx --pull $OUT --build-arg "NEXTCLOUD_VERSION=$rel" --build-arg "PUSH_VERSION=$push" \
     . -f Dockerfile -t "$REGISTRY/nextcloud:$rel"
}

# --- EXTRA (have a make-image.sh but were not in upgrade.sh) --------------------
up_ffmpeg-static() {   # base of nextcloud
  need ffmpeg-static Dockerfile || return 1; cd "$ROOT/ffmpeg-static" || return 1
  bx . -f Dockerfile -t "$REGISTRY/ffmpeg-static:latest" $OUT
}
up_rust() {
  need rust Dockerfile || return 1; cd "$ROOT/rust" || return 1
  bx --build-arg "RUSTUP_VERSION=$RUSTUP_VERSION" --build-arg "RUST_VERSION=$RUST_VERSION" $OUT . \
     -f Dockerfile -t "$REGISTRY/rust:$RUST_VERSION" --progress=plain
}

# ---------------------------------------------------------------- groups and order
ESSENTIAL=(debian ffmpeg php-fpm node apache nginx mariadb)
AUTO=(qbittorrent-nox stash python-http-server)
MANUAL=(shinobi heimdall unmanic nextcloud)
EXTRA=(ffmpeg-static rust)
# every image, bases first (debian -> ffmpeg/php-fpm -> node -> apache/nginx -> apps)
ALL=(debian ffmpeg ffmpeg-static php-fpm rust node apache nginx mariadb \
     qbittorrent-nox stash python-http-server shinobi heimdall unmanic nextcloud)

folder_of() { [ "$1" = mariadb ] && echo mariadb-docker || echo "$1"; }

run_legacy() {   # the folder's own make-image.sh, registry replaced
  local d; d="$(folder_of "$1")"
  [ -f "$ROOT/$d/make-image.sh" ] || { echo "  missing: $d/make-image.sh" >&2; return 1; }
  echo "+ (cd $d && ./make-image.sh)"
  [ "$DRY_RUN" = 1 ] || ( cd "$ROOT/$d" && sed "s#192\.168\.0\.2:6060/dedyms#$REGISTRY#g" make-image.sh | bash )
}

in_list() { local x="$1"; shift; local y; for y in "$@"; do [ "$x" = "$y" ] && return 0; done; return 1; }

[ ${#targets[@]} -gt 0 ] || targets=(essential)
declare -A want=()
prune_after=0
for t in "${targets[@]}"; do
  case "$t" in
    list)      printf '%s\n' "${ALL[@]}"; exit 0 ;;
    essential) for i in "${ESSENTIAL[@]}"; do want[$i]=1; done; prune_after=1 ;;
    auto)      for i in "${AUTO[@]}";      do want[$i]=1; done ;;
    manual)    for i in "${MANUAL[@]}";    do want[$i]=1; done ;;
    extra)     for i in "${EXTRA[@]}";     do want[$i]=1; done ;;
    all)       for i in "${ALL[@]}";       do want[$i]=1; done; prune_after=1 ;;
    mariadb-docker) want[mariadb]=1 ;;
    *)         in_list "$t" "${ALL[@]}" || { echo "unknown image or group: $t (see: $0 list)" >&2; exit 2; }
               want[$t]=1 ;;
  esac
done

# ---------------------------------------------------------------- run
fail=()
for img in "${ALL[@]}"; do
  [ -n "${want[$img]:-}" ] || continue
  echo; echo "=== $img"
  if [ "$LEGACY" = 1 ]; then ( run_legacy "$img" ); else ( "up_$img" ); fi
  if [ $? -ne 0 ]; then
    echo "!! $img failed" >&2; fail+=("$img")
    [ "$KEEP_GOING" = 1 ] || break
  fi
done

if [ "$prune_after" = 1 ] && [ "$PRUNE" = 1 ] && [ ${#fail[@]} -eq 0 ]; then
  echo; run docker buildx prune -f -a
fi

echo
if [ ${#fail[@]} -gt 0 ]; then echo "failed: ${fail[*]}" >&2; exit 1; fi
echo "done"