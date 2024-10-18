#!/system/bin/sh

#############################################################################################
#                                ::  Boot Image Flasher ::
#############################################################################################
#
#══════════════════════════════════════════════════════════════════════════
# Usage:
#   boot-img-flasher.sh [-h|--help]
#   boot-img-flasher.sh <image_path> --image-type <type> 
#
# Options:
#   -h, --help         Show help message and exit
#   -t, --image-type   Specify the image type to be flashed
#
# Arguments:
#   <image_path>       Path to the boot or init_boot image file.
#   <type>             Accepted values are either boot or init_boot
#
#══════════════════════════════════════════════════════════════════════════
# Features:
# * Supports dual partition flash: capable of automatically detecting 
#   and flashing both init_boot and boot images.
# * Automated and User-Friendly: Simplifies the image flashing process with 
#   minimal user intervention.
# * Universal Compatibility: Works on any Android device, supporting both A/B
#   and legacy (non-A/B) partition styles.
# * Saves Time and Effort: Reduces the complexity of flashing boot 
#   and init_boot images, eliminating the need for fastboot or custom recoveries.
# * Flexible Usage: Operates in Termux with command-line options or can be flashed 
#   over Magisk as a module, priorities different use cases and preferences.
#
#══════════════════════════════════════════════════════════════════════════
# File Structure:
#   boot-img-flasher.sh   Main script file
#   *.img                 Boot or init_boot image to be flashed (if not provided as an argument)
#
#══════════════════════════════════════════════════════════════════════════
# Author: Abhijeet
# Source: @gitclone-url/Boot-img-flasher
#
#############################################################################################

umask 022

# Determine execution environment by checking for Termux-specific environment variable.
# If absent, assume Magisk environment and enable debug tracing

[ -n "$TERMUX_VERSION" ] || [ -n "$PREFIX" ] || { export DEBUG=true; set -o xtrace; }

# Global Variables
GREEN="\033[1;92m"
BLUE="\033[1;94m"
ERR="\033[0;31m"
NC="\033[0m"
OUTFD=$2
ZIPFILE=$3

