#!/usr/bin/env bash
# build-images.sh - build the images that have a make-image.sh, in dependency order.
#
# Commands are taken from each folder's make-image.sh. Differences:
#   * registry/namespace is a variable (REGISTRY) instead of hard-coded
#   * apache and php-fpm use the renamed files fpm/8.4/Dockerfile and 8.4/Dockerfile
#     (their make-image.sh still points at the old Dockerfile.fpm / Dockerfile.build)
#   * missing Dockerfiles are reported before anything is built
#
# Put this file in the repo root (next to the image folders) and run:
#   ./build-images.sh list
#   ./build-images.sh all
#   ./build-images.sh --deps heimdall          # heimdall + everything it builds on
#   ./build-images.sh -n all                   # dry run: print commands only
#   ./build-images.sh -m node nginx            # run each folder's own make-image.sh as-is

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REGISTRY="${REGISTRY:-192.168.0.2:6060/dedyms}"
RUST_VERSION="${RUST_VERSION:-1.97.0}"        # from rust/make-image.sh
HEIMDALL_RELEASE="${HEIMDALL_RELEASE:-v2.8.4}" # from heimdall/make-image.sh
UNMANIC_RELEASE="${UNMANIC_RELEASE:-staging}"  # from unmanic/make-image.sh

DRY_RUN=0
WITH_DEPS=0
KEEP_GOING=0
USE_MAKE_IMAGE=0
OUT_FLAG="--push"

# Build order (a lower layer is always built before the next one).
#   1 debian
#   2 ffmpeg ffmpeg-static php-fpm rust mariadb
#   3 node nginx apache
#   4 heimdall shinobi unmanic
ORDER=(debian ffmpeg ffmpeg-static php-fpm mariadb node nginx apache)

# image -> folder (only where it differs)
dir_of() { case "$1" in mariadb) echo mariadb-docker ;; *) echo "$1" ;; esac; }

# image -> images it is built FROM (from the FROM lines)
deps_of() {
  case "$1" in
    php-fpm) echo debian ;;
    rust)    echo debian ;;
    mariadb) echo debian ;;
    node)    echo "debian ffmpeg" ;;      # node:lts-ffmpeg is built from ffmpeg:8
    nginx)   echo "debian php-fpm" ;;
    apache)  echo php-fpm ;;
    heimdall) echo "php-fpm nginx" ;;
    shinobi) echo node ;;
    unmanic) echo "node ffmpeg" ;;
    *) echo "" ;;
  esac
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <image ...|all|list>

Options:
  -n, --dry-run     print the commands, do not run them
  -d, --deps        also build every image the selected ones are built on
  -k, --keep-going  continue with the next image if one fails
  -m, --make-image  run each folder's own make-image.sh instead of the commands
                    in this script (registry is still replaced); stale file
                    names in apache/ and php-fpm/ will fail in this mode
      --no-push     build and load locally (single platform) instead of pushing
  -h, --help        show this help

Environment: REGISTRY (default $REGISTRY), RUST_VERSION, HEIMDALL_RELEASE, UNMANIC_RELEASE

Images: ${ORDER[*]}
EOF
}

run() {
  echo "+ $*"
  if [ "$DRY_RUN" = 0 ]; then "$@"; fi
}

need() {  # need <folder> <file...>: make sure the Dockerfiles exist
  local d="$1"; shift
  local f missing=0
  for f in "$@"; do
    if [ ! -f "$ROOT/$d/$f" ]; then
      echo "  missing: $d/$f" >&2
      missing=1
    fi
  done
  return $missing
}

# Each function is the make-image.sh of that folder.
build_debian() {
  need debian trixie/Dockerfile trixie/Dockerfile.dev || return 1
  cd "$ROOT/debian"
  run docker buildx build . -f trixie/Dockerfile \
      -t "$REGISTRY/debian:latest" \
      -t "$REGISTRY/debian:trixie" \
      $OUT_FLAG
  run docker buildx build . -f trixie/Dockerfile.dev -t "$REGISTRY/debian:dev" $OUT_FLAG
}

build_ffmpeg() {
  need ffmpeg 8/Dockerfile || return 1
  cd "$ROOT/ffmpeg"
  run docker buildx build . -f 8/Dockerfile -t "$REGISTRY/ffmpeg:8" $OUT_FLAG
}

build_ffmpeg_static() {
  need ffmpeg-static Dockerfile || return 1
  cd "$ROOT/ffmpeg-static"
  run docker buildx build . -f Dockerfile -t "$REGISTRY/ffmpeg-static:latest" $OUT_FLAG
}

build_php_fpm() {
  need php-fpm 8.4/Dockerfile || return 1   # was 8.4/Dockerfile.build
  cd "$ROOT/php-fpm"
  run docker buildx build . -f 8.4/Dockerfile -t "$REGISTRY/php-fpm:8.4" $OUT_FLAG --progress=plain
  # optional: run docker buildx build . -f 8.4/Dockerfile.build.pie -t "$REGISTRY/php-fpm:8.4-pie" $OUT_FLAG --no-cache --progress=plain
}

build_rust() {
  need rust Dockerfile || return 1
  cd "$ROOT/rust"
  run docker buildx build --build-arg RUST_VERSION="$RUST_VERSION" $OUT_FLAG . -f Dockerfile \
      -t "$REGISTRY/rust:$RUST_VERSION" --progress=plain
}

