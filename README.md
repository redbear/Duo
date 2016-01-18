
## RedBear Duo

The Red Bear Duo is a thumb-size development board designed to simplify the process of building Internet of Things (IoT) products. The Duo is software compatible with Broadcom WICED SDK and provides everything you need—Wi-Fi, BLE and a powerful Cloud backend, all in a compact form factor that makes it ideal for your first prototype, a finished product, and everything in between. 

The Duo contains both Wi-Fi and BLE capabilities. This means your project can communicate locally with Bluetooth enabled devices and can also connect to your local Wi-Fi network to interact with anything else on the web. The Duo is built around the Broadcom BCM43438, a Wi-Fi 802.11b/g/n plus Bluetooth 4.1 (Dual Mode) combined chipset. They share the same 2.4GHz antenna and can run at the same time. This gives you the flexibility to utilize the most suitable wireless technology(s) for your project.

![image](docs/images/Duo_BlockDiagram.jpg)

With the Red Bear RBLink you can easily attach modules from the Seeed’s Grove System to your project. No need to pull out your soldering iron--just attach your sensors and actuators with jumper wires to the RBLink and you’re ready to go. Looking to attach your own sensor or peripheral? The Duo is breadboard and solder friendly, so you’re never limited in what you can connect to the web.

## Features

Duo:

    •	STMicroelectronics STM32F205 ARM Cortex-M3 @ 120 MHz, 128 KB SRAM, 1 MB Flash
    •	Broadcom BCM43438 Wi-Fi 802.11n (2.4GHz only) + Bluetooth 4.1 (Dual Mode) combo chip
      (With an upgrade path to Bluetooth 4.2)
    •	On-board 16 Mbit (2 MB) SPI Flash
    •	Signal chip antenna (option to connect ext. antenna)
    •	18 I/O pins, 1 user LED
    •	RGB status LED
    •	USB, 2 UART, JTAG, 2 SPI, I2C 
    •	Single-sided PCBA for easy mounting on other PCB
    •	20.5 mm x 39 mm

RBLink:

    •	Running ST-LINK/V2
    •	USB-based JTAG debugger/programmer
    •	Two JTAG activity LEDs
    •	Apple MFi autetication coprosessor support (**MFi license is required)
    •	USB MSD interface – enabling programming the Duo by drag and drop of firmware file
    •	USB CDC Virtual Serial Port
    •	STM32 ST-LINK Uility software compatible
    •	8x Seeed Grove System compatible connectors
    •	53.5mm x 53.5mm

## Pinout

#### Duo:

![image](docs/images/RBDuo_Pinout.jpg)

#### RBLink:

![image](docs/images/RBLink_Pinout.jpg)

## Memory Map

The Duo's memeory allocation is different from the Photon. The following diagram shows, the Duo has external flash memory while the Photon has not, the flash is for storing the WiFi firmware to be loaded to the BCM43438 chip during boot-up, thus, this design saves the internal flash memory, the sketch for loading the user partition can be up to 256 KB while the Photon has 128 KB for user application only.
![image](docs/images/Duo_MemMap.png)

## Resources

#### Product Page

http://redbear.cc/duo/

#### Forum

https://redbearlab.zendesk.com/forums/23098916-RedBear-Duo

#### Program with Arduino IDE

https://github.com/redbear/STM32-Arduino

#### Program with Broadcom WICED SDK

https://github.com/redbear/WICED-SDK

