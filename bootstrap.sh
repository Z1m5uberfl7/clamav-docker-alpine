#!/bin/bash

set -m

if [[ ! -z "${USE_FRESHCLAM_CONF_FILE}" ]]; then
    echo "USE_FRESHCLAM_CONF_FILE env var set, create backup /etc/clamav/freshclam.conf.bak of /etc/clamav/freshclam.conf"
    mv /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf.bak
    echo "Replace file /etc/clamav/freshclam.conf with /mnt/freshclam.conf"
    cp -f /mnt/freshclam.conf /etc/clamav/freshclam.conf
    dos2unix /etc/clamav/freshclam.conf
fi

if [[ ! -z "${USE_CLAMD_CONF_FILE}" ]]; then
    echo "USE_CLAMD_CONF_FILE env var set, create backup /etc/clamav/clamd.conf.bak of /etc/clamav/clamd.conf"
    mv /etc/clamav/clamd.conf /etc/clamav/clamd.conf.bak
    echo "Replace file /etc/clamav/clamd.conf with /mnt/clamd.conf"
    cp -f /mnt/clamd.conf /etc/clamav/clamd.conf
    dos2unix /etc/clamav/clamd.conf
fi

if [[ ! -z "${USE_MAIN_CVD_FILE}" ]]; then
    echo "USE_MAIN_CVD_FILE env var set, replace initial main.cvd file /db/main.cvd with /mnt/main.cvd"
    cp -f /mnt/main.cvd /db/main.cvd
fi

function clam_start () {
    # start clam service itself and the updater in background as daemon
    freshclam -d &
    clamd &
}

clam_start

# recognize PIDs
pidlist=$(jobs -p)

# initialize latest result var
latest_exit=0

# define shutdown helper
function shutdown() {
    trap "" SIGINT

    for single in $pidlist; do
        if ! kill -0 "$single" 2> /dev/null; then
            wait "$single"
            latest_exit=$?
        fi
    done

    kill "$pidlist" 2> /dev/null
}

# run shutdown
trap shutdown SIGINT
wait -n

# return received result
exit $latest_exit