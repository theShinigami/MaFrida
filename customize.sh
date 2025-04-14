
ui_print "---------- DEBUG PRINTS ----------"
ui_print "Currect Magisk Version: $MAGISK_VER"
ui_print "Currect Magisk Version code: $MAGISK_VER_CODE"
ui_print "Boot Mode: $BOOTMODE"
ui_print "Temp directory: $TMPDIR"
ui_print "Module installation zip: $ZIPFILE"
ui_print "Device architecture: $ARCH"
ui_print "Is Arch x64: $IS64BIT"
ui_print "Android API level: $API"
ui_print "Module path: $MODPATH"
ui_print "----------------------------------"


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


prepare_binaries() {

    ui_print "- Preparing binaries..."

    ui_print "- wget..."
    ln -s "$MODPATH/system/bin/busybox-$ARCH" "$MODPATH/system/bin/wget"

}


check_device_arch
prepare_busybox
prepare_binaries


