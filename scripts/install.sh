#!/system/bin/sh

#############################

# variables
export FW_DIR=/system/etc/firmware/ti-connectivity
export KO_DIR=/system/lib/modules/
export BIN_DIR=.

#############################

# pre-install operations
sh ./ps_lock
echo stopping android
stop
echo re-mounting /system with rw permissions
mount -o remount -w /system

#############################

# install firmware, nvs, and driver files
echo copying firmware files to $FW_DIR
find . -name 'wl12*-fw-multirole-*.bin' -exec cp -f {} $FW_DIR \;
echo copying nvs files to $FW_DIR
find . -name '*-nvs.bin' -exec cp -f {} $FW_DIR \;
echo copying driver files \(kernel objects\) to $KO_DIR
find . -name '*.ko' -exec cp -f {} $KO_DIR \;

# install symbolic links to start/stop scripts
ln -s ./sta/sta_start.sh ./start_sta.sh
ln -s ./sta/sta_stop.sh ./stop_sta.sh
ln -s ./ap/ap_start.sh ./start_ap.sh
ln -s ./ap/ap_stop.sh ./stop_ap.sh
ln -s ./ap/p2p_start.sh ./start_p2p.sh
ln -s ./ap/p2p_stop.sh ./stop_p2p.sh

#############################

# post-install operations
echo synchronizing fs, and re-mounting /system to ro
sync
mount -o remount -e /system
echo resuming android
start
