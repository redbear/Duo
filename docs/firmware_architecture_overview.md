# Duo: Firmware Architecture Overview
---

The RedBear Duo supports running Particle firmware based applications and WICED SDK based applications. It is installed the customed Particle firmware by default during manufacturing. The following diagram exactly shows you the memory mapping on the Duo, comparing to the Particle Photon development board.

![image](images/Duo_MemMap.png)

The Duo's memory allocation is different from the Photon. The Duo has an external flash while the Photon does not. The external flash stores the WiFi firmware to be loaded to the BCM43438 wirless chip during boot-up as well as other recovery firmware. Thus, this design allows the entire internal flash memory space of 256KB to be available for the user sketch.


## Bootloader

The bootloader ranges from internal flash address **`0x08000000`** to **`0x08003FFFF`**, the size of which is 16 KB. The bootloader is versatile. It determines whether to run the Particle firmware or WICED applications. If neither of them are valid, then it enters DFU mode for firmware uploading.

Besides, if the Duo is running Particle firmware, the bootloader is responsible for the factory application reset, applying the OTA downloaded user application, making the Duo enter Safe mode, clearing Wi-Fi credentials and etc.


## DCT (Device Configuration Table)

The DCT (Device Configuration Table) ranges from internal flash address **`0x08004000`** to **`0x0800BFFFF`**, the size of which is 32 KB. It is separated into two partitions (DCT1 and DCT2) and each size is 16K. Only one of the DCTs is valid at a time and the another one is standby for swapping data. They are used alternately to keep the data integrate, in case of power down during changing the device configuration.

The DCT is made up of two partitions:

* The Platform DCT, starting from the begining address of DCT1 or DCT2. See the [Platform DCT](https://github.com/redbear/firmware/blob/duo/hal/src/duo/wiced/platform/include/platform_dct.h#L257) details.
* The Application DCT immediately following the Platform DCT. Regarding to the Particle firmware architecture, the Application DCT details are listed [here](https://github.com/redbear/firmware/blob/duo/platform/MCU/STM32F2xx/SPARK_Firmware_Driver/inc/dct.h#L54).


## EEPROM Emulation

*Note: Particle Firmware architecture only*

The EEPROM emulation is used to store user's non-volatile data, the size of which is 80 KB. It ranges from internal flash address **`0x0800C000`** to **`0x0801FFFF`**. The working mechanism of the EEPROM emulation is the same as DCT, it is separated into two partitions and only one is valid at a time:

* EEPROM emulation bank 1, 16 KB
* EEPROM emulation bank 2, only 16 KB of the rest 64 KB is used


## System Part 1

*Note: Particle Firmware architecture only*

System part 1 ranges from internal flash address **`0x08020000`** to **`0x0803FFFF`**, the size of which is 128 KB. It is part of the Particle system firmware, which implements the cloud communication and services functions. These functions can be invoked by system part 2 and user application, so they are so called "dynalibs" (dynamic libraries).


## System Part 2

*Note: Particle Firmware architecture only*

System part 2 ranges from internal flash address **`0x08040000`** to **`0x080BFFFF`**, the size of which is 512 KB. It is the mayor part of the Particle system firmware, which implements all of the Hardware Abstract Layer functions, including internal peripherals, WiFi, BLE and etc. They can be invoked by user application in the way of dynalibs.

It is the core of Particle firmware which initialises the platform and runs the FreeRTOS real-time operating system. It is responsible for dealing with system events, and invoking the `setup()` and `loop()` functions in the user application.

The partition 2 firmware has a copy of bootloader, if it found the bootloader version is lower than the copy, then it will update the bootloader automatically.


## User Part




## OTA Image




## Factory Reset Image




## Wi-Fi Firmware




## References




## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


