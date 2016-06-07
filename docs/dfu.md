
# dfu-util and DFU Driver Installation Guide

[dfu-util](http://dfu-util.sourceforge.net/) is a tool for Device Firmware Upgrade to the Duo via the USB port.


### Optional: [Build dfu-util from Source](http://dfu-util.sourceforge.net/build.html)

## Windows

* To use dfu-util, you need to download an USB library driver for the Duo, we make use of [Zadig](http://zadig.akeo.ie/) to install quickily. There is an [usage guide](https://github.com/pbatard/libwdi/wiki/Zadig) provided.

* Run Zadig after downloading and in the following screen, press the 'Install Driver' button.

	![image](images/Zadig.png) 
	
* Download the [dfu-util](http://dfu-util.sourceforge.net/releases/dfu-util-0.8-binaries/win32-mingw32/dfu-util-static.exe).

* Start the Command Line Terminal and navigate to the folder you downloaded the dfu-util

* Rename it to dfu-util.exe

		c:\> ren dfu-util-static.exe dfu-util.exe

* Suggest you to put the dfu-util.exe to your downloaded Duo firmware folder.

	![image](images/DFU.png)


## OSX

Use Brew to install or follow the instructions from [the official website](http://dfu-util.sourceforge.net/).

* Install [brew](http://brew.sh/) or start the Terminal to install it directly:

		$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

* In the Teminal, type this command to install the dfu-util:

		$ brew install dfu-util


## Linux

* Download the [dfu-util](http://dfu-util.sourceforge.net/releases/dfu-util-0.8-binaries/linux-i386/) or use
  the package manager of your distribution to get the latest version:

		$ sudo apt-get install dfu-util

* If you download dfu-util we suggest putting the binary into the Duo firmware folder.


## Check Version

* Type in command line terminal:
		
		$ dfu-util --version

* Sample output:

		dfu-util 0.8

		Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
		Copyright 2010-2014 Tormod Volden and Stefan Schmidt
		This program is Free Software and has ABSOLUTELY NO WARRANTY
		Please report bugs to dfu-util@lists.gnumonks.org


## List DFU Devices

* Firstly make your Duo enter DFU Mode:  

       - Connect the Duo to your computer via the USB port.
    - Hold down BOTH buttons
    - Release only the RESET button, while holding down the SETUP button.
    - Wait for the LED to start flashing yellow (it will flash magenta first)
    - Release the SETUP button <br><br>

        ![image](images/Duo-Yellow.gif)   

* Type in command line terminal:

        $ dfu-util -l

* Sample output:

        Deducing device DFU version from functional descriptor length
        Found DFU: [2b04:d058] ver=0200, devnum=3, cfg=1, intf=0, alt=2, name="@Serial Flash   /0x00000000/192*004Kg,128*004Kg,64*004Kg,128*004Kg", serial="00000000010C"
        Found DFU: [2b04:d058] ver=0200, devnum=3, cfg=1, intf=0, alt=1, name="@DCT Flash   /0x00000000/01*016Kg", serial="00000000010C"
        Found DFU: [2b04:d058] ver=0200, devnum=3, cfg=1, intf=0, alt=0, name="@Internal Flash   /0x08000000/01*016Ka,02*016Kg,01*016Kg,01*064Kg,07*128Kg", serial="00000000010C"
