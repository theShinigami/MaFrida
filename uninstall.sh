#!/system/bin/sh

MODPATH=${0%/*}
ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)


# delete frida server
if pgrep -f "frida-server" > /dev/null; then
    kill -9 $(pidof frida-server)
fi;

rm -rf "$MODPATH/files"



# delete binaries
rm -f "$MODPATH/system/bin/busybox-$ARCH"
rm -f "$MODPATH/system/bin/curl"
rm -f "$MODPATH/system/bin/curl-$ARCH"
rm -f "$MODPATH/system/bin/mafrida"
rm -f "$MODPATH/system/bin/nohup"
rm -f "$MODPATH/system/bin/xz"


echo "MaFrida uninstalled!"

