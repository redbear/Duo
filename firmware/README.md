# Firmware Management Guide


## Prerequisites

* Read the Duo system overview [here](../README.md).


## Install DFU-UTIL

To manage firmwares for the Duo, you need to use DFU utility.

* [DFU Installation Guide](../docs/dfu.md)


## Bootloader

The bootloader cannot be updated using dfu-util, instead, it will be updated by the partition 2 firmware.

The partition 2 has a copy of bootloader, if it found the bootloader version is lower then the copy, it will update the bootloader partition actomatically.

If you have removed the bootloader with other code (or maybe other bootloader for the ST F205 MCU), you can reload the Duo bootloader by using the RBLink. If you do not have a RBLink, you can use JLink, STLink, FTDI or other flash programmer, but here we will just support using the RBLink.


## Updating Main Firmware

Press and hold the SETUP button on the Duo and then press reset button, when the RGB LED shows Yellow and flashing, release the SETUP button.

From the command line:

To update System-Part1

$ dfu-util -d 2b04:d058 -a 0 -s 0x08020000 -D duo-system-part1.bin

To update System-Part2

$ dfu-util -d 2b04:d058 -a 0 -s 0x08040000 -D duo-system-part2.bin


## Clearing DCT

If you want to clear the DCT to factory default (e.g. remove WiFi credentials):
  
$ dfu-util -d 2b04:d058 -a 0 -s 0x08004000 -D duo-dct.bin


## Updating Factory Reset Firmware

To update factory reset image

$ dfu-util -d 2b04:d058 -a 2 -s 0x140000 -D duo-fac-tinker.bin


## Updating User Firmware

To update User-Part

$ dfu-util -d 2b04:d058 -a 0 -s 0x080C0000 -D duo-user-part.bin


## Dumping Firmware

You can dump the firmware to your computer, for example, to dump the DCT to a file (duo-dct-dup.bin):

$ dfu-util -d 2b04:d058 -a 0 -s 0x08004000 -U duo-dct-dump.bin

After updating the firmware, press the reset button to run the new firmware.



