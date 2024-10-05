<div align="center">
 <img src="https://github.com/gitclone-url/Boot-img-flasher/assets/98699436/05dd92bf-7d11-4380-b21a-21558b78196e" alt="Boot Image Flasher" />
 <a href="https://github.com/gitclone-url/Boot-img-flasher">
   <h2>Boot Image Flasher</h2>
 </a>
</div>

### Detailed Explanation

**What is Boot Image Flasher?**

Boot Image Flasher is a shell script designed to simplify the process of flashing boot and init_boot images on Android devices, supporting both [A/B](https://source.android.com/devices/tech/ota/ab) and [legacy (non-A/B)](https://source.android.com/devices/bootloader/partitions) devices. Typically, flashing these images involves using custom recovery or fastboot, which can be complex and time-consuming. Furthermore many devices lack custom recovery support, and accessing fastboot often requires a PC. Boot Image Flasher addresses this issues by providing a straightforward, efficient, and user-friendly solution for Android enthusiasts and developers that operates directly on the device. The core functionality and image flashing logic of this script is based on Magisk's utility functions. Other well-known rooting applications like [KernelSU](https://github.com/tiann/KernelSU) and [APatch](https://github.com/bmax121/APatch) also use the same approach.

### Key Features

- **Supports dual partition flash:** capable of Automatically detecting and flashing both init_boot and boot images.
- **Automated and User-Friendly:** Simplifies the image flashing process with minimal user intervention.
- **Universal Compatibility:** works on any Android device, including both A/B and legacy (non-A/B) partition styles.
- **Saves Time and Effort:** Reduces the time and complexity involved in flashing boot and init_boot images using fastboot or custom recoveries, making it accessible for users with varying levels of technical expertise.
- **Flexible Usage:** Can be used via Termux with command-line options, or flash over like a module in magisk, providing flexibility based on use case and preferences.

### Prerequisites

- An Android device with root access.
- To use in Termux, `figlet`, `file` and `ncurses-utils` need to be installed if not already available.

## Methods of Use

#### Method 1: Via Termux

1. Open [Termux](https://github.com/termux/termux-app) on your Android device.
2. Navigate to the directory where you want to download the script using `cd`. For example:
   ```bash
   cd /storage/emulated/0/Download
   ```
3. Download the script and necessary tools using the following command:
   ```bash
   curl -s https://raw.githubusercontent.com/gitclone-url/Boot-img-flasher/master/boot-img-flasher.sh -o boot-img-flasher.sh && { command -v tput >/dev/null && command -v figlet >/dev/null && command -v file >/dev/null || pkg install -y figlet file ncurses-utils; } && { command -v sudo >/dev/null || pkg install -y tsu; }
   ```
   > **Note:** It may take some time for the script to be downloaded, along with the required tools. Please be patient.


##### Running the Script:

   **Basic usage:**
   ```bash
   boot-img-flasher.sh [-h|--help]

  boot-img-flasher.sh <IMAGE_PATH> --image-type <TYPE>
   ```
   
   Options:
- `-h`, `--help`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Display help message with usage information.
- `-t`, `--image-type`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Manually specify the type of image to flash.

Arguments: 
-  `<IMAGE_PATH>`&nbsp;&nbsp;&nbsp;&nbsp;Path to the boot or init_boot image file.
- `<TYPE>`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Must be either `boot` or `init_boot`.

----

#### Examples of Use:

1. **Flash an image by providing the image path and it's type:**

   ```bash
   sudo bash boot-img-flasher.sh /path/to/boot.img --image-type boot
   ```
   
2. **Flash an image from current directory by only specifying type:**

   ```bash
   sudo bash boot-img-flasher.sh -t init_boot
   ```
 
   **Or flash by only specifying path (type will be auto-determined):**
   
   ```bash
   sudo bash boot-img-flasher.sh /path/to/init_boot.img
   ```
   
3. **Flash an image from current directory without providing any argument:**

   ```bash
   sudo bash boot-img-flasher.sh
   ```
   
Once flashing process is completed you may restart your device.

#### Method 2: Magisk

1. Download `boot_flasher.zip` from [here](https://github.com/gitclone-url/Boot-img-flasher/raw/Master/boot_flasher.zip).
2. Extract the archive using an app like [ZArchiver](https://play.google.com/store/apps/details?id=ru.zdevs.zarchiver).
3. After extracting, copy and paste your `boot.img` or `init_boot.img` file inside the created folder.
4. Select all files inside the folder and archive them as a zip.
5. Install the zip as a Magisk module.
6. Restart your device.

> **Note:**  It is recommended to properly name the image file as with either `boot` or `init_boot` to avoid errors, as the script may not always auto-detect the image type if not specified.

### Preview

Below are some screenshots demonstrating the Boot Image Flasher in action:

<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/2f39d431-4d08-4084-bb81-69149ecb9748" width="200" alt="Preview 1" />
  <img src="https://github.com/user-attachments/assets/b2356962-9160-4e17-bed9-c47b1088ae9a" width="200" alt="Preview 2" />
</div>

### Additional Information

Some GSIs (Generic System Images) based on PHH come with prebuilt root access, meaning the `su` binary is already included in the system. If you are using one of those GSIs and your phone is not actually rooted with Magisk or other root providers, you can just patch the boot/init_boot image of your phone and then flash the patched image using this script, with root permissions granted through the PHH Superuser App. This way, you can easily root using Magisk or other rooting apps just by using your device without needing additional tools, a PC, or any hassles.

> **Note:** For patching the boot or init_boot image, you can use either [Magisk](https://github.com/topjohnwu/Magisk) or [APatch](https://github.com/bmax121/APatch) app.

For information about GSIs, check the [FAQ](https://github.com/phhusson/treble_experimentations/wiki/Frequently-Asked-Questions-%28FAQ%29) and choose your specific GSI image from [here](https://github.com/phhusson/treble_experimentations/wiki/Generic-System-Image-%28GSI%29-list).

### Disclaimer

This script is intended for advanced users only. Improper use of this script can lead to device bricking, data loss, or other serious issues. The author is not responsible for any damage or data loss resulting from the misuse of this script. Proceed at your own risk, with caution, and follow the instructions carefully.

### Credits

Special thanks to [topjohnwu](https://github.com/topjohnwu) for [Magisk](https://github.com/topjohnwu/Magisk) and its general utility functions.

### License

Boot Image Flasher is distributed under the terms of the [MIT License](LICENSE).

### Contributing

Contributions are welcome. Please fork the repository, make your modifications, and submit a pull request. For more detailed guidelines, see our [Contribution Guidelines](CONTRIBUTING.md).

### Contact

For support, inquiries, or suggestions, contact the developer via [Telegram](https://t.me/PhantomXPain).