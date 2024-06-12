<div align="center">
 <img src="https://github.com/gitclone-url/Boot-img-flasher/assets/98699436/05dd92bf-7d11-4380-b21a-21558b78196e" />
<a href="https://github.com/gitclone-url/Boot-img-flasher">
  <h2>Boot Image Flasher</h2>
</a>
</div>

### Detailed Explanation

**What is Boot Image Flasher?**

Boot Image Flasher is a shell script developed to simplyfy the process of flashing boot images on Android devices, supporting both A/B and legacy (non-A/B) devices. Typically, for flashing boot images on devices we use custom recovery or fastboot, which can be complex and time-consuming. This script removes the need for those methods, offering a more straightforward, efficient and user-friendly solution.

### Key Features

- **Automated and User-Friendly:** Simplifies the boot image flashing process with minimal user intervention.
- **Broad Device Support:** Compatible with any android devices, including with both A/B and legacy (non-A/B) partition styles.
- **Saves Time and Effort:** Reduces the time and complexity involved in flashing boot images in fastboot or custom recoveries, making it accessible for users with varying levels of technical expertise.
- **Flexible Usage:** Can be used via termux or can be flashed as a Magisk module, providing flexibility based on user preferences.

### Prerequisites

- An Android device with root access.
- To use in Termux, `figlet` and `ncurses-utils` need to be installed if not already available.

### Usage

#### Method 1: Via Termux

1. Open [Termux](https://github.com/termux/termux-app) on your Android device.
2. Navigate to the directory where the **only** boot img file is located.
3. Copy paste the command's below and hit enter to start running script.

```bash
curl -s https://raw.githubusercontent.com/gitclone-url/Boot-img-flasher/Master/boot-img-flasher.sh -o boot-img-flasher.sh && { command -v tput figlet &>/dev/null || pkg install -y figlet ncurses-utils; } && { which sudo &>/dev/null || pkg install -y tsu; }; clear; sudo bash boot-img-flasher.sh
```

4. Restart your device after the flashing process is done.

#### Method 2: Magisk

1. Download `boot_flasher.zip` from [here](https://github.com/gitclone-url/Boot-img-flasher/raw/Master/boot_flash.zip).
2. Extract the archive using an app like [ZArchiver](https://play.google.com/store/apps/details?id=ru.zdevs.zarchiver).
3. After extracting, copy and paste your `boot.img` inside the created folder.
4. Select all files inside the folder and archive them as a zip.
5. Install the zip as a Magisk module.
6. Restart your device.

### Additional information

Some GSI (Generic System Image) based on phh comes with prebuilt root access, meaning the `su` binary is already included in the system!

If you are using one of these GSIs and your phone is not rooted with Magisk or other root providers, in the case you can patch boot image of your phone. Then you can flash the patched boot image using this script, with root permissions granted through the PHH Superuser App.
This way you can easily root using magisk or other rooting apps just by using your device no need for additional tools PC or hassles.

> **Note:** for patching the boot image you can use both [Magisk](https://github.com/topjohnwu/Magisk) or [APatch](https://github.com/bmax121/APatch) app.

For information about Gsi, check the [FAQ](https://github.com/phhusson/treble_experimentations/wiki/Frequently-Asked-Questions-%28FAQ%29) and then you can choose your specific GSI image from [here](https://github.com/phhusson/treble_experimentations/wiki/Generic-System-Image-%28GSI%29-list).

### Disclaimer

This script is intended for advanced users only. Improper use of this script can lead to device bricking, data loss, or other serious issues. The author will be not responsible for any damage or data loss resulting from the misuse of this script. Proceed at your own risk & with caution and follow the instructions carefully.

### License

Boot Image Flasher is distributed under the terms of the [GNU General Public License v2.0](LICENSE).

### Contributing

Contributions are welcome. Please fork the repository, make your modifications, and submit a pull request.

### Contact

For support, inquiries, or suggestions, contact the author via [Telegram](https://t.me/PhantomXPain).
