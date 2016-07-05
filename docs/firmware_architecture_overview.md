# Duo: Firmware Architecture Overview
---

The RedBear Duo supports running Particle firmware based applications and WICED SDK based applications. It is installed the customed Particle firmware by default during manufacturing. The following diagram exactly shows you the memory mapping on the Duo, comparing to the Particle Photon development board.

![image](images/Duo_MemMap.png)

The Duo's memory allocation is different from the Photon. The Duo has an external flash while the Photon does not. The external flash stores the WiFi firmware to be loaded to the BCM43438 wirless chip during boot-up as well as other recovery firmware. Thus, this design allows the entire internal flash memory space of 256KB to be available for the user sketch.


## Bootloader

The bootloader ranges from internal flash address **`0x08000000`** to **`0x08003FFFF`**, the size of which is 16 KB. The bootloader is versatile. It determines whether to run the Particle firmware or WICED applications. If neither of them are valid, then it enters DFU mode for firmware uploading.

Besides, if the Duo is running Particle firmware, the bootloader is responsible for the factory application reset, applying the OTA downloaded firmware or user application, making the Duo enter Safe mode, clearing Wi-Fi credentials and etc.


## DCT (Device Configuration Table)

The DCT (Device Configuration Table) ranges from internal flash address **`0x08004000`** to **`0x0800BFFFF`**, the size of which is 32 KB. It is separated into two partitions (DCT1 and DCT2) and each size is 16K. Only one of the DCTs is valid at a time and the another one is standby for swapping data. They are used alternately to keep the data integrate, in case of power down during changing the device configuration.

The DCT consists of two partitions:

* The Platform DCT, starting from the begining address of DCT1 or DCT2. [Details...](https://github.com/redbear/firmware/blob/duo/hal/src/duo/wiced/platform/include/platform_dct.h#L257)
* The Application DCT immediately following the Platform DCT. 

Regarding to the Particle firmware architecture, the configurations in Application DCT are listed below. For more details, see [here](https://github.com/redbear/firmware/blob/duo/platform/MCU/STM32F2xx/SPARK_Firmware_Driver/inc/dct.h). 

	Region					Offset		Size
	------------------------------------------------
	system flags 			0 			32
	version					32			2
	device private key		34			1216
	device public key		1250		384
	ip config				1634		128
	country code			1758		4
	claim code				1762		63
	claimed					1825		1
	ssid prefix				1826		26
	device id				1852		6
	version string			1858		32
	dns resolve				1890		128
	reserved1				2018		64
	server public key		2082		768
	padding					2850		2
	flash modules			2852		100
	product store			2952		24
	antenna selection		2976		1
	cloud transport			2977		1
	alt device public key	2978		128
	alt device private key	3106		192
	alt server public key	3298		192
	alt server address		3490		128
	reserved2				3618		640
	extra system flags		4258		32
	end						4290


## EEPROM Emulation

*Note: Particle Firmware architecture only*

The EEPROM emulation is used to store user's non-volatile data, the size of which is 80 KB. It ranges from internal flash address **`0x0800C000`** to **`0x0801FFFF`**. The working mechanism of the EEPROM emulation is the same as DCT, it is separated into two partitions and only one is valid at a time:

* EEPROM emulation bank 1, 16 KB
* EEPROM emulation bank 2, only the first 16 KB is used

See the [EEPROM Emulation APIs](https://github.com/redbear/Duo/blob/master/docs/programming_reference_manual.md#eeprom-emulation).


## System Part 1

*Note: Particle Firmware architecture only*

System part 1 ranges from internal flash address **`0x08020000`** to **`0x0803FFFF`**, the size of which is up to 128 KB. It is part of the Particle system firmware, which implements the cloud communication and services functions. These functions can be invoked by system part 2 and user application, so they are so called "dynalibs" (dynamic libraries).


## System Part 2

*Note: Particle Firmware architecture only*

System part 2 ranges from internal flash address **`0x08040000`** to **`0x080BFFFF`**, the size of which is up to 512 KB. It is the mayor part of the Particle system firmware, which implements all of the Hardware Abstract Layer functions, including internal peripherals, WiFi, BLE and etc. They can be invoked by user application in the way of dynalibs.

The system part 2 is the core of the Particle firmware. It initialises the platform and runs the FreeRTOS real-time operating system. It is responsible for dealing with system events, OTA updating firmware and user application, configuring Wi-Fi credentials and calling the `setup()` and `loop()` functions in the user application.

The partition 2 firmware has a copy of bootloader, if it found the bootloader version is lower than the copy, then it will update the bootloader automatically.


## User Part

The user part is the user application. 

Regarding to the user application based on Particle firmware, it ranges from the internal flash address **`0x080C0000`** to **`0x080FFFFF`**, the size of which is up to 256 KB. It is made up of the `setup()` and `loop()` functions, the same as the Arduino sketch.

Regarding to the user application based on WICED SDK, it ranges from the internal flash address **`0x0800C000`** to **`0x080FFFFF`**, the size of which is up to 976 KB.


## OTA Image

*Note: Particle Firmware architecture only*

The OTA Image ranges from external flash address **`0xC000`** to **`0x13FFFF`**, the size of which is up to 512 KB. It is the OTA downloaded system firmware or user application. The OTA downloaded images will be applied to internal flash during the next boot up.


## Factory Reset Image

*Note: Particle Firmware architecture only*

The Factory Reset image (FAC) ranges from external flash address **`0x140000`** to **`0x17FFFF`**, the size of which is up to 256 KB. It should be a validated user application so that even if you have loaded a bad user application to internal flash, you can simply copy the factory reset image to where the user application locates by performing a factory reset action.


## Wi-Fi Firmware

*Note: Particle Firmware architecture only*

The Wi-Fi firmware ranges from external flash address **`0x180000`** to the end of the external flash, the size of which is up to 512 KB. It will be loaded to the BCM43438 wireless chip in system part 2 during initialization.


## User Data

*Note: Particle Firmware architecture only*

The user data region ranges from external flash address **`0x0`** to **`0xBFFFF`**, the size of which is up to 768 KB. It is also used to store user's non-volatile data.

See the [External SPI Flash APIs](https://github.com/redbear/Duo/blob/master/docs/programming_reference_manual.md#external-spi-flash).


## WICED

*Note: WICED architecture only*

This region is to store the  WICED application relevant data, e.g the factory reset application, Wi-Fi firmware and etc.


## References

* [Getting Started with Arduino IDE](getting_started_with_arduino_ide.md)
* [Getting Started with Particle Build (WebIDE)](getting_started_with_particle_build.md)
* [Firmware Deployment Guide](firmware_deployment_guide.md)
* [Programming Reference Manual](programming_reference_manual.md)


## Resources

* [Modified Particle Firmware Source Code](https://github.com/redbear/firmware)
* [WICED SDK](https://community.broadcom.com/community/wiced-wifi/wiced-wifi-documentation)
* [WICED SDK Patch for Duo](https://github.com/redbear/WICED-SDK)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


