#!/bin/bash
# see README.md for details

set -eu

HOSTNAME=$(hostname)
TARGET_HOST=$1
START_TIME=$(date --rfc-3339=seconds)
LOGFILE="$PWD/${HOSTNAME}_${TARGET_HOST}_${START_TIME}.log"
INPUT_FILE=/tmp/scp-test-input-file
TARGET_DIR=/tmp/scp-test-target-dir

logcmd(){
    $@ > >(tee -a "$LOGFILE") 2> >(tee -a "$LOGFILE" >&2)
}

log() {
  logcmd echo "$(date --rfc-3339=seconds): $@"
}


copyfiles() {
    log "creating input file in $INPUT_FILE"
    logcmd dd if=/dev/urandom of=$INPUT_FILE bs=1M count=20
    log "copying files..."
    logcmd ssh $TARGET_HOST "mkdir -p $TARGET_DIR"
    for i in {001..100}
    do
        log "upload # $i..."
        logcmd scp -v $INPUT_FILE $TARGET_HOST:$TARGET_DIR/test_$i
    done
    log "list of $TARGET_HOST:$TARGET_DIR:"
    logcmd ssh $TARGET_HOST "ls -l $TARGET_DIR"
}

cleanup() {
    log "cleaning up ..."
    rm -f $INPUT_FILE
    logcmd ssh $TARGET_HOST "rm -rf $TARGET_DIR"
}
log "Using logfile: $LOGFILE"

trap cleanup EXIT
copyfiles
trap '' EXIT

cleanup