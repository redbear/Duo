# Duo: Firmware Deployment Guide
---

The Duo is installed the customed Particle Firmware by default before shipped out. You can manage the firmware using dfu-util, Arduino IDE, Duo App, DuoSetupCLI, Particle CLI, Particle Cloud, Ymodem and OpenOCD.

* [Using dfu-util](#using-dfu-util): You can update all of the internal flash memory and the external SPI flash memory, including DCT, system firmware, user application, Wi-Fi firmware and any other bianry files if you need, except the bootloader itself.

* [Using Arduino IDE](#using-arduino-ide): You can update system firmware and  user application. If you have a RBLink in hand, you can even update the bootloader.


## <span id="using-dfu-util">Using dfu-util</span>

Before using the dfu-util, you have to install it first. Please follow the [dfu-util Installation Guide](dfu-util_installation_guide.md) to install it on your computer.

For Windows users, if you havn't install the DFU USB driver for Duo, please follow the [Windows Driver Installation Guide](windows_driver_installation_guide.md) to install the driver first.

**All of the firmware images are available on this [GitHub Repository](https://github.com/redbear/Duo/tree/master/firmware).** Just download what you need.

dfu-util command line options:

* *-d* : specify the DFU device's USB ID. For Duo it is "2b04:d058"
* *-a* : specify the interface of the memory. For Duo it has three interfaces.
 
    - 0: access the internal memory space, except the bootloader memory space
    - 1: access the application DCT (not the entire DCT) memory space
    - 2: access the external SPI flash memory space <br><br>

* *-s* : specify the offset address of the memory space to store the binary file from
* *-D* : the binary (.bin) file specified is going to be downloaded to the DFU device
* *-U* : the binary (.bin) file specified is going to store the raw data that is dunmped from DFU device
* *:leave* : append this option to the offset address will make device exit DFU Mode, e.g. `-s 0x80C0000:leave`.

Now make your Duo enter DFU Mode:

1. Hold down BOTH buttons
2. Release only the RESET button, while holding down the SETUP button.
3. Wait for the LED to start blinking **yellow**
4. Release the SETUP button

#### Update DCT (Device Configuration Table)

* Update the entire DCT:     
`dfu-util -d 2b04:d058 -a 0 -s 0x8004000 -D fac-dct-r1.bin`

* Update the server public key:     
`dfu-util -d 2b04:d058 -a 1 -s 2082 -D server_public_key.der`

* Update the device private key that you backup before:    
`dfu-util -d 2b04:d058 -a 1 -s 34 -D device_private_key.der`

* Dump the entire DCT. It may contain the device private key and the Wi-Fi credentials, so you need to keep it privately:     
`dfu-util -d 2b04:d058 -a 0 -s 0x8004000 -U my_dct.bin`

* Dump the server public key:    
`dfu-util -d 2b04:d058 -a 1 -s 2082 -U server_public_key.der`

* Dump the device private key. It's such important and secret that you must keep it privately:     
`dfu-util -d 2b04:d058 -a 1 -s 34 -U device_private_key.der`

You can also download or dump other configurations to / from DCT using dfu-util. Please refer to the [Duo Firmware Architecture](duo_software_architecture_introduction.md) to obtain the offset address of each configuration.

#### Update System Firmware

* Update system part 1:    
`dfu-util -d 2b04:d058 -a 0 -s 0x8020000 -D duo-system-part1-vx.x.x.bin`

* Update system part 2:     
`dfu-util -d 2b04:d058 -a 0 -s 0x8040000 -D duo-system-part2-vx.x.x.bin`

* Update factory reset application (FAC):     
`dfu-util -d 2b04:d058 -a 2 -s 0x140000 -D duo-fac-xxxx.bin`

#### Update User Application

* Update user application:     
`dfu-util -d 2b04:d058 -a 0 -s 0x80C0000 -D duo-user-part.bin`

* Dump user application:     
`dfu-util -d 2b04:d058 -a 0 -s 0x80C0000 -U duo-user-part.bin`

#### Update Wi-Fi Firmware

* Update Wi-Fi firmware:     
`dfu-util -d 2b04:d058 -a 2 -s 0x180000 -D duo-wifi-r1.bin`

#### Sample Output
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
    Download    [=========================] 100%        38492 bytes
    Download done.
    File downloaded successfully  


## <span id="using-arduino-ide">Using Arduino IDE</span>

If this is your first time playing with the Duo using Arduino IDE, you are recommended to follow the [Duo Getting Started with Arduino IDE Guide](duo_getting_started_with_arduino.md) to set up the Arduino environment first.

#### Update User Application (aka. Arduino sketch)

To upload your sketch, simply click on the ![image](images/Upload_icon.png) icon.

#### Update System Firmware

##### 1. via Native USB Port

If you connect your Duo directly to the computer, you can update the Duo's system firmware, which includes system part 1, system part 2 and a factory reset application, by using the "**Duo FW Uploader**" programmer.

- Connect your Duo to computer and put it in DFU mode:

    - Hold down BOTH buttons
    - Release only the RESET button, while holding down the SETUP button.
    - Wait for the LED to start blinking **yellow**
    - Release the SETUP button

- Select the board: "Tools > Board: RedBear Duo (Native USB Port)"

- Select the programmer:  "Tools > Programmer: Duo FW Uploader"

- Click on "Tools > Burn Bootloader" to update the system firmware.

- After the burn bootloader operation completed, the on-board blue LED start blinking rapidly, since it has also downloaded a blink application, in case that your old application is not compatible with the updated system firmware.

##### 2. via RBLink USB Port

If you mount your Duo onto RBLink and connect the RBLink to your computer, you can update the Duo's bootloader and its system firmware except the factory reset application, by using the "**RBLink**".

- Mount your Duo (be aware of the orientation) onto RBlink and connect the RBLink to your computer

- Select the board: "Tools > Board: RedBear Duo (RBLink USB Port)"

- Select the programmer:  "Tools > Programmer: RBLink"

- Click on "Tools > Burn Bootloader" to update the bootloader and system firmware.

- After the burn bootloader operation completed, the on-board blue LED start blinking rapidly, since it has also downloaded a blink application, in case that your old application is not compatible with the updated system firmware.


## Reference

* [Duo introduction](duo_introduction.md)
* [dfu-util installation guide](dfu-util_installation_guide.md)
* [Duo DFU USB driver installation guide](windows_driver_installation_guide.md)
* [Arduino board package installation guide](duo_arduino_board_package_guide.md)
* [Duo firmware architecture overview](duo_firmware_architecture_overview.md)
* [Duo firmware source code](https://github.com/redbear/firmware)
* [RedBear discussion forum](http://discuss.redbear.cc/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
