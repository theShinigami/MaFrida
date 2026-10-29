MODPATH=${0%/*}
BASE="https://github.com/frida/frida/releases"
BASE_API="https://api.github.com/repos/frida/frida/releases"
ARCH=$(getprop ro.product.cpu.abi | cut -d '-' -f1)
RETRY=10
CONFIG_DIR="$MODPATH/.config"
CONFIG_FILE="$CONFIG_DIR/config"


set_config() {

    local key="$1"
    local value="$2"

    if grep -q "^${key}=" "$CONFIG_FILE" 2>/dev/null; then
        sed -i "s/^${key}=.*/${key}=${value}/" "$CONFIG_FILE"
    else
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi;

}


get_config() {

    local key="$1"
    local default="$2"

    local value
    value=$(grep "^${key}=" "$CONFIG_FILE" 2>/dev/null | cut -d'=' -f2-)

    echo "${value:-$default}"

}


set_config_to_default() {

    set_config SERVER_PORT 27042
    set_config SERVER_IP 127.0.0.1
    set_config START_ON_BOOT false
    set_config FRIDA_VERSION latest
    set_config FRIDA_SERVER_FILENAME shiny-egg

}


# Returns the major version cap for this device based on Android SDK level.
#   SDK <= 22 (Android 5)   -> cap at Frida 15
#   SDK 23    (Android 6)   -> cap at Frida 16.1
#   SDK 24-28 (Android 7-9) -> cap at Frida 16
#   SDK 29+   (Android 10+) -> no cap (empty string)
function get_max_frida_prefix() {

    local sdk
    sdk=$(getprop ro.build.version.sdk)

    [ -z "$sdk" ] && echo "" && return

    if   [ "$sdk" -le 22 ]; then echo "15"
    elif [ "$sdk" -le 23 ]; then echo "16.1"
    elif [ "$sdk" -le 28 ]; then echo "16"
    else                          echo ""
    fi;

}


# Fetch the latest Frida release tag matching a version prefix, paginating
# through GitHub API results to handle repos with >100 releases (Frida has 200+).
#
# Prefix matching rules:
#   "15"   -> matches 15.x.y  (NOT 15 matching 150.x)
#   "16"   -> matches 16.x.y  but NOT 16.1.y  (16.1 is a tighter cap)
#   "16.1" -> matches 16.1.y  only
function get_latest_with_prefix() {

    local prefix="$1"
    local page=1
    local found=""

    # Build the grep pattern:
    #   "15"   -> ^15\.[0-9]   so 15.0.x, 15.1.x ... but not 150.x
    #   "16"   -> ^16\.[0-9]   so 16.0.x ... 16.9.x but not 16.10+ treated wrong
    #             actually semver minor can be multi-digit: use ^16\.[0-9]+ which
    #             in POSIX grep is ^16\.[0-9][0-9]*
    #   "16.1" -> ^16\.1\.
    local pattern
    local dot_count
    dot_count=$(echo "$prefix" | tr -cd '.' | wc -c)

    if [ "$dot_count" -eq 0 ]; then
        # prefix is just a major, e.g. "15" or "16"
        # match major.minor.patch but NOT a tighter sub-series
        # e.g. for "16": match 16.2.x, 16.5.x but we intentionally
        # INCLUDE all minor versions (the cap table already chose "16" meaning all 16.x)
        pattern="^${prefix}\.[0-9]"
    else
        # prefix is major.minor, e.g. "16.1"
        pattern="^${prefix}\."
    fi;

    while true; do

        local response
        response=$(curl --retry $RETRY -sk "$BASE_API?per_page=100&page=${page}" \
            | grep '"tag_name"' \
            | sed 's/.*"tag_name": "\([^"]*\)".*/\1/')

        # Empty page means no more results
        [ -z "$response" ] && break

        found=$(echo "$response" | grep -E "$pattern" | head -1)
        [ -n "$found" ] && break

        page=$((page + 1))

        # Safety cap: don't paginate forever (100 pages = 10000 releases)
        [ "$page" -gt 10 ] && break

    done;

    echo "$found"

}


