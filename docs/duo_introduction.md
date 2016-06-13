# RedBear Duo Introduction
---

![image](images/RBDuo.png)


## Overview

The [RedBear Duo](http://www.redbear.cc/duo) is a thumb-size development board designed to simplify the process of building Internet of Things (IoT) products. It is built with a powerful Cortext-M3 MCU, a wireless module which equips both Wi-Fi and BLE (Bluetooth Low Energy) connectivity, as well as abundant of peripherals. It enables you develop applications to communicate with other wireless accessories or your smart devices, e.g. mobile phone, tablet or computer, through BLE or Wi-Fi. If the Duo is connecting to a router which has internet capability, you can even communicate with the Duo through cloud. For example, you can just sit in your office and monitor the environment data sampled by the Duo at home.

The Duo supports several kinds of programming language, particularly like Arduino, C/C++, JavaScript and Python. You can develop the applications for Duo using GCC, Arduino IDE, Particle Web IDE, Espruino Web IDE and Broadcom WICED SDK.


## Features

* STMicroelectronics STM32F205 ARM Cortex-M3 @120 MHz, 128 KB SRAM, 1 MB Flash
* AMPAK AP6212A (Broadcom BCM43438 chip) wireless module with Wi-Fi and Bluetooth built-in
* Optional signal chip antenna or external antenna
* 1 x 2MB external SPI Flash
* 1 x RGB LED
* 1 x independent LED
* 1 x RESET button 
* 1 x user button
* 18 x digital I/O
* 8 x analog input
* 13 x PWM
* 2 x UART
* 2 x SPI
* 1 x I2S
* 1 x I2C 
* 1 x High Speed USB
* JTAG debug port presented
* Single-sided PCBA for easy mounting on other PCB
* Optional develop application using Arduino IDE, Particle Web IDE, Espruino Web IDE, Broadcom WICED SDK or ARM GCC
* Real-time operating system (FreeRTOS)
* Hardware and software open source
* FCC and CE certified


## Applications

* Industrial Automation
* Building Automation
* Smart Home Appliances
* Smart Toys
* IoT Enabled Sensors
* WiFi/BLE Gateway
* Beacon Management


## Block Diagram

![image](images/Duo_BlockDiagram.png)


## Pinout

![image](images/RBDuo_Pinout.png)


## Power Supply

Operating voltage: 3.3v


## Wireless Characteristics

The Duo is built around the Broadcom BCM43438, a Wi-Fi 802.11b/g/n plus Bluetooth 4.1 (Dual Mode) combined chipset. They share the same 2.4GHz antenna and can run at the same time. This gives you the flexibility to utilize the most suitable wireless technology(s) for your project.


## Dimension

Length x Wide: 39 mm x 20.5 mm


## References

* RedBear Duo [schematic](https://github.com/redbear/Duo/tree/master/hardware/schematic)
* On-board components' [datasheet](https://github.com/redbear/Duo/tree/master/hardware/datasheets)
* FCC & CE [certification](https://github.com/redbear/Duo/tree/master/certs)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
