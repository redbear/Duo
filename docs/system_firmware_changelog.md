# Duo: System Firmware Change-log
---


## Current Version

### v0.2.4
---

#### FEATURES

- BLE central now supports connecting 8 peripherals simultaneously
- Add BLE API for setting scan respond data
- Add BLE API for fetching MAC address
- Add wiring APIs for using external serial flash

#### ENHANCEMENTS

- Update BTStack library
- Add lots of BLE related macro definitions
- Update bootloader

#### BUGFIXES

- SoftAP http web page didn't work in listening mode
- Duo performs soft reset upon connected to AP if WiFi.off() is invoked before


## Version History

### v0.2.3
---

- For 2nd mass production firmware since 2016/04/20

#### FEATURES

- Support updating system-part1, system-part2 and factory reset firmware via local TCP/IP during the same connection
- Add JSON command to invalid user part
- BLE central can now connect to peripherals and perform read, write and receive notification 

#### ENHANCEMENTS

- Remove the crc32 calculation function when uploading sketch via avrdude, since the crc32 is appended to the compiled binary on the Arduino IDE side
- Add a ring buffer for staging the data to be notified to GATT client
- Add a thread to dealing with BLE events, instead of by invoking `ble.loop()` in the sketch
- Update BTStack library

#### BUGFIXES

- BLE RSSI display incorrectly
- If change the password for a stored WiFi credential using BLE provision, it makes no effect

### v0.2.2   
---

#### FEATURES

- Add APIs for fetching device name, i.e. "Duo-xxxx"
- Instantiate Serial2 in wiring functions, thus user can use it directly in sketch
- Add JSON command to leave listening mode
- Add JSON command to check if device has stored credentials
- Integrate BTStack BLE library into system firmware, instead of WICED BTE library
- Exports some BLE APIs for user part usage

#### ENHANCEMENTS

- Notify central device if BLE Provisioning failed.
- Give different responds to the TCP client during OTA uploading firmware
- JSON command "version" fetches the real module versions
- update BLE Provisioning protocol to support setting hidden SSID and full key length 

#### BUGFIXES

- SPI1 isn't instantiated by SPIClass because of the including header file order
- Tone on pin A4 and A5 failed

### v0.2.1
---

- For 1st mass production firmware since 2016/01/27

#### FEATURES

- Updating firmware via local TCP/IP
- Supports IPv6 protocol

#### ENHANCEMENTS

- Implements Servo functionality on more pins
- Implements Tone functionality on more pins
- Add Local Name attribute in BLE advertising packet

#### BUGFIXES

- Arduino uploading stocks on verify stage
- Arduino uploading fails on some PCs
- When jumping from DFU bootloader to system part 2, it generates a fake Arduino uploading request
- Duo performs reset before Arduino uploading completed since the Flash Update Timeout isn't cleared on every packet transfered
- When more than one Duo are advertising, LightBlue App can not distinguish from each other

### v0.2.0
---

- For 2nd PP firmware since 2016/01/06

#### FEATURES

- OTA updating system part firmware and bootloader using Particle cloud
- HCI interface APIs to interact with bluetooth controller
- Enable WiFi Tester

#### ENHANCEMENTS

- Arduino uploading is more stable
- MCU performs soft reset after WiFi credentials saved and listening mode exited
- It is more sufficient to determine to run WICED application or Particle application

### v0.1.1 (Initial Firmware)
---

- For 1st PP firmware since 2016/01/06

#### FEATURES
- Arduino IDE v1.6.6 with board manager package v0.1.1 compatible
- OTA update  user application using online Particle Build
- Bootloader automatically determines running Particle firmware or WICED firmware
- Support setting WiFi credentials via Soft AP, USB serial and BLE