function get_frida_version() {

    local frida_version
    frida_version=$(get_config FRIDA_VERSION latest)

    # User pinned a specific version - validate it exists, use as-is
    if [ "$frida_version" != "latest" ]; then

        local tag_status
        tag_status=$(curl --retry $RETRY -sk "$BASE_API/tags/$frida_version" \
            | sed -n 's/.*"status": "\([^"]*\)".*/\1/p')

        if [ "$tag_status" != "404" ]; then
            echo "$frida_version"
            return
        fi;

        echo "- Warning: version '$frida_version' not found, falling back to auto-detect..." >&2

    fi;

    # Auto-detect: check Android SDK and pick the latest compatible version
    local prefix
    prefix=$(get_max_frida_prefix)

    if [ -n "$prefix" ]; then
        local sdk
        sdk=$(getprop ro.build.version.sdk)
        echo "- Android SDK ${sdk} detected, selecting latest Frida ${prefix}.x..." >&2

        local best
        best=$(get_latest_with_prefix "$prefix")

        if [ -n "$best" ]; then
            echo "- Compatible version: ${best}" >&2
            echo "$best"
            return
        fi;

        echo "- Warning: no ${prefix}.x release found, falling back to latest..." >&2
    fi;

    # Android 10+ or fallback: grab the latest release
    curl --retry $RETRY -sk "$BASE_API/latest" \
        | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p'

}


function init_download_dir() {

    frida_server_filename=$(get_config FRIDA_SERVER_FILENAME shiny-egg)

    # Remove existing binary if present
    if [ -f "$MODPATH/files/$frida_server_filename" ]; then
        echo "- Removing old binary '$frida_server_filename'..."
        rm -f "$MODPATH/files/$frida_server_filename"
    fi;

    # Create files directory if it doesn't exist yet
    if [ ! -d "$MODPATH/files" ]; then
        echo "- Creating 'files' directory"
        mkdir -p "$MODPATH/files"
    fi;

}


function init_frida_server() {

    frida_version=$(get_frida_version)
    server_file="frida-server-${frida_version}-android-${ARCH}"
    download_url="$BASE/download/${frida_version}/${server_file}.xz"
    frida_server_filename=$(get_config FRIDA_SERVER_FILENAME shiny-egg)


    if [ -f "$MODPATH/files/$frida_server_filename" ]; then

        # get downloaded frida server version
        current_server_version=$($MODPATH/files/$frida_server_filename --version | tr -d '[:space:]')

        if [ "$current_server_version" = "$frida_version" ]; then
            echo "- Server already downloaded!"
        else
            curl --retry $RETRY -L -k --progress-bar -o "$MODPATH/files/$frida_server_filename.xz" "$download_url"

            # extract
            xz -f -d "$MODPATH/files/$frida_server_filename.xz"

            # set exec permission
            chmod +x "$MODPATH/files/$frida_server_filename"

        fi;

    else
        curl --retry $RETRY -L -k --progress-bar -o "$MODPATH/files/$frida_server_filename.xz" "$download_url"

        # extract
        xz -f -d "$MODPATH/files/$frida_server_filename.xz"

        # set exec permission
        chmod +x "$MODPATH/files/$frida_server_filename"

    fi;

}


function rename_server_filename() {

    frida_server_filename=$(get_config FRIDA_SERVER_FILENAME shiny-egg)

    if [ -f "$MODPATH/files/$frida_server_filename" ]; then
        mv "$MODPATH/files/$frida_server_filename" "$MODPATH/files/$1"
    fi;

}


function run_frida() {

    frida_server_filename=$(get_config FRIDA_SERVER_FILENAME shiny-egg)
    port=$(get_config SERVER_PORT 27042)
    ip=$(get_config SERVER_IP 127.0.0.1)

    if pgrep -f "$frida_server_filename" > /dev/null; then
        pkill "$frida_server_filename"
        # second time is the charm ;)
        kill -9 $(pidof $frida_server_filename)
    fi;

    # start server in background
    nohup "$MODPATH/files/$frida_server_filename" --listen "$ip:$port" \
        > /dev/null 2>&1 &

}
