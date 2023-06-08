#!/system/bin/sh

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
  echo "Error: This script must be run as root"
  echo "Please give root permission first!"
  exit 1
fi

# Print a header message
echo "########################################"
echo "#  Boot Image Flasher for A/B devices  #"
echo "#           Made by Abhijeet           #"
echo "########################################"
echo ""
echo "Finding both boot slot's partition location.."

# Find the path to the by-name directory
by_name_path=$(find /dev/block/platform -type d -name by-name) > /dev/null 2>&1

# Check if the directory was found
if [ -z "$by_name_path" ]; then
  echo ""
  echo "Error: boot_a and boot_b partition location not found"
  echo ""
  echo "Reason: by-name directory doesn't exist in /dev/block/platform"
  exit 1
fi

# List the contents of the directory with detailed information
ls -la "$by_name_path" > /dev/null 2>&1

# Check if boot_a and boot_b symbolic links actually exist in the by-name directory
boot_a="$by_name_path/boot_a"
boot_b="$by_name_path/boot_b"

if [ ! -e "$boot_a" ] || [ ! -e "$boot_b" ]; then
  echo ""
  echo "Error: boot_a and boot_b partition location not found"
  echo ""
  echo "Reason: boot_a or boot_b symbolic links don't exist in your by-name directory"
  exit 1
fi

# Find the location of the boot_a and boot_b partition
boot_a_symlink=$(readlink "$by_name_path/boot_a")
boot_b_symlink=$(readlink "$by_name_path/boot_b")

# Check if the symlinks linked path were found
if [ -z "$boot_a_symlink" ] || [ -z "$boot_b_symlink" ]; then
  echo ""
  echo "Error: boot_a or boot_b partition location not found"
  echo ""
  echo "Reason: can't find out symlinks linked path"
  exit 1
fi

# Define a function to set the read-write permission on block device directories
set_read_write() {
  for DIR in "$@"; do
    blockdev --setrw "$DIR"
  done
}

# Define a function to remount certain directories as read-write using previous function
remount_rw() {
  DIR="/dev/block"
  set_read_write "$DIR"
  DIR="/dev/block/bootdevice/by-name"
  set_read_write "$DIR"
  DIR=$(find /dev/block/platform -type d -name by-name)
  set_read_write "$DIR"
}
remount_rw

# Set the boot_a and boot_b partitions to read-write
blockdev --setrw "$boot_a_symlink"
blockdev --setrw "$boot_b_symlink"

sleep 5
echo ""
# Print the location of the symlinks
echo "The location of the boot_a Partition is: $boot_a_symlink"
echo ""
echo "The location of the boot_b Partition is: $boot_b_symlink"

# Define the path to the boot image that will be flashed to the boot partitions
boot_image="/storage/emulated/0/Download/boot.img"

# Check if the boot image exists in the specified directory
if [ ! -f "$boot_image" ]; then
  echo ""
  echo "Error: boot image file not found!"
  echo ""
  echo "Please ensure that the boot image file is located in your internal storage download directory"
  exit 1
fi

# Flash the boot image to the boot_a and boot_b partitions
echo ""
echo "Flashing boot image to $boot_a_symlink..."

dd if="$boot_image" of="$boot_a_symlink"

sleep 0.5

echo ""
echo "Flashing boot image to $boot_b_symlink..."

dd if="$boot_image" of="$boot_b_symlink"

sleep 0.5
echo ""
echo "Boot image flashed successfully."
echo ""
echo "Now reboot"
exit 0
