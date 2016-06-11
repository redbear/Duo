
# Duo Getting Started with Arduino
---

Allows Arduino fans to use the Arduino IDE to develop STM32 MCU firmware. Currently, it supports the RedBear Duo (STM32F205) IoT development kit.

The Duo IoT development kit contains two boards, the Duo and the RBLink.

The Duo is a small and powerful IoT development board that has an ARM Cortex-M3 MCU runs at 120 MHz with 1 MB Flash (256 KB for Arduino sketch) and 128 KB SRAM, it comes with Broadcom's BCM43438 connectivity chip so that the Duo has WiFi (802.11n / 2.4 GHz) and Bluetooth features at the same time, the board only requires a single antenna.

The RBLink provides interfaces for Seeed Studio Grove System modules.

You do not really need the RBLink if you are not going to develop firmware using Broadcom's WICED SDK.

Note: unless you want to contribute to the Duo board support package, you do not need to touch the folder 'arduino' because you will use the Arduino Boards Manager to add it to the Arduino IDE. 

![image](docs/images/RBDuo_Pinout.jpg)

![image](docs/images/RBLink_Pinout.jpg)


# Requirements

### Hardware

1. RedBear [Duo](http://www.redbear.cc/duo) development board

### Readings

1. Basic [Arduino](http://www.arduino.cc) knowledge
2. Understand the [Duo System Overview](https://github.com/redbear/Duo)
3. Go through the Duo [Getting Started Guide](https://github.com/redbear/Duo/blob/master/docs/getting_started.md)

### Software
 
1. Arduino IDE (Tested with 1.6.8)
2. Duo board support package for Arduino (See [version](VERSION.md) for the latest version)


# Install Driver (only for Windows)

### USB CDC

Connect the Duo to your Windows PC using the USB port and install the driver from the [driver/windows](driver/windows) folder.


# Update udev Rules (only for Linux)

For Linux (e.g. Ubuntu 14.04) users: ModemManager will try to use the Duo as a modem and this causes the upload process fail using Arduino IDE. To allow Arduino IDE to upload correctly, you need to fix it by modify the UDEV rule, write a simple UDEV rule to ignore it from being handled by modem manager.

	$ sudo nano /etc/udev/rules.d/77-mm-usb-device-blacklist.rules
	
Simply add this single line:

	ATTR{idVendor}=="2b04", ENV{ID_MM_DEVICE_IGNORE}="1"


# Install lsb-core (only for Linux)

On Linux, if you cannot compile sketches (the IDE cannot find gcc or g++):

	$ sudo apt-get install lsb-core


# Setup Arduino IDE

Step 1:

Download the Arduino IDE, support OSX, Windows and Linux.

https://www.arduino.cc/en/Main/Software

Step 2:

Start the IDE and from the menu, Preferences, add the following to "Additional Boards Manager URLs"

https://redbearlab.github.io/arduino/package_redbear_index.json

Step 3:

From the menu, [ Tools ] > [ Board ], select "Boards Manager" and install the RedBear Duo board support package to the IDE.

Step 4:

Connect the Duo to your computer through the USB port of the Duo.

*** Note that, it is not the RBLink's USB port if you are going to use the RBLink for Grove System components, the following photo shows the setup (connected to Grove RGB LED):

![image](docs/images/mode_grove.jpg)

Step 5:

From the menu, [ Tools ] > [ Board ], select [ RedBear Duo ] under RedBear IoT Boards.

Step 6:

Select the Port under the [ Tools ] -> [ Port ] menu.


# Update Firmware

### For using Arduino IDE to update

![image](docs/images/mode_standalone.jpg)

* Connect the Duo to your PC via the USB port.
* Select [ Menu ] -> [ Tools ] -> [ Programmer ] -> [ Duo FW Uploader ]
* Press and hold the `SETUP` button on the board and press the `RESET` button, until it shows in flashing yellow, release the `SETUP` button, it is in DFU mode now.
* Select [ Menu ] -> [ Tools ] -> [ Burn Bootloader ] to update the system firmware.
* You will see the Blue LED on the board is flashing.

### For using DFU-Util

For people want to compile without the Arduino IDE, please use this method to update firmware:

* Read the [Firmware Management Guide](https://github.com/redbear/Duo/tree/master/firmware) for the instructions.


# Upload sketch (e.g. Blink)

From the menu, [ File ] > [ Examples ] > [ RedBear_Duo ] -> [01.Basics], select the example `Duo_Blink` and upload to the board.

The blue LED (D7) on the board is blinking.


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

