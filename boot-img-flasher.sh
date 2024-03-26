#!/system/bin/sh

umask 022

# Global Variables
GREEN="\033[1;92m"
BLUE="\033[1;94m"
ERR="\033[0;31m"
NC="\033[0m"
OUTFD=$2
ZIPFILE=$3

supports_color() {
    [ -t 1 ] && command -v tput > /dev/null && tput colors > /dev/null
}

if ! supports_color; then GREEN= BLUE= ERR= NC=; fi

print_banner() {
    cat << "EOF"
    ____                 _      _                   
   | __ )   ___    ___  | |_   (_) _ __ ___     __ _ 
   |  _ \  / _ \  / _ \ | __|  | || '_ \` _ \  / _`|
   | |_) || (_) || (_) || |_   | || | | | | || (_| |
   |____/  \___/  \___/  \__|  |_||_| |_| |_| \__, |
      _____  _              _                  |___/ 
     |  ___|| |  __ _  ___ | |__    ___  _ __       
     | |_   | | / _` |/ __|| '_ \  / _ \| '__|      
     |  _|  | || (_| |\__ \| | | ||  __/| |         
     |_|    |_| \__,_||___/|_| |_| \___||_|         
                                                 
EOF
    echo -e "   ${BLUE}Flash boot image on dual slotted Android devices${NC}\n"
    echo -e "                  ${GREEN}Author: Abhijeet${NC}\n"
}
        
require_new_magisk() {
    ui_print "*******************************"
    ui_print " Please install Magisk v20.4+! "
    ui_print "*******************************"
    exit_with_error "Magisk version too old"
}

toupper() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

grep_cmdline() {
  local REGEX="s/^$1=//p"
  { echo $(cat /proc/cmdline) | xargs -n 1; \
    sed -e 's/ = /=/g' -e 's/, /,/g' -e 's/"//g' /proc/bootconfig; \
  } 2>/dev/null | sed -n "$REGEX"
}

grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}

exit_with_error() {
    echo -e "\n${ERR}Error: ${NC}$1"
    exit 1
}

find_boot_image() {
    local boot_image
    
    if [ -n "$PREFIX" ]; then
        # We are definitely in termux environment
        boot_image=$(find "$PWD" -maxdepth 1 -name '*.img' -type f -print -quit)
    else
        [ -f /data/adb/magisk/util_functions.sh ] || require_new_magisk
        . /data/adb/magisk/util_functions.sh
        [ $MAGISK_VER_CODE -lt 20400 ] && require_new_magisk
        rm -rf $TMPDIR
        mkdir -p $TMPDIR
        chcon u:object_r:system_file:s0 $TMPDIR
        cd $TMPDIR
        # Extract any .img file from ZIP file
        unzip -o "$ZIPFILE" '*.img' -d $TMPDIR >&2 || exit_with_error "Unable to extract boot image"
        boot_image=$(find "$TMPDIR" -maxdepth 1 -name '*.img' -type f -print -quit)
    fi
    
    if [ -n "$boot_image" ]; then
       echo "$boot_image"
       return 0
    fi
    return 1
}


find_boot_block() {
    local BLOCK DEV DEVICE DEVNAME PARTNAME UEVENT
    for BLOCK in "$@"; do
        DEVICE=$(find /dev/block \( -type b -o -type c -o -type l \) -iname "$BLOCK" 2>/dev/null | head -n 1)
        if [ -n "$DEVICE" ]; then
            readlink -f "$DEVICE"
            return 0
        fi
    done
    for UEVENT in /sys/dev/block/*/uevent; do
        DEVNAME=$(grep_prop DEVNAME "$UEVENT")
        PARTNAME=$(grep_prop PARTNAME "$UEVENT")
        for BLOCK in "$@"; do
            if [ "$(toupper "$BLOCK")" = "$(toupper "$PARTNAME")" ]; then
                echo /dev/block/"$DEVNAME"
                return 0
            fi
        done
    done
    return 1
}

flash_image() {
    local CMD1
    case "$1" in
        *.gz) CMD1="gzip -d < '$1'";;
        *)    CMD1="cat '$1'";;
    esac
    if [ -b "$2" ]; then
        local img_sz=$(stat -c '%s' "$1")
        local blk_sz=$(blockdev --getsize64 "$2")
        local blk_bs=$(blockdev --getbsz "$2")
        if [ "$img_sz" -gt "$blk_sz" ]; then return 1; fi
        blockdev --setrw "$2"
        local blk_ro=$(blockdev --getro "$2")
        if [ "$blk_ro" -eq 1 ]; then return 2; fi
        eval "$CMD1" | dd of="$2" bs="$blk_bs" iflag=fullblock conv=notrunc,fsync && sync
    elif [ -c "$2" ]; then
        flash_eraseall "$2"
        eval "$CMD1" | nandwrite -p "$2" && sync
    else
        return 3
    fi
    return 0
}

main() {
    # Check if running as root
    if [ "$(id -u)" -ne 0 ]; then
        exit_with_error "This script requires root privileges to execute. Please run as root."
    fi
    
    mount /data 2>/dev/null
    
    print_banner

    local boot_block boot_image slot
    slot=$(grep_cmdline androidboot.slot_suffix)
    if [ -z "$slot" ]; then
        slot=$(grep_cmdline androidboot.slot)
        slot=${slot:+_"$slot"}
    fi
    [ "$slot" = "_normal" ] && slot=""

    if [ -n "$slot" ]; then
        echo "- Current boot slot: $slot"
    else
        exit_with_error "No boot slot information found. Cannot proceed without slot information."
    fi

    echo "- Finding the boot block, please wait..."
    sleep 10
    boot_block=$(find_boot_block "boot$slot") || exit_with_error "Boot block not found. Cannot proceed with flashing."

    echo "- Checking for boot image, please wait..."
    sleep 5
    boot_image=$(find_boot_image) || exit_with_error "Boot image not found. Cannot proceed with flashing."

    echo "- Flashing boot image to $boot_block..."
    if ! flash_image "$boot_image" "$boot_block"; then
        case $? in
            1) exit_with_error "Failed to flash boot image. Boot image size is larger than the boot block size.";;
            2) exit_with_error "Failed to flash boot image. Boot block is read-only.";;
            3) exit_with_error "Failed to flash boot image. '$boot_block' is not a block or character device.";;
            *) exit_with_error "Failed to flash boot image due to an unknown error.";;
        esac
    fi
    echo -e "- ${GREEN}Boot image flashed successfully"
}

main "$@"