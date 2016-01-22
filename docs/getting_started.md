# Getting Started - RedBear Duo

Congratulations on being the owner of a brand new [RedBear Duo](http://www.redbear.cc/duo)! Now, you can open the box and follow this guide to play with the Duo.

![image](images/RBDuo-L.png)

This getting started guide will show you how to use the RedBear Duo IoT development board quickily. There are three topics:

1. Out of the box test
2. Connect the board to the Internet
3. Develop an application using WebIDE or Arduino IDE.


## Prerequisites for Setup

You need to prepare the following hardware items:

1. PC with Windows, Linux (e.g. Ubuntu) or Mac with OSX
	* Tested on: Windows 10, OSX 10.11
2. Access Point (e.g. an Internet router at your home).
	* For the Duo to have Internet connection
3. Micro USB cable
	* Note: some cables only for power, you need a data+power cable for the Duo.

Software items:
	
1. [dfu-til](http://dfu-util.sourceforge.net/)
2. Latest Duo Firmware
	* https://github.com/redbear/Duo/raw/master/firmware/
	 
For Windows, you also need the following software tools:

1. [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty)
	* or you can use other serial port tool (e.g. HyperTerminal)
2. [Driver](https://github.com/redbear/Duo/raw/master/driver/windows/duo_win_driver.zip)
3. [Zadig](http://zadig.akeo.ie/)


## Out of the Box Test
---

#### 1. Power-Up the Duo

* Connect the Duo to your PC via the USB port with a micro USB cable.

* The RGB LED will show Blue in color and keep flashing.

	![image](images/Duo-Blue.gif)

#### 2. Install Driver (Only required for Windows)

* Follow [this driver](driver.md) installation guide for details.#### 3. Install PuTTY (Only required for Windows)
* Note: you can also use other Serial port communication software (e.g. HyperTerminal).* Download and unzip [PuTTY](http://the.earth.li/~sgtatham/putty/latest/x86/putty.zip).

#### 4. Check firmware version and device ID

##### For Windows

* Start PuTTY, change the Serial port to your one and press the 'Open' button.

	![image](images/PuTTY_01.png)

	* Press 'v' to the terminal screen, you will see the firmware version.
	
	* Press 'i', you will see the Device ID of the Duo.
	
	![image](images/PuTTY_02.png)
	
##### For OSX or Linux

* Start the Terminal and use 'screen' command.
	
	* For example on OSX, start
		
		![image](images/Terminal.png)
	
	* Type:
	
			$ screen /dev/tty.usbmodemXXXXX
		
			where XXXXX is your Duo device serial port.
	
	* Press 'v' to the terminal screen, you will see the firmware version.
	
	* Press 'i', you will see the Device ID of the Duo.

	* It will show something like the following lines:
	
			system firmware version: 0.1.1

			Your device id is 200027FFFc473530FFF23637
#### 5. Updating Firmware
* Follow this [DFU](dfu.md installation guide) to install the 'dfu-util' tool.

* Download the zipped Duo firmware (latest version) and unzip it to a folder.
	
	* https://github.com/redbear/Duo/raw/master/firmware/
	
* Start the Command Prompt (Windows) or Terminal (OSX)
	
* If you are not in the DFU Mode, press and hold the 'SETUP' button on the Duo and then press reset button, when the RGB LED shows yellow and flashing, release the 'SETUP' button, the Duo will enter the DFU Mode.
	
	![image](images/Duo-Yellow.gif) 
	
* From the command line box:

			To update System-Part1, type:

			$ dfu-util -d 2b04:d058 -a 0 -s 0x08020000 -D duo-system-part1.bin

			To update System-Part2, type:

			$ dfu-util -d 2b04:d058 -a 0 -s 0x08040000 -D duo-system-part2.bin

			To update User-Part, type:

			$ dfu-util -d 2b04:d058 -a 0 -s 0x080C0000 -D duo-user-part.bin
	
			To update factory reset image, type:

			$ dfu-util -d 2b04:d058 -a 2 -s 0x140000 -D duo-fac-tinker.bin

* Sample output:

		dfu-util 0.8

		Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
		Copyright 2010-2014 Tormod Volden and Stefan Schmidt
		This program is Free Software and has ABSOLUTELY NO WARRANTY
		Please report bugs to dfu-util@lists.gnumonks.org

		dfu-util: Invalid DFU suffix signature
		dfu-util: A valid DFU suffix will be required in a future dfu-util release!!!
		Opening DFU capable USB device...
		ID 2b04:d058
		Run-time device DFU version 011a
		Claiming USB DFU Interface...
		Setting Alternate Setting #0 ...
		Determining device status: state = dfuIDLE, status = 0
		dfuIDLE, continuing
		DFU mode device DFU version 011a
		Device returned transfer size 4096
		DfuSe interface name: "Internal Flash   "
		Downloading to address = 0x08020000, size = 38492
		Download	[=========================] 100%        38492 bytes
		Download done.
		File downloaded successfully	
		
* After updating the firmware, press the onboard 'RESET' button to run the new firmware.

* Repeat the step 4 again to check the new firmware version.

		system firmware version: 0.2.1

		Your device id is 200027FFFc473530FFF23637

* For more details about the Duo firmware, refer to the [Firmware](../firmware/README.md) folder.

#### 6. Setup WiFi

To be written.

#### 7. Testing

To be written.

#### 8. WebIDE

To be written.

#### 9. Arduino IDE

Follow [this](https://github.com/redbear/STM32-Arduino) to use Arudino IDE for programming.

---
Copyright (c) 2016 Red Bear, All Rights Reserved.