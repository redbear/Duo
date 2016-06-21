# Duo: Out-of-Box Experience
---

Glad you've received your Duo from vendor! Thanks for purchasing the Duo and hope you'll have a lots of fun with it! Now let's take it out of the box and have your first experience on the Duo.

* [User Interface](#user-interface)
* [Initial Setup](#initial-setup)
    - [Using iOS/Android App](#using-iosandroid-app)
    - [Using Serial Terminal](#using-serial-terminal)
* [Toggle the on-board LED using web browser](#toggle-the-on-board-led-using-web-browser)
* [Further Operations](#further-operations)
    - [Backup the device private key (Highly Recommended)](#backup-the-device-private-key-highly-recommended)
    - [Update system firmware if needed](#update-system-firmware-if-needed)
* [What's Next](#whats-next)
* [References](#references)


## <span id="user-interface">User Interface</span>

![image](images/RBDuo-L.png)

* **RESET**: Reset button for resetting the Duo board
* **SETUP**: User button for setting up the Duo
* **RGB**: RGB LED for indicating the Duo status
* **LED**: Single blue LED for user use
* **USB**: Micro USB connector for communication with the Duo


## <span id="initial-setup">Initial Setup</span>

### <span id="using-iosandroid-app">Using iOS/Android App</span>

* TBD

### <span id="using-serial-terminal">Using Serial Terminal</span>

#### 1. Power on

Connect your Duo to computer via its native USB port with micro USB cable (ensure that the cable has data exchangement capability). Then the on-board RGB LED will keep flashing **blue**, i.e. the Duo is in Listening Mode for you to set Wi-Fi credentials. You'll learn that the Duo is more versatile when it is in Listening Mode.

![image](images/Duo-Blue.gif)

#### 2. Start serial terminal

* For Windows:

    - Please follow the [Windows Driver Installation Guide](windows_driver_installation_guide.md) to install the driver for Duo.

    - Install the [PuTTY](http://the.earth.li/~sgtatham/putty/latest/x86/putty.zip) serial terminal and start it. Change the Serial port to your one and press the "Open" button. You can also install other serial terminal, e.g. HyperTerminal, Tera Term, Arduino Serial Monitor(No line ending) and etc.

        ![image](images/PuTTY_01.png)

* For OSX and Linux:

    - Start the Terminal and use the "screen" command. On Linux (e.g. Ubuntu), you may need to install screen by:     
    `$ sudo apt-get install screen`.
	
    - On OSX, type:     
    `$ screen /dev/tty.usbmodemXXXXX`, where `XXXXX` is your Duo device serial port.     

        On Linux, type:     
        `$ screen /dev/tty.ACMX`, where `ACMX` is your Duo device serial port. 

        If you are not sure about the serial port, you can list the device by:   
  
        OSX: `$ ls /dev/tty.usbmodem*`    
        Linux: `$ ls /dev/tty.ACM*`
			
        If there is no such device, you may need to check your USB cable.

#### 3. Check system firmware version

Type in '**v**' on the terminal, it will print the version string, e.g.:

    system firmware version: 0.2.4

In later chapter, you can check the system firmware change-log to decide if you need an update of the system firmware.

#### 4. Fetch unique device ID

Type in '**i**' on the terminal, it will print the unique 12-bytes device ID, e.g.:

    Your device id is 3e00xxxxxxxx343530343432

In later chapter, the device ID will be used for claiming your Duo on the Particle Cloud, please have a copy of it.

#### 5. Set Wi-Fi Credentials

* Type in '**w**' on the terminal, it will ask you to enter the SSID, Security type and password to associate to your AP. Sample input and output:

        SSID: AP-01
        Security 0=unsecured, 1=WEP, 2=WPA, 3=WPA2: 3
        Password: YOUR_PIN_ONLY_YOU_KNOW
        Thanks! Wait while I save those credentials...

        Awesome. Now we'll connect!

        If you see a pulsing cyan light, your device
        has connected to the Cloud and is ready to go!

        If your LED flashes red or you encounter any other problems,
        visit https://www.particle.io/support to debug.

        Particle <3 you!

* If everything is ready, Duo will leave Listening Mode and try to connect to the AP with the RGB flashing **green**. If Duo connects to the AP successfully, it then performs a soft reset to restart. Otherwise, Duo will enter Listening Mode again for you to re-set the Wi-Fi credentials.

    ![image](images/Duo-Green.gif)

    **Note: If you are using PuTTY or other serial terminal, when the Duo performs a reset, it disconnect from the terminal and the serial port may not be valid any more. You need to close the serial port, then press the on-board RESET button and open the serial port again to restore the communication with Duo.**

#### 6. Claim your Duo on the Partcile Cloud (optional)

We work closely with Particle team and the Duo for development purpose, can freely and easily access the Particle Cloud and benifit from the services and tools provided by Particle, e.g., Particle WebIDE, Particle Dashboard, Particle Event System and etc. If you want to benefit from these features, you have to work through the following steps to claim your Duo first.

* Make sure that the Duo is connected to the Particle Cloud, i.e. the RGB is breathing **cyan**. If it can not connect to the Cloud, please check out the [Duo Troubleshooting](duo_troubleshooting.md) to fix it first before moving on.

* Go to [Particle Build](https://build.particle.io). Creat an account if you don't have one yet, or just login.

* Navigate to the ![image](images/Devices.png) tag at the left-bottom corner and click to switch to the devices view.

* Click on the "ADD NEW DEVICE" button.

	![image](images/AddDevice.png)
	
* Enter your Duo's device ID that you just got at step 3 and click on the "CLAIM A DEVICE" to claim your Duo. The device ID should be made up of lowercase HEX charaters.

	![image](images/ClaimDevice.png)

* If claimed successfully, give a name to your Duo and then press the "SAVE" button. Otherwise, please check out the [Duo Troubleshooting](duo_troubleshooting.md)

	![image](images/NameDevice.png)
	
* Your Duo will be listed in "Other Devices". Never mind, refresh the whole page, you will see it is now under the "Duo" lable. The breathing cyan dot indicates your Duo is online.

	![image](images/DoneDevice.png)

**Congratulations! You have successfully set up your Duo! Now let's try controlling the on-board LED using web browser!**


## <span id="toggle-the-on-board-led-using-web-browser">Toggle the on-board LED using web browser</span>

A default web server application now is running on your Duo, with broadcasting a mDNS service. From the serial terminal, you can see the following message:

    Arduino sketch started.

    Note: If your Duo hasn't stored a valid WiFi profile, it will enter the listening mode for provisioning first.

    Waiting for an IP address...

    Duo's web server IP Address: 192.168.1.11 
 
    Make sure your smart device acting as web client is connecting to the same AP as Duo.
    Then open the web browser on your smart device and enter the Duo's web server IP address.
 
    setService
    mdns.begin
    mdns/setup success

* Make sure that the device you are going to start a web browser is connecting to the same AP as your Duo connnects to.

* Open a web browser, e.g. Safari or Chrome. If your browser support mDNS, you can just type "[duo.local](http://duo.local)" as the URL. Otherwisw, type "[http://192.168.1.11](http://192.168.1.11)" as the IP address showed in the serial message.

    ![image](images/Web.png)

* Press on the "HIGH" or "LOW" button to see any effect on your Duo's blue LED.


## <span id="further-operation">Further Operations</span>

### <span id="backup-the-device-private-key-highly-recommended">Backup the device private key (Highly Recommended)</span>

A device private key used for cloud connection establishment and cloud secure data exchangement is generated during manufacture. We highly recommend that you backup the device private key after your Duo connected to the Particle Cloud successfully, in case you destroy it for any reason. To investigate why you'd better backup the device private key, please read the [Devices Provisioning Guide](devices_provisioning_guide.md). 

Before you backup the device private key, since such key is so personal that if you don't trust RedBear during manufacture, you can also follow the [Devices Provisioning Guide](devices_provisioning_guide.md) to provision your Duo by yourself -- It will generate a new device private key in your Duo. And then work through the following steps to backup the device private key:

* Please follow the [dfu-util Installation Guide](dfu-util_installation_guide.md) to install the dfu-util on your computer.

* (**Windows only**) Please follow the [Windows Driver Installation Guide](windows_driver_installation_guide.md) to install the DFU USB driver first.

* Make your Duo enter DFU Mode:

    - Hold down BOTH buttons
    - Release only the RESET button, while holding down the SETUP button.
    - Wait for the LED to start blinking **yellow**
    - Release the SETUP button

* Open the command line prompt,

    - To backup the device private key, type:

            $ dfu-util -d 2b04:d058 -a 1 -s 34 -U device_private_key.der

    - To restore the device private key, type:

            $ dfu-util -d 2b04:d058 -a 1 -s 34 -D device_private_key.der

### <span id="update-system-firmware-if-needed">Update system firmware if needed</span>

We always recommend you update your Duo to the latest system firmware, since there may have new features added and bugfixes with a new released version. You should have known your Duo's current system firmware version at previous steps. Please check the [system firmware change-log](duo_system_firmware_changelog.md) to see if there is new system firmware version for an update. If available, follow the [Firmware Deployment Guide](duo_firmware_deployment_guide.md) to update the system firmware.


## <span id="whats-next">What's Next</span>

* [Getting Started with Arduino IDE](getting_started_with_arduino_ide.md)
* [Getting Started with Particle Build (WebIDE)](getting_started_with_particle_build.md)


## <span id="references">References</span>

* [Duo Inroduction](duo_introduction.md)
* [Applications Development Guide](applications_development_guide.md)
* [Firmware Architecture Overview](firmware_architecture_overview.md)
* [Firmware Deployment Guide](firmware_deployment_guide.md)
* [System Firmware Change-log](system_firmware_changelog.md)
* [Devices Provisioning Guide](devices_provisioning_guide.md)
* [dfu-util Installation Guide](dfu-util_installation_guide.md)
* [Particle Build (WebIDE)](https://build.particle.io)
* [Particle Dashboard](https://dashboard.particle.io/)
* [Particle Docs](https://docs.particle.io/guide/getting-started/intro/photon/)
* [RedBear discussion forum](http://discuss.redbear.cc/)

## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

