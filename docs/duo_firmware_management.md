# Duo Particle Firmware Management
---

The Duo is installed the customed Particle Firmware by default before shipped out. You can manage the firmware using dfu-util, Arduino IDE, Duo App, DuoSetupCLI, Particle CLI, Particle Cloud, Ymodem and OpenOCD.

* [Using dfu-util](#using-dfu-util)
* [Using Arduino IDE](#using-arduino-ide)
* [Using DuoSetupCLI](#using-duo-setup-cli)
* [Using Particle CLI](#using-particle-cli)


## <span id="using-dfu-util">Using dfu-util</span>


### Update Bootloader



### Update DCT



### Update System Firmware

- Put your device in [DFU mode](https://docs.particle.io/guide/getting-started/modes/photon/) (flashing yellow LED)
- open a terminal window, change to the directory where you downloaded the files below, and run these commands (pay attention to the `-a` and `-s` options):  

    - dfu-util -d 2b04:d058 **-a 2 -s 0x140000** -D duo-fac-web-server-v0.2.4.bin
    - dfu-util -d 2b04:d058 **-a 0 -s 0x8020000** -D duo-system-part1-v0.2.4.bin
    - dfu-util -d 2b04:d058 **-a 0 -s 0x8040000**:leave -D duo-system-part2-v0.2.4.bin


## <span id="using-arduino-ide">Using Arduino IDE</span>

### The local Arduino burn bootloader method (since board package  v0.2.5)

For users using Arduino IDE, you can simply update the system firmware via burn bootloader option. You should have installed Arduino IDE 1.6.7 or above and [install or update the latest Arduino board package for Duo](https://github.com/redbear/STM32-Arduino) via "Boards Manager..."

#### Using Native USB Port

- Connect your Duo to computer and put it in [DFU mode](https://docs.particle.io/guide/getting-started/modes/photon/) (flashing yellow LED)
- Select board: "Tools > Board: RedBear Duo (Native USB Port)"
- Select programmer:  "Tools > Programmer: Duo FW Uploader"
- Click on "Tools > Burn Bootloader" to update system part1, system part2, user part ( a blink application) and factory reset images.

#### Using RBLinkUSB Port

- Mount your Duo (be aware of the orientation) onto RBlink and connect the RBLink to computer
- Select board: "Tools > Board: RedBear Duo (RBLink USB Port)"
- Select programmer:  "Tools > Programmer: RBLink"
- Click on "Tools > Burn Bootloader" to update bootloader, system part1, system part2 and user part (a blink application) images.


## <span id="using-duo-app">Using Duo App</span>

Power on your Duo and make it enter the listening mode. The Duo will act as an AP, e.g. "Duo-xxxx" and you can see it in the AP scanned list on your computer. Connect your computer to the AP which your Duo is brodcasting.

- will be available soon


## <span id="using-duo-setup-cli">Using DuoSetupCLI</span>

##### For using DuoSetupCLI v0.1.0 (cooperate with system firmware v0.2.3 or above)

- DuoSetupCLI --upload -f duo-system-part1-v0.2.4.bin -l
- DuoSetupCLI --upload -f duo-system-part2-v0.2.4.bin -l
- DuoSetupCLI --upload -f duo-fac-web-server-v0.2.4.bin -r 8 -l


## <span id="using-particle-cli">Using Particle CLI</span>

### The remote OTA method using  [Particle CLI](https://docs.particle.io/guide/tools-and-features/cli/photon/) (since system firmware v0.2.0)

For devices already online and connected to the cloud, the system firmware can be updated OTA using these commands:   

- particle flash YOUR_DEVICE_NAME  duo-system-part1-v0.2.4.bin
- particle flash YOUR_DEVICE_NAME  duo-system-part2-v0.2.4.bin

**Note**: You must download system binaries to a local directory on your machine for this to work.
<br>


## Reference




## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
