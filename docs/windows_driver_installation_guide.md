
# Duo: Windows Driver Installation Guide
---

**Note: All the drivers mentioned here are for the Duo that running the Particle firmware. For the Duo that running the WICED application hasn't  implemented the USB device capability.**

This guide aims to show you how to install the driver for Duo, including application USB driver and DFU USB driver, and the driver for RBLink if you have one in hand. 

This guide is for Windows user only. Mac and Linux users need not to install driver for Duo.

* [Install Duo Application USB Driver](#install-duo-application-usb-driver)
* [Install Duo DFU USB Driver](#install-duo-dfu-usb-driver)
* [Install RBLink USB Driver](#install-rblink-usb-driver)


## <span id="install-duo-application-usb-driver">Install Duo Application USB Driver</span>

After your Duo boots-up to run system firmware, it will appear as USB comport device on your computer. The device name is **"Duo with WiFi and BLE"**.

### Windows XP / 7

* [Download](https://github.com/redbear/Duo/raw/master/driver/windows/duo_win_driver.zip) the Windows driver and unzip the file. It is fine to unzip this as a default into your 'Downloads' folder.

* Navigate to "Control Panel > Hardware and Sound > Device Manager" and double-click on your Duo device under "Other Devices".
	
* Right click the device and click "Update Driver", and select "Browse for driver software".

	![image](images/SearchDriver.png)

* On the next screen click "Let me pick from a list of device drivers on my computer".

	![image](images/BrowseDriver.png)

* Click the "Have Disk..." button to open the directory to find `duo.cat`. Navigate to the folder you download the driver, or wherever you unzipped the drivers, by clicking the "Browse..." button. Click "Next" to install the driver.

* Driver installed.

	![image](images/Complete.png)

* You will see 'Duo with WiFi and BLE' under Ports.

	![image](images/Done.png)

### Windows 8 / 10

For Windows 10, it seems that you may skip this, since it already has a built in driver for serial port -- it shows as USB Serial Device.

In the "Device Manager", your Duo device may be listed under "Ports":

![image](images/DeviceManager.png)

But you can still install the driver for Duo by following the steps as installing driver for Windows XP / 7.

If you cannot install the driver, it is due to the driver is not digitally signed, applied to Windows 8 / 10. 

![image](images/SelectDriver.png)

Please follow this [guide](http://www.howtogeek.com/167723/how-to-disable-driver-signature-verification-on-64-bit-windows-8.1-so-that-you-can-install-unsigned-drivers/) to disable the driver signature verification temporarily first and try again. Once you do that, redo the driver installation steps. We are working on getting the driver signed so you won't have to do this anymore.

If the follow screen prompt out, select "Install this driver software anyway".

![image](images/Warning.png)


## <span id="install-duo-dfu-usb-driver">Install Duo DFU USB Driver</span>

Connect your Duo to computer and put it in the DFU Mode:

1. Hold down BOTH buttons
2. Release only the RESET button, while holding down the SETUP button.
3. Wait for the LED to start blinking **yellow**
4. Release the SETUP button

The Duo will appear as "Other Devices" on your computer. The device name is **"Duo DFU Mode"**.

* Download [Zadig](http://zadig.akeo.ie/) utils.

* Connect your Duo to computer and make it enter DFU mode.

* Run Zadig. Click on "Options > List all devices" and Select "Duo DFU Mode" and "**libusbK**" for the driver, press the "Install Driver" button.

    ![image](images/Zadig.png)

* It will show "Driver installed successfully".
## <span id="install-rblink-usb-driver">Install RBLink USB Driver</span>

For the RBLink, since it is completely compatible with ST-Link/v2, they share the same driver and software, i.e., the ST-LINK Utility provided by STMicroelectronics will also works for the RBLink. To install the driver for RBLink, you need to install ST-LINK Utility first. 

* Download [ST-LINK Utility](http://www.st.com/content/st_com/en/products/embedded-software/development-tool-software/stsw-link004.html#getsoftware-scroll) from ST website.

* Unzip the downloaded file and double click on the "**STM32 ST-LINK Utility v3.9.0.exe**" to install the ST-LINK Utility. The installer version may differ from the one you downloaded, but the latest one would be suggested.

* Follow the on-screen prompts to install the STM32 ST-LINK Utility. It will ask for you to install the related drivers, just accept it.

* After the ST-LINK Utility being installed, connect the RBLink to your computer. It will automatically install the drivers for the RBLink. When drivers are installed, navigate to "Control Panel > Hardware and Sound > Device Manager", you'll see a new device under "**Universal Serial Bus Devices**":

    ![image](images/STLink_dongle.png)     
  
    And a new comport under "**Ports (COM & LPT)**":

    ![image](images/STLink_port.png)

If you can not see the device and comport in Device Manager or they are under the wrong categories, please install the driver for RBLink manually:

1. Start the Device Manager and find the listed device for RBLink.

2. Uninstall the device, checking the "Suppress the driver for this device" box.

3. Unplug and plug the RBLink. Right click the device and click "Update Driver", and select "Browse for driver software".

4. On the next screen click "Let me pick from a list of device drivers on my computer". Then navigate to the folder you install the ST-LINK Utility, Choose the folder "**ST-LINK\_USB\_V2\_1\_Driver**". Click "Next" to install the driver.


## What's Next

* [Getting Started with Arduino IDE](getting_started_with_arduino_ide.md)
* [Getting Started with Particle Build (WebIDE)](getting_started_with_particle_build.md)


## References

* [Duo Inroduction](duo_introduction.md)
* [Disable Driver Signature on Windows 8/10](http://www.howtogeek.com/167723/how-to-disable-driver-signature-verification-on-64-bit-windows-8.1-so-that-you-can-install-unsigned-drivers/) 
* [Zadig Wiki page](https://github.com/pbatard/libwdi/wiki/Zadig)
* [dfu-util Installation Guide](dfu-util_installation_guide.md)
* [ST-LINK Utility User Manual](http://www.st.com/content/ccc/resource/technical/document/user_manual/e6/10/d8/80/d6/1d/4a/f2/CD00262073.pdf/files/CD00262073.pdf/jcr:content/translations/en.CD00262073.pdf)


## Resources

* [Duo Application USB Driver](https://github.com/redbear/Duo/raw/master/driver/windows/duo_win_driver.zip)
* [Zadig](http://zadig.akeo.ie/)
* [ST-Link Utility](http://www.st.com/content/st_com/en/products/embedded-software/development-tool-software/stsw-link004.html#getsoftware-scroll)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
