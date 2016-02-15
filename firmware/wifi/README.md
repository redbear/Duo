# WiFi Firmware

This is the firmware stored in the external flash (address 0x180000) to be loaded to the WiFi/BT module during the boot time.

	$ dfu_util -d 2b04:d058 -a 2 -s 0x180000 -D duo-wifi-r1.bin


