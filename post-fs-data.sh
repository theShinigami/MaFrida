#!/system/bin/sh

MODPATH=${0%/*}


exec 2> $MODPATH/logs/post-fs-data.log
set -x

ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)

remove_unused_binaries() {

    BIN_DIR="$MODPATH/system/bin"

    for busy_bin in $(ls $BIN_DIR); do
        if [ -f "$BIN_DIR/$busy_bin" ]; then
            if [[ "$busy_bin" == *$ARCH ]]; then
                echo "- Found arch busybox at $BIN_DIR/$busy_bin, skipping..."
            else
                echo "- removing $BIN_DIR/$busy_bin";
                rm "$BIN_DIR/$busy_bin"
            fi
        fi
    done

}


set_permission() {

    chmod +x "$MODPATH/system/bin/busybox-$ARCH"

}


prepare_symlinks() {

    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/wget"
    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/nohup"

}



remove_unused_binaries
set_permission
prepare_symlinks


