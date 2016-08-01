# Particle Firmware: How It Works
---

The RedBear Duo is pre-installed the customed Particle Firmware during manufacturing. This guide tries to explain the working mechanism of the Particle Firmware in details.

* [1. Startup](#1-startup)
* [2. Booting](#2-booting)
	* [2.1 WICED Architecture](#21-wiced-architecture)
    * [2.2 Particle Firmware Architecture](#22-particle-firmware-architecture)
* [3. Run System Part 1](#3-run-system-part-1)
* [4. Run System Part 2](#4-run-system-part-2)
    * [4.1 Pre-initialization](#41-pre-initialization)
    * [4.2 Start FreeRTOS](#42-start-freertos)
        * [4.2.1 Update bootloader if needed](#421-update-bootloader-if-needed)
        * [4.2.2 Generate device private key if it is empty](#422-generate-device-private-key-if-it-is-empty)
        * [4.2.3 Initialise native USB](#423-initialise-native-usb)
        * [4.2.4 Update user application if requested by Arduino IDE](#424-update-user-application-if-requested-by-arduino-ide)
        * [4.2.5 Network setup](#425-network-setup)
        * [4.2.6 Infinite loop](#426-infinite-loop)
            * [4.2.6.1 System loop](#4261-system-loop)
            * [4.2.6.2 User application loop](#4262-user-application-loop)


## <span id="1-startup">1. Startup</span>

Upon the Duo power on, it configures the system clock -- Waiting the High Speed External crystal oscillator (HSE) to be stable and then configuring the main system clock, just the same as what most ARM cortex MCU working through upon power on. 

After the main system clock configured, it jumps to the `main()` function in the bootloader to begin the [boot procedure](#booting).

See:

* [startup_stm32f2xx.S](https://github.com/redbear/firmware/blob/duo/build/arm/startup/startup_stm32f2xx.S): `LoopFillZerobss` 
* [system_stm32f2xx.c](https://github.com/redbear/firmware/blob/duo/platform/MCU/STM32F2xx/SPARK_Firmware_Driver/src/system_stm32f2xx.c): `SystemInit()`


## <span id="2-booting">2. Booting</span>

Upon entering the boot procedure, it initialises the peripherals that may be used in the bootloader, e.g. Systick, CRC, RTC, Watchdog, Timers, on-board RGB, LED and button.

After the platform setup, it loads the system flags from DCT. These flags  and certain backup registers will be judged and determine the workflow of bootloader.

If the **`wiced_application`** flag is equal to **`0x5AA5`**, which is set after uploading WICED application using dfu-util and means that there is a valid WICED application in corresponding region, then the bootloader assumes that the Duo is applying the WICED architecture. Else the bootloader assumes that the Duo is applying the Particle Firmware architecture.

#### <span id="21-wiced-architecture">2.1 WICED Architecture</span>

If the Duo is applying the WICED architecture, then the bootloader works according to the following logic:

- If the SETUP button is pressed, then it enters in [DFU Mode](#dfu-mode)

- If the SETUP button is NOT pressed, then it jumps to run WICED application.

#### <span id="22-particle-firmware-architecture">2.2 Particle Firmware Architecture</span>

If the Duo is applying the Particle Firmware architecture, then the bootloader works in the following sequence:

1. If the **`Factory_Reset_SysFlag`** is equal to **`0xAAAA`**, which is set by user application, then it adds the [Factory Reset Mode](#factory-reset-mode) to candidate modes and clears the flag.

2. If the **`BKP_DR_01`** backup register is equal to **`0xEDFA`**, which is set by user application, then it adds the [DFU Mode](#dfu-mode) to candidate modes and clears the register.

3. If the **`BKP_DR_01`** backup register is equal to **`0x5AFE`**, which is set by user application, then it adds the [Safe Mode](#safe-mode) to candidate modes and clears the flag.

4. If the SETUP button is pressed, then one of the following situations may occure:

	- Release the button during 0 ~ 3 seconds (i.e. blinking **magenta**). It removes the Factory Reset Mode from candidate modes. And if the DFU Mode is not in the candidate modes, then it adds the Safe Mode to candidates modes, otherwise, it removes the Safe Mode from candidate modes.

	- Release the button during 3 ~ 6 seconds (i.e. blinking **yellow**). It removes the Factory Reset Mode and Safe Mode from candidate modes and adds the DFU Mode to candidate modes. 
	
	*If the factory reset application (FAC) is valid in external flash:*
	
	- Release the button during 6 ~ 9 seconds (i.e. blinking **green**). It removes the DFU Mode from candidate modes and adds the Factory Reset Mode to candidate modes.
	
	- Release the button during 9 ~ 12 seconds (i.e. blinking **white**). It removes the DFU Mode from candidate modes and adds the Deep Factory Reset Mode to candidate modes, which additionaly sets a flag to indicate system firmware to clear Wi-Fi credentials comparing to the Factory Reset Mode.

	- If you don't release the button after 12 seconds, then it adds the Factory Reset Mode to candidate modes and also sets a flag to indicate system firmware to clear Wi-Fi credentials. Then it automatically goes to the next stage.

	*If the factory reset application (FAC) is NOT valid in external flash:*

	- Release the button after 3 seconds (i.e. always blinking **yellow**). Removes the Factory Reset Mode and Safe Mode from candidate modes. Adds the DFU Mode to candidate modes.  <br><br>

5. If the Factory Reset Mode is in the candidate modes, then the bootloader copies the factory reset application from external flash to internal flash where the user application locates (rapid blinking **white** or **green**). After that, the Duo resets to start from [Startup](#startup).

6. Else if the DFU Mode is in candidate modes, then the bootloader stays in DFU Mode for uploading firmware. After the DFU Mode exited or you perform a hardware reset, the Duo will start from [Startup](#startup).

7. Else if the Safe Mode or none of the above modes is in candidate modes, then the bootloader checks if there is OTA downloaded firmware or user application in the OTA region of the external flash. If true, the bootloader then updates the internal firmware or user application with the OTA downloaded one (rapid blinking **magenta**). If Safe Mode is in candidate modes, the bootloader sets a flag to indicate the system firmware to enter safe mode, i.e. not to run user application. Then the bootloader checks if the system firmware is valid, if true, then it jumps to [run system Part 1](#run-system-part-1), otherwise, it stays in DFU Mode for uploading firmware. After the DFU Mode exited or you perform a hardware reset, the Duo will begin from [Startup](#startup).

See:

* [main.c](https://github.com/redbear/firmware/blob/duo/bootloader/src/main.c): `main()`

## <span id="3-run-system-part-1">3. Run System Part 1</span>

Once program runs into system part 1, it does nothing except jumping to the [system part 2](#run-system-part-2).

See:

* [system_part1_loader.c](https://github.com/redbear/firmware/blob/duo/modules/shared/stm32f2xx/inc/system_part1_loader.c): `system_part1_boot_table` and `system_part1_reset_handler()`


## <span id="4-run-system-part-2">4. Run System Part 2</span>

The system part 2 is the core of the system. It runs the embedded FreeRTOS real-time operating system. Most of the system functionalities are integrated into system part 2. And the user application executes either in a separated thread or within the infinite loop of the main thread.

### <span id="41-pre-initialization">4.1 Pre-Initialization</span>

Before running into the main() function of system part 2, it does some initialization works, e.g., re-map the vector table, configure system clock, copy global variables into RAM, construct C++ objects, initialise on-board peripherals, check if user application is valid and etc. Then it jumps into the main() function of system part 2 to start the FreeRTOS.

See:

* [system_part2_loader.c](https://github.com/redbear/firmware/blob/duo/modules/shared/stm32f2xx/inc/system_part2_loader.c): `system_part2_pre_init()`
* [core_hal_stm32f2xx.c](https://github.com/redbear/firmware/blob/duo/hal/src/stm32f2xx/core_hal_stm32f2xx.c): `HAL_Core_Config()`

### <span id="42-start-freertos">4.2 Start FreeRTOS</span>

After pre-initialization completed, it jumps into the main() function of system part 2. In the main() function, it creates a thread, which is the system thread. Then it starts the task scheduler.

See:

* [core_hal_stm32f2xx.c](https://github.com/redbear/firmware/blob/duo/hal/src/stm32f2xx/core_hal_stm32f2xx.c): `application_start()`

#### <span id="421-update-bootloader-if-needed">4.2.1 Update bootloader if needed</span>

The system part 2 has a copy of the bootloader, which is updated by updating system part 2. In this stage, the Duo checks the existing bootloader version, if the bootloader in system part 2 is newer than the existing one, then it will re-write the bootloader region with the newer bootloader.

See:

* [bootloader.cpp](https://github.com/redbear/firmware/blob/duo/hal/src/stm32f2xx/bootloader.cpp): `bootloader_update_if_needed()`

#### <span id="422-generate-devicce-private-key-if-it-is-empty">4.2.2 Generate device private key if it is empty</span>

In this stage, if the Duo detectes that the device private key is empty, which is indicated by starting the device private key region with 0xFF, then it generates a new device private key and store it in the device private key region of the DCT. During generating the device private key, the on-board RGB will be blinking white.

See:

* [core_hal_stm32f2xx.c](https://github.com/redbear/firmware/blob/duo/hal/src/stm32f2xx/core_hal_stm32f2xx.c): `generate_key()`

#### <span id="423-initialise-native-usb">4.2.3 Initialise native USB</span>

In this stage, it initialise the native USB port.

See:

* [main.cpp](https://github.com/redbear/firmware/blob/duo/system/src/main.cpp): `HAL_USB_Init()`

#### <span id="424-update-user-application-if-requested-by-arduino-ide">4.2.4 Update user application if requested by Arduino IDE</span>

If the Duo receives an uploading request from Arduino IDE, the Duo will set a flag in DCT and then perform a soft-reset. After reset and running into this stage, the Duo will check the flag and if the flag is set, the Duo will enter the avr-dude uploading procedure for uploading Arduino sketch. After uploading completed, the Duo will perform a soft-reset to restart.

See:

* [main.cpp](https://github.com/redbear/firmware/blob/duo/system/src/main.cpp): `manage_serial_flasher()`

#### <span id="425-network-setup">4.2.5 Network setup</span>

1. Clear WiFi credentials if a Deep Factory Reset is performed before

2. If the Safe Mode is chose during booting or the system mode is set to `AUTOMATIC` in user application, the DUo will turn on WiFi and try to connect to configured AP. If no WiFi credentials is configured, it will enter  the Listening Mode automatically

3. Initialize the Particle cloud communication protocol

See:

* [main.cpp](https://github.com/redbear/firmware/blob/duo/system/src/main.cpp): `Network_Setup()`

#### <span id="426-Infinite-loop">4.2.6 Infinite loop</span>

This loop is made up of two sub loops, [system loop]((#4261-system-loop)) and [user application loop](#4262-user-application-loop). The system loop executes first followed by the user application loop and repeat. But if there is no valid user application detected at target address or the Safe Mode is chose, the user application loop will not execute.

##### <span id="4261-system-loop">4.2.6.1 System loop</span>

1. Monitor the USB serial to determine if ymodom or Arduino avr dude uploading user application procedure should enter. Once enter the uploading procedure, the user application is uploaded via  USB serial and once finished, the Duo perform a soft-reset.

2. Manage the network connection. It will disconnect the network connection from AP  and turn off the WiFi if requested by user application. It will try to connect to the AP which is configured in the DCT. The Duo is capable of storing up to 5 WiFi credentials. When trying to connect to AP, it tries the configured AP one by one in the sequence you configuring them, until the Duo connects to one of the AP successfully. If the Duo can not connect to any of the configured AP, then it will try again in the next system loop.

3. Enter Listening Mode if requested by user application or by keeping pressing the SETUP button for at least 3 seconds. In the Listening Mode, the RGB blinks blue and it broadcasts a WiFi SoftAP and BLE Peripheral. During the mode, you can configure WiFi credentials via SoftAP and BLE Peripheral, update system firmware and user application via SoftAP, fetch device ID and system firmware version and so on. Once entering the Listening Mode, neither the system loop nor user application will execute, since it  will block in the Listening Mode until a valid WiFi credentials is configured or updating firmware completed or exiting Listening Mode function is called in user application.

4. Update IP address if network connection is created.

5. Manage the Cloud connection and process cloud events. Something like OTA updating system firmware and user application, publishing/subscribing cloud events, exposing cloud functions and variables and anything else releated to the cloud., is handled at this stage.

6. Check if the system should perform a soft-reset that is pending because of system operation, e.g., OTA or via USB serial updating firmware completed.

See:

* [system_task.cpp](https://github.com/redbear/firmware/blob/duo/system/src/system_task.cpp): `Spark_Idle_Events()`

##### <span id="4262-user-application-loop">4.2.6.2 User application loop</span>

1. setup() - It executes only once at the first time running the user application loop. The `setup()` function is corresponding to the `setup()` function in user application.

2. loop() - It executes in every user application loop. The `loop()` function is corresponding to the `loop()` function in user application.

See:

* [main.cpp](https://github.com/redbear/firmware/blob/duo/system/src/main.cpp): `app_loop()`


## <span id="references">References</span>

* [Duo Introduction](duo_introduction.md)
* [Out-of-Box Experience](out_of_box_experience.md)
* [Getting Started with Arduino IDE](getting_started_with_arduino_ide.md)
* [Getting Started with Particle Build (Web IDE)](getting_started_with_particle_build.md)
* [Firmware Deployment Guide](firmware_deployment_guide.md)
* [Programming Reference Manual](programming_reference_manual.md)
* [Firmware Architecture Overview](firmware_architecture_overview.md)


## <span id="resources">Resources</span>

* [Modified Particle Firmware Source Code](https://github.com/redbear/firmware)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