build_mariadb() {
  need mariadb-docker 11.8/Dockerfile.debian || return 1
  cd "$ROOT/mariadb-docker"
  run docker buildx build . -f 11.8/Dockerfile.debian -t "$REGISTRY/mariadb:lts" $OUT_FLAG --progress=plain
}

build_node() {
  need node 24/Dockerfile 24/Dockerfile.dev 24/Dockerfile.ffmpeg || return 1
  cd "$ROOT/node"
  run docker buildx build . -f 24/Dockerfile        -t "$REGISTRY/node:lts"        $OUT_FLAG
  run docker buildx build . -f 24/Dockerfile.dev    -t "$REGISTRY/node:lts-dev"    $OUT_FLAG
  run docker buildx build . -f 24/Dockerfile.ffmpeg -t "$REGISTRY/node:lts-ffmpeg" $OUT_FLAG
}

build_nginx() {
  need nginx fpm/Dockerfile.fpm8.4 || return 1
  cd "$ROOT/nginx"
  run docker buildx build . -f fpm/Dockerfile.fpm8.4 -t "$REGISTRY/nginx:mainline-fpm8.4" $OUT_FLAG --pull
}

build_apache() {
  need apache fpm/8.4/Dockerfile || return 1   # was fpm/8.4/Dockerfile.fpm
  cd "$ROOT/apache"
  run docker buildx build . -f fpm/8.4/Dockerfile -t "$REGISTRY/apache:fpm" $OUT_FLAG --pull
}

build_heimdall() {
  need heimdall Dockerfile || return 1
  cd "$ROOT/heimdall"
  run docker buildx build --build-arg RELEASE="$HEIMDALL_RELEASE" . -f Dockerfile \
      -t "$REGISTRY/heimdall:${HEIMDALL_RELEASE#v}" $OUT_FLAG --pull
}

build_shinobi() {
  need shinobi Dockerfile || return 1
  cd "$ROOT/shinobi"
  run docker buildx build . -f Dockerfile -t "$REGISTRY/shinobi:git" $OUT_FLAG
}

build_unmanic() {
  need unmanic Dockerfile || return 1
  cd "$ROOT/unmanic"
  run docker buildx build --build-arg RELEASE="$UNMANIC_RELEASE" . -f Dockerfile \
      -t "$REGISTRY/unmanic:git" $OUT_FLAG
}

# Run the folder's own make-image.sh with the registry replaced.
build_with_make_image() {
  local img="$1" d; d="$(dir_of "$img")"
  local script="$ROOT/$d/make-image.sh"
  [ -f "$script" ] || { echo "  missing: $d/make-image.sh" >&2; return 1; }
  echo "+ (cd $d && sh make-image.sh)  [registry -> $REGISTRY]"
  if [ "$DRY_RUN" = 0 ]; then
    (cd "$ROOT/$d" && sed "s#192\.168\.0\.2:6060/dedyms#$REGISTRY#g" make-image.sh | bash -e)
  fi
}

build_one() {
  local img="$1"
  echo
  echo "=== $img"
  if [ "$USE_MAKE_IMAGE" = 1 ]; then
    build_with_make_image "$img"
  else
    "build_${img//-/_}"
  fi
}

# --- argument parsing ---------------------------------------------------------
targets=()
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run)    DRY_RUN=1 ;;
    -d|--deps)       WITH_DEPS=1 ;;
    -k|--keep-going) KEEP_GOING=1 ;;
    -m|--make-image) USE_MAKE_IMAGE=1 ;;
    --no-push)       OUT_FLAG="--load" ;;
    -h|--help)       usage; exit 0 ;;
    list)            printf '%s\n' "${ORDER[@]}"; exit 0 ;;
    all)             targets=("${ORDER[@]}") ;;
    -*)              echo "unknown option: $1" >&2; usage; exit 2 ;;
    *)               targets+=("$1") ;;
  esac
  shift
done

[ ${#targets[@]} -gt 0 ] || { usage; exit 2; }

# validate names
for t in "${targets[@]}"; do
  found=0
  for o in "${ORDER[@]}"; do [ "$o" = "$t" ] && found=1; done
  [ "$found" = 1 ] || { echo "unknown image: $t (see: $0 list)" >&2; exit 2; }
done

# add prerequisites when asked
declare -A want=()
add_with_deps() {
  local i="$1" d
  [ -n "${want[$i]:-}" ] && return 0
  want[$i]=1
  if [ "$WITH_DEPS" = 1 ]; then
    for d in $(deps_of "$i"); do add_with_deps "$d"; done
  fi
}
for t in "${targets[@]}"; do add_with_deps "$t"; done

# build in dependency order
fail=()
for img in "${ORDER[@]}"; do
  [ -n "${want[$img]:-}" ] || continue
  if ! ( build_one "$img" ); then
    echo "!! $img failed" >&2
    fail+=("$img")
    [ "$KEEP_GOING" = 1 ] || break
  fi
done

echo
if [ ${#fail[@]} -gt 0 ]; then
  echo "failed: ${fail[*]}" >&2
  exit 1
fi
echo "done"