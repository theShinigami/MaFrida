#!/system/bin/sh


prepare_logging() {

    [ ! -d $MODPATH/logs ] && mkdir -p $MODPATH/logs

    exec 2> $MODPATH/logs/customize.log
    set -x

}

check_device_arch() {

    case $ARCH in
      arm64)
        ;;
      arm)
        ;;
      x64)
        ;;
      x86)
        ;;
      *)
        ui_print "Unsupported architecture: $ARCH";
        abort;;  
    esac

    ui_print "- Detected architecture: $ARCH"

}


prepare_busybox() {

    ui_print "- preparing busybox..."

    ui_print "- Extracting system files..."
    unzip -o "$ZIPFILE" 'system/*' -d "$MODPATH"

}




prepare_logging
check_device_arch
prepare_busybox


ui_print "- Install complete"
ui_print "- Reboot your device to complete your installation!"


