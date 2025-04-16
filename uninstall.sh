#!/system/bin/sh

MODPATH=${0%/*}
ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)


# delete frida server
if pgrep -f "frida-server" > /dev/null; then
    kill -9 $(pidof frida-server)
fi;

rm -rf "$MODPATH/files"



# delete binaries
rm -f "$MODPATH/busybox-$ARCH"
rm -f "$MODPATH/curl"
rm -f "$MODPATH/curl-$ARCH"
rm -f "$MODPATH/frida_ver_set"
rm -f "$MODPATH/nohup"
rm -f "$MODPATH/xz"


echo "MaFrida uninstalled!"

