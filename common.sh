MODPATH=${0%/*}
BASE="https://github.com/frida/frida/releases"
BASE_API="https://api.github.com/repos/frida/frida/releases"
ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)
FRIDA_VERSION_FILE="frida_version.txt"
RETRY=10
FRIDA_SERVER_FILENAME="shiny-egg"


function get_frida_version() {

    if [ -f "$MODPATH/$FRIDA_VERSION_FILE" ]; then
        frida_version=$(cat "$MODPATH/$FRIDA_VERSION_FILE")
        
        # make sure the version exists in the repo
        if [ "$frida_version" != "latest" ]; then
            tag_response=$(curl --retry $RETRY -k "$BASE_API/tags/$frida_version" | sed -n 's/.*"status": "\([^"]*\)".*/\1/p')
            
            # if the tag reponse is 404, default to latest
            if [ "$tag_response" == "404" ]; then
                frida_version="latest"
            else
                echo "$frida_version"
            fi;
        fi;

        if [ "$frida_version" == "latest" ]; then
            echo $(curl --retry $RETRY -k "$BASE_API/latest" | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')
        fi;
    
    else
        LATEST_VERSION=$(curl --retry $RETRY -k "$BASE_API/latest" | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')
        echo $LATEST_VERSION
    fi;

}


function init_download_dir() {

    if [ -d "$MODPATH/files/$FRIDA_SERVER_FILENAME" ]; then
        echo "- '$FRIDA_SERVER_FILE' directory exists, cleaning..."
        rm -f "$MODPATH/files/FRIDA_SERVER_FILENAME"
    else
        echo "- Creating 'files' directory"
        mkdir "$MODPATH/files"
    fi;

}


function init_frida_server() {

    frida_version=$(get_frida_version)
    server_file="frida-server-${frida_version}-android-${ARCH}"
    download_url="$BASE/download/${frida_version}/${server_file}.xz"


    if [ -f "$MODPATH/files/$FRIDA_SERVER_FILENAME" ]; then

        # get downloaded frida server version
        current_server_version=$($MODPATH/files/$FRIDA_SERVER_FILENAME --version | tr -d '[:space:]')

        if [ $current_server_version == $frida_version ]; then
            echo "- Server already downloaded!"
        else
            curl --retry $RETRY -L -k -o "$MODPATH/files/$FRIDA_SERVER_FILENAME.xz" "$download_url"

            # extract
            xz -f -d "$MODPATH/files/$FRIDA_SERVER_FILENAME.xz"
            
            # set exec permission
            chmod +x "$MODPATH/files/$FRIDA_SERVER_FILENAME"
        
        fi;
    
    else
        curl --retry $RETRY -L -k -o "$MODPATH/files/$FRIDA_SERVER_FILENAME.xz" "$download_url"
            
        # extract
        xz -f -d "$MODPATH/files/$FRIDA_SERVER_FILENAME.xz"
            
        # set exec permission
        chmod +x "$MODPATH/files/$FRIDA_SERVER_FILENAME"

    fi;

}


function run_frida() {

    if pgrep -f "$FRIDA_SERVER_FILENAME" > /dev/null; then
        pkill "$FRIDA_SERVER_FILENAME"
        # second time is the charm ;)
        kill -9 $(pidof $FRIDA_SERVER_FILENAME)
    fi;

    # start server
    nohup "$MODPATH/files/$FRIDA_SERVER_FILENAME"


}