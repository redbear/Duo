# Particle Firmware: How It Works
---

The RedBear Duo is pre-installed the customed Particle Firmware during manufacturing. This guide tries to explain the working mechanism of the Particle Firmware in details.

* [Startup](#startup)
* [Booting](#booting)
* [Run System Part 1](#run-system-part-1)
* [Run System Part 2](#run-system-part-2)


## <span id="startup">Startup</span>

Upon the Duo power on, it configures the system clock -- Waiting the High Speed External crystal oscillator (HSE) to be stable and then configuring the main system clock, just the same as what most ARM cortex MCU working through upon power on. 

After the main system clock configured, it jumps to the `main()` function in the bootloader to begin the [boot procedure](#booting).

Reference code:

* [LoopFillZerobss](https://github.com/redbear/firmware/blob/duo/build/arm/startup/startup_stm32f2xx.S#L95)    
* [SystemInit()](https://github.com/redbear/firmware/blob/duo/platform/MCU/STM32F2xx/SPARK_Firmware_Driver/src/system_stm32f2xx.c#L201)


## <span id="booting">Booting</span>

Upon entering the boot procedure, it initialises the peripherals that may be used in the bootloader, e.g. Systick, CRC, RTC, Watchdog, Timers, on-board RGB, LED and button.

After the platform setup, it loads the system flags from DCT. These flags  and certain backup registers will be judged and determine the workflow of bootloader.

If the **`wiced_application`** flag is equal to **`0x5AA5`**, which is set after uploading WICED application using dfu-util and means that there is a valid WICED application in corresponding region, then the bootloader assumes that the Duo is applying the WICED architecture. Else the bootloader assumes that the Duo is applying the Particle Firmware architecture.

#### WICED Architecture

If the Duo is applying the WICED architecture, then the bootloader works according to the following logic:

- If the SETUP button is pressed, then it enters in [DFU Mode](#dfu-mode)

- If the SETUP button is NOT pressed, then it jumps to run WICED application.

#### Particle Firmware Architecture

If the Duo is applying the Particle Firmware architecture, then the bootloader works in the following sequence:

1. If the **`Factory_Reset_SysFlag`** is equal to **`0xAAAA`**, which is set by user application, then it adds the [Factory Reset Mode](#factory-reset-mode) to candidate modes and clears the flag.

2. If the **`BKP_DR_01`** backup register is equal to **`0xEDFA`**, which is set by user application, then it adds the [DFU Mode](#dfu-mode) to candidate modes and clears the register.

3. If the **`BKP_DR_01`** backup register is equal to **`0x5AFE`**, which is set by user application, then it adds the [Safe Mode](#safe-mode) to candidate modes and clears the flag.

4. If the SETUP button is pressed, then one of the following situations may occure:

	- Release the button during 0 ~ 3 seconds (i.e. blinking **magenta**). It removes the Factory Reset Mode from candidate modes. And if the DFU Mode is not in the candidate modes, then it adds the Safe Mode to candidates modes, otherwise, it removes the Safe Mode from candidate modes.
	
	*If the factory reset application (FAC) is valid in external flash:*

	- Release the button during 3 ~ 6 seconds (i.e. blinking **yellow**). It removes the Factory Reset Mode and Safe Mode from candidate modes and adds the DFU Mode to candidate modes. 
	
	- Release the button during 6 ~ 9 seconds (i.e. blinking **green**). It removes the DFU Mode from candidate modes and adds the Factory Reset Mode to candidate modes.
	
	- Release the button during 9 ~ 12 seconds (i.e. blinking **white**). It removes the DFU Mode from candidate modes and adds the Factory Reset Mode to candidate modes and also sets a flag to indicate system firmware to clear Wi-Fi credentials.

	- If you don't release the button after 12 seconds, then it adds the Factory Reset Mode to candidate modes and also sets a flag to indicate system firmware to clear Wi-Fi credentials. Then it automatically goes to the next stage.

	*If the factory reset application (FAC) is NOT valid in external flash:*

	- Release the button after 3 seconds (i.e. always blinking **yellow**). Removes the Factory Reset Mode and Safe Mode from candidate modes. Adds the DFU Mode to candidate modes.  <br><br>

5. If the Factory Reset Mode is in the candidate modes, then the bootloader copies the factory reset application from external flash to internal flash where the user application locates (rapid blinking **white** or **green**). After that, the Duo resets to start from [Startup](#startup).

6. Else if the DFU Mode is in candidate modes, then the bootloader stays in DFU Mode for uploading firmware. After the DFU Mode exited or you perform a hardware reset, the Duo will start from [Startup](#startup).

7. Else if the Safe Mode or none of the above modes is in candidate modes, then the bootloader checks if there is OTA downloaded firmware or user application in the OTA region of the external flash. If true, the bootloader then updates the internal firmware or user application with the OTA downloaded one (rapid blinking **magenta**). If Safe Mode is in candidate modes, the bootloader sets a flag to indicate the system firmware to enter safe mode, i.e. not to run user application. Then the bootloader checks if the system firmware is valid, if true, then it jumps to [run system Part 1](#run-system-part-1), otherwise, it stays in DFU Mode for uploading firmware. After the DFU Mode exited or you perform a hardware reset, the Duo will begin from [Startup](#startup).

Reference code:

* The bootloader [main()](https://github.com/redbear/firmware/blob/duo/bootloader/src/main.c#L85) function


## <span id="run-system-part-1">Run System Part 1</span>

Once program runs into system part 1, it does nothing except jumping to the [system part 2](#run-system-part-2).

Reference code:

* [system_part1_boot_table](https://github.com/redbear/firmware/blob/duo/modules/shared/stm32f2xx/inc/system_part1_loader.c#L34)
* [system_part1_reset_handler()](https://github.com/redbear/firmware/blob/duo/modules/shared/stm32f2xx/inc/system_part1_loader.c#L28)


## <span id="run-system-part-2">Run System Part 2</span>

The system part 2 is the core of the system. It runs the embedded FreeRTOS real-time operating system. Most of the system functionalities are integrated into system part 2. And the user application is executed either in a separated thread or within the infinite loop of the main thread.

### Pre-Initialization

Before running into the main() function of system part 2, it does some initialization works, e.g., re-map the vector table, configure system clock, copy global variables into RAM, construct C++ objects, initialise on-board peripherals and etc. Then it jumps into the main() function of system part 2.

Reference code:

* [HAL_Core_Config()](https://github.com/redbear/firmware/blob/duo/hal/src/stm32f2xx/core_hal_stm32f2xx.c#L292)

### Starting FreeRTOS

#### System Thread

#### Application Thread

##### setup()

##### loop()

## Device Modes

### <span id="dfu-mode">DFU Mode</span>

### Factory Reset Mode

### Safe Mode

### Listening Mode

### OTA Updating Mode


## References




## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


