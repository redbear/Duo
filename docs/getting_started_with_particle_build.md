# Duo: Getting Started with Particle Build (Web IDE)
---

The Duo is installed the customed Particle firmware by default during manufacturing, which enables you developing applications using the Particle Build (aka. Particle online Web IDE).


## <span id="update-firmware">Update System Firmware</span>

The latest system firmware is v0.3.3 and it is available [here](https://github.com/redbear/Duo/tree/master/firmware/system/v0.3.3). Please update the system firmware to v0.3.3 if needed. There is also a new Wi-Fi firmware for the Wi-Fi module and it can be found [here](https://github.com/redbear/Duo/tree/master/firmware/wifi).

We recommend that you update the system firmware using dfu-util. Please follow the [dfu-util Installation Guide](dfu-util_installation_guide.md) to install it on your computer. For Windows users, if you havn't install the DFU USB driver for Duo, please follow the [Windows Driver Installation Guide](windows_driver_installation_guide.md) to install the driver first.

1. Make your Duo enter the **DFU Mode**:

    - Hold down BOTH buttons
    - Release only the RESET button, while holding down the SETUP button.
    - Wait for the LED to start blinking **yellow**
    - Release the SETUP button

2. Update system part1:

    `dfu-util -d 2b04:d058 -a 0 -s 0x8020000 -D duo-system-part1-v0.3.3.bin`

3. Update system part 2:   
  
    `dfu-util -d 2b04:d058 -a 0 -s 0x8040000 -D duo-system-part2-v0.3.3.bin`

4. Update Wi-Fi firmware:
    
    `dfu-util -d 2b04:d058 -a 2 -s 0x180000 -D duo-wifi-r2.bin`


## <span id="configure-wifi">Configure Wi-Fi Credentials</span>

1. Make your Duo enter the **Listening Mode**. The Duo will enter the Listening Mode automatically after power on if there is no valid Wi-Fi credentials configured. If not, keep pressing the setup button for 3 seconds. In the Listening mode, the on-board RGB will be blinking blue.

    ![image](images/Duo-Blue.gif)

2. Start serial terminal

    * For Windows:

        - Please follow the [Windows Driver Installation Guide](windows_driver_installation_guide.md) to install the driver for Duo.

        - Install the [PuTTY](http://the.earth.li/~sgtatham/putty/latest/x86/putty.zip) serial terminal and start it. Change the Serial port to your one and press the "Open" button. You can also install other serial terminal, e.g. HyperTerminal, Tera Term, Arduino Serial Monitor and etc.
    
            **Note:** If you are using Arduino Serial Monitor, before sending 'i', 'v' and 'w', the line ending should be set to "No line ending", otherwise, the ending character will be treated as the next input character. And before sending SSID, security type, cipher and password, the line ending should be changed to "New line". This is because the Duo will echo message upon received the 'i', 'v' and 'w' commands, but other input prompts should be ended with the '\n' character.

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

3. Check system firmware version. Type in '**v**' on the terminal, it will print the version string, e.g.:

        system firmware version: 0.3.3

    In later chapter, you can check the system firmware change-log to decide if you need an update of the system firmware.

4. Fetch unique device ID. Type in '**i**' on the terminal, it will print the unique 12-bytes device ID, e.g.:

        Your device id is 3e00xxxxxxxx343530343432

    In later chapter, the device ID will be used for claiming your Duo on the Particle Cloud, please have a copy of it.

5. Set Wi-Fi Credentials. Type in '**w**' on the terminal, it will ask you to enter the SSID, Security type and password to associate to your AP. Sample input and output:

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

    If everything is ready, Duo will leave Listening Mode and try to connect to the AP with the RGB flashing **green**. If Duo connects to the AP successfully, it then performs a soft reset to restart. Otherwise, Duo will enter Listening Mode again for you to re-set the Wi-Fi credentials.

    ![image](images/Duo-Green.gif)

    **Note**: If you are using PuTTY or other serial terminal, when the Duo performs a reset, it disconnect from the terminal and the serial port may not be valid any more. You need to close the serial port, then press the on-board RESET button and open the serial port again to restore the communication with Duo.


## <span id="claim-device">Claim Your Device</span>

If the Duo is connected to a Wi-Fi router, which is able to connect to the internet, it then automatically connects to Particle cloud. During connecting to the cloud, the on-board RGB will be blinking cyan rapidly. Once it connected to the cloud the on-board RGB will be breathing cyan.

* Make sure that the Duo is connected to the Particle Cloud, i.e. the RGB is breathing **cyan**.

* Go to [Particle Build](https://build.particle.io). Creat an account if you don't have one yet, or just login.

* Navigate to the ![image](images/Devices.png) tag at the left-bottom corner and click to switch to the devices view.

* Click on the "ADD NEW DEVICE" button.

	![image](images/AddDevice.png)
	
* Enter your Duo's device ID that you just got at step 3 and click on the "CLAIM A DEVICE" to claim your Duo. The device ID should be made up of lowercase HEX charaters.

	![image](images/ClaimDevice.png)

* If claimed successfully, give a name to your Duo and then press the "SAVE" button.

	![image](images/NameDevice.png)
	
* Your Duo will be listed in "Other Devices". Never mind, refresh the page, you will see it is now under the "Duo" lable. The breathing cyan dot indicates your Duo is online.

	![image](images/DoneDevice.png)


## <span id="first-simple-application">First Simple Application</span>

1. Select one of your Duos that you are going to flash application by staring it on the left near to its name. Note that the Duo you selected must be online, i.e. there is a cyan idot breathing on the same label of the starred Duo, otherwise, you won't able to flash application to the Duo Over The Air (OTA).

    ![image](images/Build_Devices.png)

2. Click on the angle bracket on the right of the Duo, you will see the Duo's device ID. Under the "***Building with firmware***" label, select the system firmware version for the application you are going to compile against. For now, you'd better select the one that is equal to the system firmware version on the Duo. Otherwise, the application you compiled and flashed may not work well.

    ![image](images/FW_Version.png)

3. Click on the ![image](images/Code.png) icon, on the extended panel you can choose an example or create your own application to compile. Let's choose the "**1. BLINK AN LED**" as simple demonstration.

    ![image](images/Build_Code_Apps.png) 

4. Click on the ![image](images/FlashBlink.png) icon to compile and followed by OTA flashing the current application to your Duo. If you only want to verify the application, click on the ![image](images/Verify.png) icon.

    ![image](images/Build_Example.png)

5. During OTA flashing the application, your Duo will be toggling in magenta and the console on Web IDE will print:

        Flashing code...if it does not flash magenta, verify your code and try again.

    After OTA flash procedure completed, the console will print:

        Flash successful! Please wait a moment while your device is updated...

    After a moment, your Duo will re-boot to run the new updated application, you'll see the on-board blue LED toggles in every second interval.

6. Well done! You could try more other examples that under the "**Example apps**" label or, just start creating your own applications with the online Web IDE!

**More informations about the Particle Build, please read the [Particle's online documentation](https://docs.particle.io/guide/getting-started/build/photon/).**


## <span id="references">References</span>

* [Duo Introduction](duo_introduction.md)
* [Arduino/C/C++ Programming Reference Manual](programming_reference_manual.md)
* [Firmware Architecture Overview](firmware_architecture_overview.md)
* [How It Works](how_it_works.md)
* [Particle Build](https://build.particle.io)
* [Particle Documentation](https://docs.particle.io/guide/getting-started/intro/photon/)
* [RedBear Discussion Forum](http://discuss.redbear.cc/)
* [Particle Community](https://community.particle.io/)


## <span id="resources">Resources</span>

* [Modified Particle firmware Source Code](https://github.com/redbear/firmware)
* [Application Examples](https://github.com/redbear/STM32-Arduino/tree/master/arduino/libraries/RedBear_Duo)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
