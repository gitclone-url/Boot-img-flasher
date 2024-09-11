<div align="center">
 <img src="https://github.com/gitclone-url/Boot-img-flasher/assets/98699436/05dd92bf-7d11-4380-b21a-21558b78196e" alt="Boot Image Flasher" />
 <a href="https://github.com/gitclone-url/Boot-img-flasher">
   <h2>Boot Image Flasher</h2>
 </a>
</div>

### Detailed Explanation

**What is Boot Image Flasher?**

Boot Image Flasher is a shell script designed to simplify the process of flashing boot images on Android devices, supporting both A/B and legacy (non-A/B) devices. typically, flashing boot images involves using custom recovery or fastboot, which can be complex and time-consuming. This script eliminates the need for those methods, offering a straightforward, efficient, and user-friendly solution.

### Key Features

- **Automated and User-Friendly:** Simplifies the boot image flashing process with minimal user intervention.
- **Broad Device Support:** Compatible with any Android device, including both A/B and legacy (non-A/B) partition styles.
- **Saves Time and Effort:** Reduces the time and complexity involved in flashing boot images using fastboot or custom recoveries, making it accessible for users with varying levels of technical expertise.
- **Flexible Usage:** Can be used via Termux or flashed as a Magisk module, providing flexibility based on user preferences.

### Prerequisites

- An Android device with root access.
- To use in Termux, `figlet` and `ncurses-utils` need to be installed if not already available.

### Usage

#### Method 1: Via Termux

1. Open [Termux](https://github.com/termux/termux-app) on your Android device.
2. Navigate to the directory where you want to download the script using `cd`. For example:
   ```bash
   cd /storage/emulated/0/Download
   ```
3. Download the script and necessary tools using the following command:
   ```bash
   curl -s https://raw.githubusercontent.com/gitclone-url/Boot-img-flasher/Master/boot-img-flasher.sh -o boot-img-flasher.sh && { command -v tput figlet &>/dev/null || pkg install -y figlet ncurses-utils; } && { which sudo &>/dev/null || pkg install -y tsu; }
   ```
   > **Note:** It may take some time for the script to be downloaded first along with the required tools. Please be patient.

4. Run the script by executing:
   ```bash
   sudo bash boot-img-flasher.sh
   ```
   > **Optional Argument:** You can also specify the path to your boot image as an argument. If you don't provide one, the script will search for the boot image in the current directory.

5. Restart your device after the flashing process is complete.

#### Method 2: Magisk

1. Download `boot_flasher.zip` from [here](https://github.com/gitclone-url/Boot-img-flasher/raw/Master/boot_flasher.zip).
2. Extract the archive using an app like [ZArchiver](https://play.google.com/store/apps/details?id=ru.zdevs.zarchiver).
3. After extracting, copy and paste your `boot.img` inside the created folder.
4. Select all files inside the folder and archive them as a zip.
5. Install the zip as a Magisk module.
6. Restart your device.

### Preview

Below are some screenshots demonstrating the Boot Image Flasher in action:

<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/gitclone-url/Boot-img-flasher/assets/98699436/e4f328e9-dc48-4835-a47d-edbad2729d04" width="200" alt="Preview 1" />
  <img src="https://github.com/gitclone-url/Boot-img-flasher/assets/98699436/cbcad4f5-c35a-4254-9ee3-5d5c8a8ce6ef" width="200" alt="Preview 2" />
</div>

### Additional Information

Some GSIs (Generic System Images) based on PHH come with prebuilt root access, meaning the `su` binary is already included in the system. If you are using one of those GSIs and your phone is not actually rooted with Magisk or other root providers, you can just patch the boot image of your phone and then flash the patched boot image using this script, with root permissions granted through the PHH Superuser App. This way, you can easily root using Magisk or other rooting apps just by using your device without needing additional tools, a PC, or any hassles.

> **Note:** For patching the boot image, you can use either [Magisk](https://github.com/topjohnwu/Magisk) or [APatch](https://github.com/bmax121/APatch) app.

For information about GSIs, check the [FAQ](https://github.com/phhusson/treble_experimentations/wiki/Frequently-Asked-Questions-%28FAQ%29) and choose your specific GSI image from [here](https://github.com/phhusson/treble_experimentations/wiki/Generic-System-Image-%28GSI%29-list).

### Disclaimer

This script is intended for advanced users only. Improper use of this script can lead to device bricking, data loss, or other serious issues. The author is not responsible for any damage or data loss resulting from the misuse of this script. Proceed at your own risk, with caution, and follow the instructions carefully.

### Credits

Special thanks to [topjohnwu](https://github.com/topjohnwu) for [Magisk](https://github.com/topjohnwu/Magisk) and its general utility functions.

### License

Boot Image Flasher is distributed under the terms of the [GNU General Public License v2.0](LICENSE).

### Contributing

Contributions are welcome. Please fork the repository, make your modifications, and submit a pull request. For more detailed guidelines, see our [Contribution Guidelines](CONTRIBUTING.md).

### Contact

For support, inquiries, or suggestions, contact the developer via [Telegram](https://t.me/PhantomXPain).