## Boot Image Flasher

Boot Image Flasher is a shell script developed to streamline the flashing of boot images on Android devices equipped with A/B slot partitioning. This tool simplifies the flashing process for users by removing the relying on custom recovery or fastboot, offering a more direct and less time-intensive approach. 

### Purpose

The creation of this script was motivated by the lack of custom recovery support on numerous devices, which traditionally compels the use of fastboot for image flashing.

Furthermore, devices equipped with Unisoc CPUs operating on Android 10 or higher are integrated with vbmeta-sign. This necessitates the signing of boot images with private keys subsequent to Magisk patching to avert boot loops.

The process involving new Magisk updates requires patching the boot.img using the latest Magisk app, followed by signing with private keys, and finally flashing via fastboot. This script was devised to streamline this process by enabling the flashing of the boot image to both A/B slots without the use of custom recovery or fastboot, thereby saving considerable time and simplifying the procedure for all devices.

### Requirements

- An Android device with dual boot slots
- Root access on the device

### Usage

There are two primary methods to use the Boot Image Flasher:

**Method 1: Via Terminal Emulator**

1. Open a terminal emulator (like Termux) on your Android device.
2. Change to the directory where the 'boot.img' file is located.
3. Run the script with this command:

```bash
curl -s https://raw.githubusercontent.com/gitclone-url/Boot-img-flasher/Master/boot-img-flasher.sh -o boot-img-flasher.sh && (which sudo &>/dev/null) || pkg install -y tsu 2>/dev/null && sudo bash boot-img-flasher.sh
```

4. After the script finishes, restart your device.

**Method 2: Magisk**

1. Download `boot_flash.zip` from [here](https://github.com/gitclone-url/Boot-img-flasher/raw/Master/boot_flash.zip).
2. Extract the contents and insert your 'boot.img'.
3. Repack the zip file.
4. Install the zip as a Magisk module.
5. Restart your device.

#### Important Information

For users of Generic System Images (GSIs) with prebuilt root access, the Magisk app can be utilized to patch the boot image. Subsequently, the patched image can be flashed using this script, with root permissions granted through the PHH Superuser App.

**Note 1:** The Magisk app is only required for patching the boot image.

**Note 2:** Devices with a Unisoc CPU running Android 10 or higher must initially flash a custom signed `vbmeta-sign.img` and after patching process with Magisk, the boot image necessitates signing with private keys before flashing.

For comprehensive instructions on signing Unisoc images with private keys, please refer to this [Guide](https://www.hovatek.com/forum/thread-32674.html).

For those seeking GSI with prebuilt root access, please review the [Frequently Asked Questions (FAQ)](https://github.com/phhusson/treble_experimentations/wiki/Frequently-Asked-Questions-%28FAQ%29) for insights into GSI basics and the various naming conventions used by GSI builders and maintainers than choose your GSI from [here](https://github.com/phhusson/treble_experimentations/wiki/Generic-System-Image-%28GSI%29-list)

## Disclaimer

**Caution:** This script is intended for advanced users well-versed in the risks associated with flashing boot images. Incorrect usage may lead to device bricking or data loss. Proceed at your own risk.

### License

The Boot Image Flasher script is licensed under the [GNU General Public License v2.0](LICENSE).

### Contributing

Contributions are welcome! To contribute, kindly submit a pull request.

### Contact

For support, inquiries, or suggestions, feel free to reach out to the author via [Telegram](https://t.me/PhantomXPain).