print_banner() {
    local banner_text='Boot img Flasher'
    
    local author='Author: Abhijeet'
    local git_source='@gitclone-url/Boot-img-flasher'
    local description='A tool for Flashing boot/init_boot images on any android devices'
    
    center_text() {
        local text="$1"
        local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
        local terminal_width=$(tput cols)
        local padding_width=$(( (terminal_width - ${#clean_text}) / 2 ))
        printf "%*s%b%*s\n" $padding_width "" "$text" $padding_width "" && echo
     }

    # Check if 'figlet' is available, and use it to display our ASCII art banner.
    # With the addition of '-c' and '-t' option, to ensure proper alignment.
    if command -v figlet > /dev/null; then
        figlet -ct "$banner_text"
        center_text "${BLUE}$description${NC}"
        center_text "${GREEN}$author${NC}"
        center_text "\033[3mGit Source: $git_source${NC}"
    else
        # Fallback to default ASCII banner for magisk!
        echo    "   _____                                                     _____"
        echo    "  ( ___ )                                                   ( ___ )"
        echo    "   |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   |"
        echo    "   |   |    ____                 _     _                     |   |"
        echo    "   |   |   | __ )   ___    ___  | |_  (_) _ __ ___    __ _   |   |" 
        echo    "   |   |   |  _ \  / _ \  / _ \ | __| | || '_   _ \  / _  |  |   |" 
        echo    "   |   |   | |_) || (_) || (_) || |_  | || | | | | || (_| |  |   |" 
        echo    "   |   |   |____/  \___/  \___/  \__| |_||_| |_| |_| \__, |  |   |" 
        echo    "   |   |    _____  _              _                  |___/   |   |"
        echo    "   |   |   |  ___|| |  __ _  ___ | |__    ___  _ __          |   |"
        echo    "   |   |   | |_   | | / _  |/ __|| '_ \  / _ \| '__|         |   |"
        echo    "   |   |   |  _|  | || (_| |\__ \| | | ||  __/| |            |   |"
        echo    "   |   |   |_|    |_| \__,_||___/|_| |_| \___||_|            |   |"
        echo    "   |   |                                                     |   |"
        echo    "   |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___|"
        echo    "  (_____)                                                   (_____)"
        echo -e "\n"
        echo -e "  $description\n"
        echo -e "  $author\n"
        echo -e "  Git Source: $git_source\n"
    fi
}


print_usage() {
    local script_name=$(basename "$0")
    printf "Usage:\n"
    printf "  %s [-h|--help]\n" "$script_name"
    printf "  %s <image_path> -t|--image-type <type>\n\n" "$script_name"
    printf "Options:\n"
    printf "  %-20s %s\n" "-h, --help" "Show this help message and exit"
    printf "  %-20s %s\n" "-t, --image-type" "Specify the image type to be flashed"
    printf "\n"
    printf "Arguments:\n"
    printf "  %-20s %s\n" "<image_path>" "Path to the boot or init_boot image file"
    printf "  %-20s %s\n" "<type>" "Must be either 'boot' or 'init_boot'"
    printf "\n"
    printf "For more information, visit: %s\n" "https://github.com/gitclone-url/boot-img-flasher"
}

parse_arguments() {
    local image image_type

    while (( $# )); do
        case "$1" in
            -h|--help)
                [[ $# -ne 1 ]] && exit_with_error "-h|--help must be the only argument!"
                print_usage
                exit 0
                ;;
            -t|--image-type)
                [[ -n "$image_type" ]] && exit_with_error "Image type already specified. Use -t or --image-type only once!"
                [[ -z "$2" || "$2" == -* ]] && exit_with_error "Expected image type value after -t|--image-type!"
                image_type="$2"
                shift 2
                ;;
            boot|init_boot)
                [[ -n "$image_type" ]] && exit_with_error "Please specify only one image type!"
                [[ "$1" != *.img ]] && image_type="$1"
                shift
                ;;
            -*)
                exit_with_error "Unknown option: $1!"
                ;;
            *)
                [[ -n "$image" ]] && exit_with_error "Unexpected argument: $1!"
                [[ -n "$image_type" ]] && exit_with_error "Image path must come before image type argument!"
                [[ "$1" == *.img ]] && image="$1"
                shift
                ;;
        esac
    done

    # Only validate args if provided 
    [[ -n "$image" || -n "$image_type" ]] && validate_arguments

    export IMAGE="$image" IMAGE_TYPE="$image_type"
}

validate_arguments() {
    [[ -n "$image" ]] && {
        [[ ! -f "$image" ]] && exit_with_error "File does not exist: $image!"
        [[ "${image,,}" != *.img ]] && exit_with_error "Unsupported file type '$(basename "$image")'. This file cannot be flashed!"
    }
    
    [[ -n "$image_type" ]] && {
        [[ "$image_type" != "boot" && "$image_type" != "init_boot" ]] && exit_with_error "Invalid image type. Must be 'boot' or 'init_boot'!"
    }
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

# function exit_with_error()
#
# Prints an error message and terminates script with the specified status code.
#
# Parameters:
#   $1 - Error message to print.
#   $2 - (Optional) Exit status code. Defaults to 1 if not provided.
#
# Example:
#   exit_with_error "File not found" 2

exit_with_error() {
    local message="$1"
    local status="${2:-1}"  
    
    echo -e "\n${ERR}Error: ${NC}$message!" >&2
    exit "$status"
}

supports_color() {
    [ -t 1 ] && command -v tput > /dev/null && tput colors > /dev/null
}


determine_image_type() {
    local image="$1"
    local file_output
    
    if command -v file > /dev/null; then
        file_output=$(file -b "$image")
        case "$file_output" in
            *"Android bootimg"*)
                echo "boot"
                return 0
                ;;
            *"Android init boot"*)
                echo "init_boot"
                return 0
                ;;
        esac
    fi

    local file_size=$(stat -c %s "$image")
    
    # Typical init_boot images are smaller than boot images
    # These sizes are approximations and may need adjustment
    [ "$file_size" -lt 10485760 ] && echo "init_boot" || echo "boot"
}

processImageFile() {
    local image image_type ret=0

    # Assign image and image_type if provided
    [[ -n "$IMAGE" || -n "$IMAGE_TYPE" ]] && { image="$IMAGE"; image_type="$IMAGE_TYPE"; }
    
    magisk_env() {
        [[ -f /data/adb/magisk/util_functions.sh ]] || require_new_magisk
        . /data/adb/magisk/util_functions.sh
        (( MAGISK_VER_CODE < 20400 )) && require_new_magisk
        rm -rf "$TMPDIR"
        mkdir -p "$TMPDIR"
        chcon u:object_r:system_file:s0 "$TMPDIR"
        cd "$TMPDIR"
        unzip -o "$ZIPFILE" '*.img' -d "$TMPDIR" >&2
        image=$(find "$TMPDIR" -maxdepth 1 -name '*.img' -type f -print -quit)
    }
    
    termux_env() {
        image=$(find "$PWD" -maxdepth 1 -name '*.img' -type f -print -quit)
    }
    
    # Handle environments
    if [[ -n "${DEBUG}" && "${DEBUG}" == true ]]; then
        magisk_env || [[ -z "$image" ]] && ret=1
    fi

    if [[ -z "${image}" ]]; then
        termux_env || [[ -z "$image" ]] && ret=2
    fi

    # If image was Not found!
    [[ -z "$image" ]] && return ${ret:-4} || :
    
    # Determine image type if not already set
    image_type=${image_type:-$(basename "$image" | sed 's/\.img$//')}
    [[ "$image_type" != "init_boot" && "$image_type" != "boot" ]] && image_type=$(determine_image_type "$image")
    [[ -z "$image_type" ]] && return 3
    
    echo "$image" "$image_type"
    return 0
}



find_partition_block() {
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

#================================Main Entry Point =====================================#
main() {
    # Check if running as root
    if [ "$(id -u)" -ne 0 ]; then
        exit_with_error "This script requires root privileges to execute. Please run as root"
    fi
    
    if ! supports_color; then GREEN= BLUE= ERR= NC=; fi
    
    # Only parse arguments in Terminal
    [[ -n "${DEBUG}" ]] || parse_arguments "$@"
    
    mount /data 2>/dev/null
    print_banner
    
    local block_device image image_type ret
    
    # Determine device type (A/B or legacy)
    local PARTITION_INFO=$(grep_cmdline "androidboot.slot_suffix" || grep_cmdline "androidboot.slot" || getprop "ro.boot.slot_suffix")
    local is_ab_device=${PARTITION_INFO:-?}
    
    if [ "$is_ab_device" != "?" ]; then
        echo "- A/B partition style detected!" && sleep 2
        local slot=${PARTITION_INFO#*=}
        [ "${slot:0:1}" != "_" ] && slot="_$slot"
        [ "$slot" = "_normal" ] && slot=""
        echo "- Current boot slot: $slot" && sleep 1
    else
        echo "- Legacy (non-A/B) partition style detected!" && sleep 1
    fi
    
    echo "- Checking image file, please wait..." && sleep 5
    output=$(processImageFile)
    ret=$?
    
    case $ret in
        0)
            set -- $output
            if [ $# -eq 2 ]; then
                image="$1"
                image_type="$2"
                echo "- Provided image file: '$(basename "$image")'"
            fi
            ;;
        1) exit_with_error "Image file not found inside zip contents" 1 ;;
        2) exit_with_error "Image file not found in the current directory" 2 ;;
        3) exit_with_error "Unable to determine image type" 3 ;;
        4) exit_with_error "Unable to find image file" 4 ;;
        *) exit_with_error "An unknown error occurred while finding image file" 99 ;;
    esac
    
    echo "- Finding the ${image_type} block, please wait..." && sleep 10
    block_device=$(find_partition_block "${image_type}${slot:-}") || exit_with_error "${image_type} block not found. Cannot proceed with flashing"
    
    echo "- Flashing image to $block_device..."
    if ! flash_image "$image" "$block_device"; then
        case $? in
            1) exit_with_error "Failed to flash, image size exceeds block device size" 1 ;;
            2) exit_with_error "Failed to flash, partition block is read-only" 2 ;;
            3) exit_with_error "Failed to flash, located partition block: '${block_device}' is not a valid block or character device" 3 ;;
            *) exit_with_error "Unknown error occurred while flashing the image" 99 ;;
        esac
    fi
    
    echo -e "- ${GREEN}${image_type^} image flashed successfully${NC}"
}

main "$@"