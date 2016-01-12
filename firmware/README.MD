# Firmware


## Install DFU-UTIL

http://dfu-util.sourceforge.net/

For Windows and Linux, download the binary package.

For OSX, use the command line to install:

$ brew install dfu-util


## Updating firmware

Press and hold the SETUP button on the Duo and then press reset button, when the RGB LED shows Yellow and flashing, release the SETUP button.

From the command line:

To update System-Part1

$ dfu-util -d 2b04:d058 -a 0 -s 0x08020000 -D duo-system-part1.bin

To update System-Part2

$ dfu-util -d 2b04:d058 -a 0 -s 0x08040000 -D duo-system-part2.bin

To update factory reset image

$ dfu-util -d 2b04:d058 -a 2 -s 0x140000 -D duo-fac-tinker.bin

To update User-Part

$ dfu-util -d 2b04:d058 -a 0 -s 0x080C0000 -D duo-blink.bin

After updating the firmware, press the reset button to run the new firmware.


## Version History

0.2.1 (beta) - Work in progress.
- Mass Production #1.
- Bug fixes (mainly for Arduino upload sketch)
- Added BLE APIs

0.2.0
- PP 2nd run (PP1).
- Bug fixes.
- Adds Bluetooth Uart for sending HCI commands.

0.1.1
- PP first run (PP0).
- Initial public released version.

