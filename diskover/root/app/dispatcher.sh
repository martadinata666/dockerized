#!/usr/bin/with-contenv bash

. /config/.env

# define array for input values
declare -A DISKOVER_ARRAY
DISKOVER_ARRAY[TODAY]=$(date +%Y-%m-%d)
DISKOVER_ARRAY[INDEX_PREFIX]=${INDEX_PREFIX:-diskover-}
DISKOVER_ARRAY[INDEX_NAME]=${INDEX_NAME:-${DISKOVER_ARRAY[INDEX_PREFIX]}${DISKOVER_ARRAY[TODAY]}}
DISKOVER_ARRAY[DISKOVER_OPTS]=${DISKOVER_OPTS:-}" -d /data -a"
DISKOVER_ARRAY[WORKER_OPTS]=${WORKER_OPTS:-""}
DISKOVER_ARRAY[REDIS_HOST]=${REDIS_HOST:-redis}
DISKOVER_ARRAY[REDIS_PORT]=${REDIS_PORT:-6379}
DISKOVER_ARRAY[DISKOVER_OPTS]="${DISKOVER_ARRAY[DISKOVER_OPTS]} -i ${DISKOVER_ARRAY[INDEX_NAME]}"
DISKOVER_ARRAY[YESTERDAY]=$(date --date="1 day ago" +%Y-%m-%d)
DISKOVER_ARRAY[PREV_INDEX]=${INDEX_NAME:-${DISKOVER_ARRAY[INDEX_PREFIX]}${DISKOVER_ARRAY[YESTERDAY]}}


cd /app/diskover || exit

/bin/bash /app/cleanup.sh

echo "starting workers with following options: ${DISKOVER_ARRAY[WORKER_OPTS]}"
/bin/bash /app/diskover/diskover-bot-launcher.sh ${DISKOVER_ARRAY[WORKER_OPTS]}

echo "starting crawler with following options: ${DISKOVER_ARRAY[DISKOVER_OPTS]}"
/usr/bin/python3 /app/diskover/diskover.py ${DISKOVER_ARRAY[DISKOVER_OPTS]}

echo "starting crawler with following options: ${DISKOVER_ARRAY[DISKOVER_OPTS]}"
/usr/bin/python3 /app/diskover/diskover.py --finddupes ${DISKOVER_ARRAY[DISKOVER_OPTS]}

echo "starting crawler finding hotdirs ${DISKOVER_ARRAY[DISKOVER_OPTS]}"
/usr/bin/python3 /app/diskover/diskover.py --hotdirs ${DISKOVER_ARRAY[PREV_INDEX]} ${DISKOVER_ARRAY[DISKOVER_OPTS]}
