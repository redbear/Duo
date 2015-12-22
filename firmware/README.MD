# Firmware


## Install DFU-UTIL

http://dfu-util.sourceforge.net/


## Updating firmwre

Press and hold the SETUP button on the Duo and then press reset button, when the RGB LED shows Yellow and flashing, release the SETUP button.

From the command line:

To update System-Part1

$ dfu-util -d 2b04:d058 -a 0 -s 0x08020000 -D duo-system-part1.bin

To update System-Part2

$ dfu-util -d 2b04:d058 -a 0 -s 0x08040000 -D duo-system-part2.bin

To update User-Part

$ dfu-util -d 2b04:d058 -a 0 -s 0x08040000 -D duo-system-part2.bin