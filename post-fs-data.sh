#!/system/bin/sh

MODPATH=${0%/*}


exec 2> $MODPATH/logs/post-fs-data.log
set -x

ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)

remove_unused_binaries() {

    BIN_DIR="$MODPATH/system/bin"

    for bin in $(ls $BIN_DIR); do
        if [ -f "$BIN_DIR/$bin" ]; then
            if [[ "$bin" == *$ARCH ]]; then
                echo "- Found arch bin at $BIN_DIR/$bin, skipping..."
            else
                echo "- removing $BIN_DIR/$bin";
                rm "$BIN_DIR/$bin"
            fi
        fi
    done

}


prepare_frida_version_set_script() {

    # VERSION_DIR directory to the module directory
    sed -i "s|VERSION_DIR=\.|VERSION_DIR=$MODPATH|g" $MODPATH/scripts/frida_ver_set

    # copy to system/bin
    cp -f "$MODPATH/scripts/frida_ver_set" "$MODPATH/system/bin"

}


set_permission() {

    chmod +x "$MODPATH/system/bin/busybox-$ARCH"
    chmod +x "$MODPATH/system/bin/curl-$ARCH"
    chmod +x "$MODPATH/system/bin/frida_ver_set"

}


prepare_symlinks() {

    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/wget"
    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/nohup"
    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/xz"
    ln -s "$MODPATH/system/bin/curl-$ARCH" "$MODPATH/system/bin/curl"

}



remove_unused_binaries
prepare_frida_version_set_script
set_permission
prepare_symlinks


