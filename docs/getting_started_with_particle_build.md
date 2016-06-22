# Duo: Getting Started with Particle Build (Web IDE)
---

The Duo is installed the customed Particle firmware by default during manufacturing, which enables you developing applications using the Particle Build (aka. Particle online Web IDE). If you are running an application developed using WICED SDK, you will not able to access any of the services and tools provided by Particle, definitely including the Particle Build.

* [Requirements](#requirements)
* [First Simple Application](#first-simple-application)
* [Update System Firmware](#update-system-firmware)
* [What's Next](#whats-next)
* [References](#references)
* [Resources](#resources)


## <span id="requirements">Requirements</span>

* Particle account
* RedBear Duo development board
* Micro USB cable 


## <span id="first-simple-application">First Simple Application</span>

1. Please follow the [Out-of-Box Experience](out_of_box_experience.md) to claim your Duo to the Particle Cloud.

2. Till now, we assume that your Duo has successfully connected to the Particle Cloud. Login [Particle Build](https://build.particle.io). Click on the ![image](images/Devices.png) icon, it will list all of your claimed Particle devices. Select one of your Duos that you are going to flash application by staring it on the left near to its name. Note that the Duo you selected must be online, i.e. there is a cyan idot breathing on the same label of the starred Duo, otherwise, you won't able to flash application to the Duo Over The Air (OTA).

    ![image](images/Build_Devices.png)

3. Click on the angle bracket on the right of the Duo, you will see the Duo's device ID. Under the "***Building with firmware***" label, select the system firmware version for the application you are going to compile against. For now, you'd better select the one that is equal to the system firmware version on the Duo. Otherwise, the application you compiled and flashed may not work well.

    ![image](images/FW_Version.png)

4. Click on the ![image](images/Code.png) icon, on the extended panel you can choose an example or create your own application to compile. Let's choose the "**1. BLINK AN LED**" as simple demonstration.

    ![image](images/Build_Code_Apps.png) 

5. Click on the ![image](images/FlashBlink.png) icon to compile and followed by OTA flashing the current application to your Duo. If you only want to verify the application, click on the ![image](images/Verify.png) icon.

    ![image](images/Build_Example.png)

6. During OTA flashing the application, your Duo will be toggling in magenta and the console on Web IDE will print:

        Flashing code...if it does not flash magenta, verify your code and try again.

    After OTA flash procedure completed, the console will print:

        Flash successful! Please wait a moment while your device is updated...

    After a moment, your Duo will re-boot to run the new updated application, you'll see the on-board blue LED toggles in every second interval.

7. Well done! You could try more other examples that under the "**Example apps**" label or, just start creating your own applications with the online Web IDE!

**More informations about the Particle Build, please read the [Particle's online documentation](https://docs.particle.io/guide/getting-started/build/photon/).**


## <span id="update-system-firmware">Update System Firmware</span>

We always recommend you update your Duo's system firmware to the latest version, since there may have new features added and bugfixes within the new released version. 

It is very easy to update your Duo's system firmware with the Particle Build. Simply choose an upper firmware version for the application you are going to compile against (see step 3 of the [First Simple Application](#first-simple-application) section), and then OTA flash the application. It will automatically update your Duo's system firmware Over The Air. More details and other ways to update the system firmware, please refer to the [Firmware Deployment Guide](duo_firmware_deployment_guide.md).

You should note that the Particle Build only supports firmware upgrading, if you choose a lower firmware verison to compile against, it won't downgrade  the Duo's system firmware for you.


## <span id="whats-next">What's Next</span>

[Applications Development Guide](applications_development_guide.md)


## <span id="references">References</span>

* [Duo Introduction](duo_introduction.md)
* [Firmware Architecture Overview](firmware_architecture_overview.md)
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