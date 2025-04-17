#!/system/bin/sh


MODPATH=${0%/*}

# logging
exec 2> $MODPATH/logs/service.log
set -x


. $MODPATH/common.sh

sleep 20 # sleep for 20 second, to warm up the device
init_download_dir
init_frida_server
run_frida

