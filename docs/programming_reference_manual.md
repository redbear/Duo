# Duo: Arduino/C/C++ Programming Reference Manual
---

## Overview

The Duo is installed the customed Particle firmware by default during manufacturing. You can build your own applications around the system firmware, which with lots of functions and libraries built-in so that you can invoke them directly in your sketch. The programming language and application architecture are almost Arduino compatible -- all you want should be achieved in the **`setup()`** and **`loop()`** function.

* **`setup()`** - Runs once at the beginning of your program    
* **`loop()`** - Runs continuously over and over

For example:

	int led1 = D0; // Instead of writing D0 over and over again, we'll write led1
	
	/* The setup function is a standard part of any microcontroller program.
	   It runs only once when the device boots up or is reset. */
	
	void setup() {
	  pinMode(led1, OUTPUT);
	}
	
	/* Next we have the loop function, the other essential part of a microcontroller program. This routine gets
	   repeated over and over, as quickly as possible and as many times as possible, after the setup function is called.
	
	   Note: Code that blocks for too long (like more than 5 seconds), can make weird things happen 
	   (like dropping the network connection). The built-in delay() function shown below safely interleaves required 
	   background activity, so arbitrarily long delays can safely be done if you need them. */
	
	void loop() {  
	  digitalWrite(led1, HIGH);  // To blink the LED, first we'll turn it on...
	  delay(1000);               // We'll leave it on for 1 second...
	  digitalWrite(led1, LOW);   // Then we'll turn it off...
	  delay(1000);               // Wait 1 second...
	  // And repeat!
	}


## Language Syntax

- [Structure](https://docs.particle.io/reference/firmware/photon/#structure)
- [Control Structures](https://docs.particle.io/reference/firmware/photon/#control-structures)
- [Further syntax](https://docs.particle.io/reference/firmware/photon/#further-syntax)
- [Arithmetic operators](https://docs.particle.io/reference/firmware/photon/#arithmetic-operators)
- [Boolean operators](https://docs.particle.io/reference/firmware/photon/#boolean-operators)
- [Bitwise operators](https://docs.particle.io/reference/firmware/photon/#bitwise-operators)
- [Compound operators](https://docs.particle.io/reference/firmware/photon/#compound-operators)
- [Variables](https://docs.particle.io/reference/firmware/photon/#variables)
- [Data Types](https://docs.particle.io/reference/firmware/photon/#data-types)


## Reference

Since the Duo shares most of the firmware source code with Particle Photon, most of the functions and libraries designed for Photon are valid for the Duo as well. Each of these functions and libraries is described extremely in detail on the [Particle Reference](https://docs.particle.io/reference/) website, so we're not going to duplicate it here, but only list the APIs for quick reference. Regarding to the reference on the unique features of the Duo, we will document it here in detail.

### Inherit from Particle Reference
- [Cloud Functions](https://docs.particle.io/reference/firmware/photon/#cloud-functions)
- [WiFi](https://docs.particle.io/reference/firmware/photon/#wifi)
	- `WiFi.selectAntenna()` is not applicable for Duo
- [SoftAP HTTP Pages](https://docs.particle.io/reference/firmware/photon/#softap-http-pages)
- [Input/Output](https://docs.particle.io/reference/firmware/photon/#input-output)
- [Low Level Input/Output](https://docs.particle.io/reference/firmware/photon/#low-level-input-output)
- [Advanced I/O](https://docs.particle.io/reference/firmware/photon/#advanced-i-o)
- [Serial](https://docs.particle.io/reference/firmware/photon/#serial)
	- Differing from the Photon, the USART2 on the Duo is layed out to the side pins and the `Serial2` object is constructed in the system firmware, so that you can directly call the member functions of `Serial2` without including extra header files.
- [Mouse](https://docs.particle.io/reference/firmware/photon/#mouse)
- [Keyboard](https://docs.particle.io/reference/firmware/photon/#keyboard)
- [SPI](https://docs.particle.io/reference/firmware/photon/#spi)
- [Wire (I2C)](https://docs.particle.io/reference/firmware/photon/#wire-i2c-)
- [CAN (CANbus)](https://docs.particle.io/reference/firmware/photon/#can-canbus-)
- [IPAddress](https://docs.particle.io/reference/firmware/photon/#ipaddress)
- [TCPServer](https://docs.particle.io/reference/firmware/photon/#tcpserver)
- [TCPClient](https://docs.particle.io/reference/firmware/photon/#tcpclient)
- [UDP](https://docs.particle.io/reference/firmware/photon/#udp)
- [Servo](https://docs.particle.io/reference/firmware/photon/#servo)
- [RGB](https://docs.particle.io/reference/firmware/photon/#rgb)
- [Time](https://docs.particle.io/reference/firmware/photon/#time)
- [Interrupts](https://docs.particle.io/reference/firmware/photon/#interrupts)
- [Software Timers](https://docs.particle.io/reference/firmware/photon/#software-timers)
- [Application Watchdog](https://docs.particle.io/reference/firmware/photon/#application-watchdog)
- [Math](https://docs.particle.io/reference/firmware/photon/#math)
- [Random Numbers](https://docs.particle.io/reference/firmware/photon/#random-numbers)
- [EEPROM](https://docs.particle.io/reference/firmware/photon/#eeprom)
- [Backup RAM (SRAM)](https://docs.particle.io/reference/firmware/photon/#backup-ram-sram-)
- [Macros](https://docs.particle.io/reference/firmware/photon/#macros)
- [System Events](https://docs.particle.io/reference/firmware/photon/#system-events)
- [System Modes](https://docs.particle.io/reference/firmware/photon/#system-modes)
- [System Thread](https://docs.particle.io/reference/firmware/photon/#system-thread)
- [System Calls](https://docs.particle.io/reference/firmware/photon/#system-calls)
- [System Interrupts](https://docs.particle.io/reference/firmware/photon/#system-interrupts)
- [OTA Updates](https://docs.particle.io/reference/firmware/photon/#ota-updates)
- [String Class](https://docs.particle.io/reference/firmware/photon/#string-class)
- [Stream Class](https://docs.particle.io/reference/firmware/photon/#stream-class)
- [Logging](https://docs.particle.io/reference/firmware/photon/#logging)
- [Other Functions](https://docs.particle.io/reference/firmware/photon/#other-functions)
- [Preprocessor](https://docs.particle.io/reference/firmware/photon/#preprocessor)

### Duo Only Reference

- [BLE Setup](#ble-setup)
- [External SPI Flash](#external-spi-flash)
- [Bluetooth Low Energy (BLE)](#bluetooth-low-energy-ble)

---

#### <span id="ble-setup">BLE Setup</span>

Since system firmware v0.3.0. 

Before v0.3.0, when the Duo enters the Listening Mode, it will broacast as a BLE peripheral for user to configure WiFi credentials etc. 

Since v0.3.0, user now can optionally enable this feature. It is disabled by default. But you can declare it in your application explicitly by adding `BLE_SETUP(DISABLED)`. To enable this feature, you should declare `BLE_SETUP(ENABLED)` in your application. For examples:

	BLE_SETUP(ENABLED);
	
	void setup() {
	}
	
	void loop() {
	}

If enabled, upon the Duo enters then Listening Mode, it will de-initialize and re-initialize the BLE stack, which will definitely break the BLE functionality in your application if implemented. If you prefer the BLE functionality in your application, then disable the BLE setup feature.

| BLE setup             | BLE running in application                           |
|:--------------------- |:----------------------------------------------------:|
| BLE_SETUP(ENABLED)    | Works only if the Duo never enter the Listening mode |
| BLE_SETUP(DISABLED)   | Always works well                                    |

#### <span id="external-spi-flash">External SPI Flash</span> 

The Duo is soldered with an external non-volatile SPI flash, which memory is up to 2MB and every sector is made up of 4K bytes. But only the first 736KB (184 sectors) are available for user use, the rest memory space are reserved for system use, see the [Firmware Architecture Overview](firmware_architecture_overview.md).

Built-in instance **`sFLASH`**.      

[**`eraseSector()`**](#erasesector)      
[**`writeBuffer()`**](#writebuffer)    
[**`readBuffer()`**](#readbuffer)    
[**`selfTest()`**](#selftest)

##### <span id="erasesector">`eraseSector()`</span> 

This method erases a given sector of the external flash. The pass in parameter **`uint32_t SectorAddr`** can be any of the address as long as it is located in the sector, i.e. the sector you are going to erase is (**`SectorAddr >> 12`**). Operation to the reserved sectors makes no effect.
 
	// Erase the sector 18.
	sFLASH.eraseSector(0x12000); 
	    
	// It will also erase the sector 18.
	sFLASH.eraseSector(0x12345);
	
	// Erase the sector 103.
	sFLASH.eraseSector(0x67890);     

##### <span id="writebuffer">`writeBuffer()`</span>   

This method stores a bulk of data to the external flash. The data is stored from a given address and the address grows automatically after one byte is stored. If the address reaches the end address of the available memory, the rest data will be aborted.

It should pass in three parameters:    

* **`const uint8_t *pBuffer`** The buffer that contains the data to be stored.
* **`uint32_t WriteAddr`** The begining address from which to store the data.
* **`uint32_t NumByteToWrite`** The number of bytes to be stored.

*Note: The memory space you are going to store the data must has been well erased before, or the data you read out afterwards might not the same as you wrote.*

	uint8_t buf[256] = { 0x55 };
	    
	// Store first 128 bytes of the buf to external flash from address 0.
	sFLASH.writeBuffer( buf, 0, 128 );

##### <span id="readbuffer">`readBuffer()`</span>

This method reads specified length of data from a given address of the external flash. The reserved memory space can not be read out using this method.

It should pass in three parameters:   

* **`uint8_t *pBuffer`** The buffer that to hold the data being read out.
* **`uint32_t ReadAddr`** The begining address from which to read out the data.
* **`uint32_t NumByteToRead`** The number of bytes you want to read out.    

E.g.,

	uint8_t buf[256];
	
	// Read 128 bytes from address 0 of the external flash to the buf.    
	sFLASH.readBuffer( buf, 0, 128 );

##### <span id="selftest">`selfTest()`</span>

Check if the external flash functions well or not. It returns **0** if success, otherwise return **-1**.

	void setup() {
	  Serial.begin(115200);
	  delay(5000);
	
	  if ( sFLASH.selfTest() == 0 ) {
	    Serial.println("The external SPI flash functions well.");
	  }
	  else {
	    Serial.print("There is something wrong with the external SPI flash!");
	  }
	}
	
	void loop() {
	}

#### <span id="bluetooth-low-energy-ble">Bluetooth Low Energy (BLE)</span> 

**Note: The BLE API names are unstable and may be changed before the first major release of the firmware.**

The Bluetooth Core Specification can be downloaded here: [https://www.bluetooth.com/specifications/adopted-specifications](https://www.bluetooth.com/specifications/adopted-specifications).      
Current version: *Core Version 4.2*

Built-in instance **`ble`**.     

General methods:    
[**`init()`**](#init)    
[**`deInit()`**](#deinit)    
[**`setTimer()`**](#settimer)    
[**`setTimerHandler()`**](#settimerhandler)    
[**`addTimer()`**](#addtimer)     
[**`removeTimer()`**](#removetimer)    
[**`getTimeMs()`**](#gettimems)    
[**`debugLogger()`**](#debuglogger)    
[**`debugError()`**](#debugerror)    
[**`enablePacketLogger()`**](#enablepacketlogger)    
[**`setPublicBDAddr()`**](#setpublicbdaddr)        

#### Generic Access Profile (GAP) 

[**`setRandomAddrMode()`**](#setrandomaddrmode)    
[**`setRandomAddr()`**](#setrandomaddr)    
[**`getLocalBdAddr()`**](#getlocalbdaddr)    
[**`disconnect()`**](#disconnect)     
[**`onConnectedCallback()`**](#onconnectedcallback)    
[**`onDisconnectedCallback()`**](#ondisconnectedcallback)    

BLE Central:    
[**`setScanParams()`**](#setscanparams)    
[**`setConnParamsRange()`**](#setconnparamsrange)    
[**`updateConnParams()`**](#updateconnparams)    
[**`startScanning()`**](#startscanning)    
[**`stopScanning()`**](#stopscanning)       
[**`connect()`**](#connect)    
[**`onScanReportCallback()`**](#onscanreportcallback) 

BLE Peripheral:     
[**`setAdvertisementParams()`**](#setadvertisementparams)    
[**`setAdvertisementData()`**](#setadvertisementdata)    
[**`setScanResponseData()`**](#setscanresponsedata)    
[**`startAdvertising()`**](#startadvertising)    
[**`stopAdvertising()`**](#stopadvertising)    
[**`requestConnParamsUpdate()`**](#requestconnparamsupdate)    

#### Generic Attribute Profile (GATT)

GATT Client:    
[**`discoverPrimaryServices()`**](#discoverprimaryservices)    
[**`discoverCharacteristics()`**](#discovercharacteristics)    
[**`discoverCharacteristicDescriptors()`**](#discovercharacteristicdescriptors)    
[**`readValue()`**](#readvalue)    
[**`writeValueWithoutResponse()`**](#writevaluewithoutresponse)    
[**`writeValue()`**](#writevalue)     
[**`readDescriptorValue()`**](#readdescriptorvalue)     
[**`writeDescriptorValue()`**](#writedescriptorvalue)      
[**`writeClientCharsConfigDescriptor()`**](#writeclientcharsconfigdescriptor)       
[**`onServiceDiscoveredCallback()`**](#onservicediscoveredcallback)    
[**`onCharacteristicDiscoveredCallback()`**](#oncharacteristicdiscoveredcallback)    
[**`onDescriptorDiscoveredCallback()`**](#ondescriptordiscoveredcallback)    
[**`onGattCharacteristicReadCallback()`**](#ongattcharacteristicreadcallback)    
[**`onGattCharacteristicWrittenCallback()`**](#ongattcharacteristicwrittencallback)    
[**`onGattDescriptorReadCallback()`**](#ongattdescriptorreadcallback)    
[**`onGattDescriptorWrittenCallback()`**](#ongattdescriptorwrittencallback)    
[**`onGattWriteClientCharacteristicConfigCallback()`**](#ongattwriteclientcharacteristicconfigcallback)    
[**`onGattNotifyUpdateCallback()`**](#ongattnotifyupdatecallback)    
[**`onGattIndicateUpdateCallback()`**](#ongattindicateupdatecallback)  

GATT Server:    
[**`addService()`**](#addservice)    
[**`addCharacteristic()`**](#addcharacteristic)     
[**`addCharacteristicDynamic()`**](#addcharacteristicdynamic)    
[**`attServerCanSendPacket()`**](#attservercansendpacket)    
[**`sendNotify()`**](#sendnotify)    
[**`sendIndicate()`**](#sendindicate)    
[**`onDataReadCallback()`**](#ondatareadcallback)    
[**`onDataWriteCallback()`**](#ondatawritecallback)    

##### <span id="init">`init()`</span> 

Enables the HCI interface between Host and Controller, as well as initialize the Controller to the default state. It will create a thread to deal with the HCI commands and events. It **MUST** be called before calling any other GAP and GATT methods.

	// Initialize BLE HCI interface and the controller
	ble.init();

##### <span id="deinit">`deInit()`</span> 

Disables the BLE HCI interface and reset the controller. It will destroy the thread created by **`ble.init()`**. 

	// Disable the BLE functionality
	ble.deInit();

##### <span id="settimer">`setTimer()`</span> 

Sets the timeout of a timer that is running under BTStack. It takes two parameters: **`btstack_timer_source_t`** variable and the timeout value in milliseconds.

	// Create an one-shot BTStack timer
	btstack_timer_source_t bt_timer;
	
	// Set the timeout to 10s
	ble.setTimer(&bt_timer, 10000);

##### <span id="settimerhandler">`setTimerHandler()`</span> 

Registers a function to be called when the BTStack timer fired. The callback function takes one parameter **`btstack_timer_source_t`** showing which timer calls the function.

	// Create a BTStack timer
	btstack_timer_source_t bt_timer;
	
	// BTStack timer callback function
	void btTimerCB(btstack_timer_source_t *ts) {
	
	}
	
	// Set the callback function for the timer
	ble.setTimerHandler(&bt_timer, btTimerCB);

You can also set the callback function directly: 

	bt_timer.process = btTimerCB;

##### <span id="addtimer">`addTimer()`</span> 

Starts the created BTStack timer. The timer you are going to start is passed in as the only parameter.

	btstack_timer_source_t bt_timer;
	
	// Callback function when the BTStack timer expired
	void characteristic_notify(btstack_timer_source_t *ts) {
	  // Notify the characteristic value to BLE central.
	
	  // Restart timer to send the next notification after 10s.
	  ble.setTimer(ts, 10000);
	  ble.addTimer(ts);
	}
	
	// Set an 10s one-shot timer
	bt_timer.process = characteristic_notify;
	ble.setTimer(&bt_timer, 10000);
	ble.addTimer(&bt_timer);

##### <span id="removetimer">`removeTimer()`</span> 

Removes a BTStack timer. The only parameter is the timer you are going to remove.

	// Remove a created BTStack timer
	ble.removeTimer(&bt_timer);

##### <span id="gettimerms">`getTimeMs()`</span> 

Checks how long the device has been running after power on. It returns an **`uint32_t`** value in millisecond.

	uint32_t ms = ble.getTimerMs();

##### <span id="debuglogger">`debugLogger()`</span> 

Enables or disables printing the BTStack **DEBUG** level message via the device's native USB port.

	// Enable printing debug level message
	ble.debugLogger(true);
	
	// Disable printing debug level message
	ble.debuglogger(false);

##### <span id="debugerror">`debugError()`</span> 

Enables or disables printing the BTStack **ERROR** level message via the device's native USB port.

	// Enable printing error level message
	ble.debugError(true);
	
	// Disable printing error level message
	ble.debugError(false);

##### <span id="enablepacketlogger">`enablePacketLogger()`</span>

Enables printing the raw data of all kinds of the BTStack packets via the device's native USB port.

	// Enable printing the raw data of the BTStack packets
	ble.enablePacketLogger();

##### <span id="setrandomaddrmode">`setRandomAddrMode()`</span>

Sets the bluetooth random device address type. See Bluetooth Core Specification **[Vol 6] Part B, Section 1.3.2**.

The parameter of this function should be one of the following value:

* **`GAP_RANDOM_ADDRESS_TYPE_OFF`**
* **`GAP_RANDOM_ADDRESS_NON_RESOLVABLE`**
* **`GAP_RANDOM_ADDRESS_RESOLVABLE`**

If you want to use a random device address, you should set the random device address manually using **`ble.setRandomAddr()`**. 

	// Do not use random device address
	ble.setRandomAddrMode(GAP_RANDOM_ADDRESS_TYPE_OFF);
	
	// Use random non-resolvable device address
	ble.setRandomAddrMode(GAP_RANDOM_ADDRESS_NON_RESOLVABLE);
	
	// Use random resolvable device address
	ble.setRandomAddrMode(GAP_RANDOM_ADDRESS_RESOLVABLE);

##### <span id="setrandomaddr">`setRandomAddr()`</span>

Sets the bluetooth random device address. The 48-bits random device address should meet some requirements and should be generated in particular procedure, see Bluetooth Core Specification **[Vol 6] Part B, Section 1.3.2**.

The Bluetooth device address is a **`bd_addr_t`** variable. The definition of **`bd_addr_t`** is: 

**`typedef uint8_t bd_addr_t[BD_ADDR_LEN];`**

	bd_addr_t random_addr;
	
	// Procedure to generate the random device address
	
	ble.setRandomAddr(random_addr);

##### <span id="setpublicbdaddr">`setPublicBDAddr()`</span>

Sets the bluetooth public device address. The 48-bits public device address made up of 24-bits least significant company_assigned and 24-bits most significant company_id. See Bluetooth Core Specification **[Vol 6] Part B, Section 1.3.1**.

	bd_addr_t public_addr;
	
	// Procedure to generate the public device address
	
	ble.setRandomAddr(public_addr);

##### <span id="getlocalbdaddr">`getLocalBdAddr()`</span>

Fetches the device own bluetooth MAC address.

	bd_addr_t mac_addr;
	
	ble.getLocalBdAddr(mac_addr);

##### <span id="setscanparams">`setScanParams()`</span>

Sets the BLE scan parameters. See Bluetooth Core Specification **[Vol 2] Part E, Section 7.8.10**.

This function takes the following three parameters:

* ***LE\_Scan\_Type***:
    - 0x00: Passive scanning, no scan request packets shall be sent.(default)
    - 0x01: Active scanning, scan request packets may be sent.
    - 0x02 - 0xFF: Reserved for future use.
* ***LE\_Scan\_Interval***: This is defined as the time interval from when the Controller started its last LE scan until it begins the subsequent LE scan.
    - Range: 0x0004 to 0x4000
    - Default: 0x0010 (10 ms)
    - Time = N * 0.625 msec
    - Time Range: 2.5 msec to 10.24 seconds
* ***LE\_Scan\_Window***: The duration of the LE scan. The scan window shall be less than or equal to the scan interval.
    - Range: 0x0004 to 0x4000
    - Default: 0x0010 (10 ms)
    - Time = N * 0.625 msec
    - Time Range: 2.5 msec to 10240 msec

E.g.,

	#define BLE_SCAN_TYPE        0x00   // Passive scanning
	#define BLE_SCAN_INTERVAL    0x0060 // 60 ms
	#define BLE_SCAN_WINDOW      0x0030 // 30 ms
	
	void setup() {
	  ble.init();
	
	  // Set scan parameters.
	  ble.setScanParams(BLE_SCAN_TYPE, BLE_SCAN_INTERVAL, BLE_SCAN_WINDOW);
	}

##### <span id="startscanning">`startScanning()`</span>

Starts scanning the BLE devices that is advertising around the scanner. Once the function executed, it will keep scanning until you call the [**`ble.stopScanning()`**](#stopscannig) function to terminate the operation. The scan result will be handled in a callback function that is registered by [**`ble.onscanreportcallback()`**](#onscanreportcallback).

	// Start scanning BLE devices
	ble.startScanning();

##### <span id="onscanreportcallback">`onScanReportCallback()`</span>

Registers a function to be called when there is a new advertising packet or scan response packet from peer device is received.

The callback function takes a single **`advertisementReport_t`** parameter and returns nothing, e.g. **`void reportCallback(advertisementReport_t *report)`**. 

The **`advertisementReport_t`** is defined as:

	typedef struct{
      uint8_t   peerAddrType;
      bd_addr_t peerAddr;
      int       rssi;
      uint8_t   advEventType;
      uint8_t   advDataLen;
      uint8_t   advData[31];
	} advertisementReport_t;

The **`peerAddrType`** should be one of the following value:

* **`BD_ADDR_TYPE_LE_PUBLIC`**
* **`BD_ADDR_TYPE_LE_RANDOM`**

The **`advEventType`** should be one of the following value:

* **`0x00`**: Connectable undirected advertising
* **`0x01`**: Connectable directed advertising
* **`0x02`**: Scannable undirected advertising
* **`0x03`**: Non connectable undirected advertising
* **`0x04`**: Scan Response

For example:

	static void bleScanCallback(advertisementReport_t *report) {
	  uint8_t index;
	
	  Serial.println("BLE scan callback: ");
	
	  Serial.print("Advertising event type: ");
	  Serial.println(report->advEventType, HEX);
	
	  Serial.print("Peer device address type: ");
	  Serial.println(report->peerAddrType, HEX);
	
	  Serial.print("Peer device address: ");
	  for (index = 0; index < 6; index++) {
	    Serial.print(report->peerAddr[index], HEX);
	    Serial.print(" ");
	  }
	  Serial.println(" ");
	
	  Serial.print("RSSI: ");
	  Serial.println(report->rssi, DEC);
	
	  Serial.print("Advertising/Scan response data packet: ");
	  for (index = 0; index < report->advDataLen; index++) {
	    Serial.print(report->advData[index], HEX);
	    Serial.print(" ");
	  }
	  Serial.println(" ");
	  Serial.println(" ");
	}

	void setup() {
	  Serial.begin(115200);
	  delay(5000);
	
	  ble.init();
	    
	  // Register callback functions.
	  ble.onScanReportCallback(bleScanCallback);
	
	  // Set scan parameters.
	  ble.setScanParams(0, 0x0030, 0x0030);
	
	  // Start scanning.
	  ble.startScanning();
	}

##### <span id="stopscanning">`stopScanning()`</span>

Stops scanning BLE devices around the scanner.

	// Stop scanning BLE devices
	ble.stopScanning();

##### <span id="connect">`connect()`</span>

Initiates establishing the connection to a peer device. It takes two parameters: the peer device address and the peer device address type. The value of both parameters can be obtained by parsing the peer device's advertising packet in the BLE scan callback function.

A callback function registered by [**`ble.onConnectedCallback()`**](#onconnectedcallback) will be called once the connection establishment procedure completed.

	static void bleScanCallback(advertisementReport_t *report) {
	  ble.stopScanning();
	
	  ble.connect(report->peerAddr, report->peerAddrType);
	}
	
	void setup() {
	  Serial.begin(115200);
	  delay(5000);
	
	  ble.init();
	    
	  // Register callback functions.
	  ble.onScanReportCallback(bleScanCallback);
	
	  // Set scan parameters.
	  ble.setScanParams(0, 0x0030, 0x0030);
	
	  // Start scanning.
	  ble.startScanning();
	}

##### <span id="onconnectedcallback">`onConnectedCallback()`</span>

Registers a function to be called when the procedure that establishing connection to a peer device completed. 

The callback function should take two parameters and returns nothing. One of the parameters **`BLEStatus_t`** reflects the connection status, it should be either of the following value:

* **`BLE_STATUS_CONNECTION_ERROR`**
* **`BLE_STATUS_OK`**

The another parameter is an **`uint16_t`** handle assigned for the connection if established successfully. An invalid connection handle should be **0xFFFF**. E.g. **`void deviceConnectedCallback(BLEStatus_t status, uint16_t handle)`**

User should keep the connection handle in case of used for further opertions to the peer device.

    static uint16_t conn_handle = 0xFFFF;

	static void deviceConnectedCallback(BLEStatus_t status, uint16_t handle) {
	  switch (status) {
	    case BLE_STATUS_OK:
	      Serial.print("BLE device connection established! Connection handle: ");
	      Serial.println(handle, HEX);
          conn_handle = handle;
	      break;
	    default: 
	      Serial.println("Failed to establish connection with peer device!");
	      break;
	  }
	}
	
	void setup() {
	  Serial.begin(115200);
	
	  ble.init();
	  ble.onConnectedCallback(deviceConnectedCallback);
	
	  // Other initialization functions
	}

##### <span id="disconnect">`disconnect()`</span>

Disconnects from the peer device. It takes a single parameter - the connection handle that is assigned when connection established before.

A callback function registered by [**`ble.onDisconnectedCallback()`**](#ondisconnectedcallback) will be called once the connection disconnected.

	static uint16_t conn_handle; // Can be obtained in the connected callback function

	ble.disconnect(conn_handle);

##### <span id="ondisconnectedcallback">`onDisconnectedCallback()`</span>

Registers a function to be called when device disconnects from peer device. 

The callback function takes a single **`uint16_t`**parameter and returns nothing. The parameter is the connection handle indicating which connection has been disconnected. E.g. **`void deviceDisconnectedCallback(uint16_t handle)`**.

	static uint16_t conn_handle = 0xFFFF;

	static void deviceDisconnectedCallback(uint16_t handle) {
	  Serial.print("Disconnected from peer BLE device. Connection handle: ");
	  Serial.println(handle, HEX);
	  conn_handle = 0xFFFF;
	}
	
	void setup() {
	  Serial.begin(115200);
	
	  ble.init();
	  ble.onDisconnectedCallback(deviceDisconnectedCallback);
	
	  // Other initialization functions
	}

##### <span id="discoverprimaryservices">`discoverPrimaryServices()`</span>

Discovers the primary services on the peer device GATT server. Only if the peer device is connected then you can discover its primary services. 

A callback function registered by [**`ble.onServiceDiscoveredCallback()`**](#onservicediscoveredcallback) will be called once a primary service on the GATT server being discovered.

The connection handle should be passed in as the essential parameter. Other parameters determine the way you discovering primary services. It returns an **`uint8_t`** value which indicates the result of the discovery operation - **0** for success, others for failure.

	static uint16_t conn_handle; // Can be obtained in the connected callback function
	static uint16_t service_uuid_16 = 0x1234;
	static const uin8_t service_uuid_128[16] = {0x12, 0x34, ..., 0xEE, 0xFF};

	// Discovers all primary services on the GATT server
	ble.discoverPrimaryServices(conn_handle);

	// Discovers only the primary service which UUID matches the given 16-bits service UUID
	ble.discoverPrimaryServices(conn_handle, service_uuid_16);

	// Discovers only the primary service which UUID matches the given 128-bits service UUID
	ble.discoverPrimaryServices(conn_handle, service_uuid_128);

##### <span id="onservicediscoveredcallback">`onServiceDiscoveredCallback()`</span>

Registers a function to be called when a new service being discovered.

The callback function takes three parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`service`**: the discovered service which type is **`gatt_client_service_t`**:

		typedef struct {
		    uint16_t start_group_handle;
		    uint16_t end_group_handle;
		    uint16_t uuid16;
		    uint8_t  uuid128[16];
		} gatt_client_service_t;

E.g. **`void serviceDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_service_t *service)`**

	static gatt_client_service_t discovered_service;

	static void serviceDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_service_t *service) {
	  if (status == BLE_STATUS_OK) {   // Found a service.
	    discovered_service = *service;
	  }
	  else if (status == BLE_STATUS_DONE) {
	    Serial.println("Discovers service completed");

	    // Discovers other services or start to discover characteristics under the service.
	  }
	}

	// Registers the callback function
	ble.onServiceDiscoveredCallback(serviceDiscoveredCallback);

##### <span id="discovercharacteristics">`discoverCharacteristics()`</span>

Discovers the characteristics on the peer device GATT server. Only if the peer device is connected and the service discovery procedure (initiated by [**`ble.discoverPrimaryServices()`**](#discoverprimaryservices)) has been completed, then you can discover its characteristics.

A callback function registered by [**`ble.onCharacteristicDiscoveredCallback()`**](#oncharacteristicdiscoveredcallback) will be called once a characteristic on the GATT server being discovered.

The connection handle should be passed in as the essential parameter. Other parameters determine the way you discovering characteristics. It returns an **`uint8_t`** value which indicates the result of the discovery operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The service can be obtained in the service discovered callback function
	static gatt_client_service_t service; 

	// A valid attribute handle should range from 0x0001 to 0xFFFF.
	// The service start/end attribute handle can be obtained in the service discovered callback function
	static uint16_t service_start_handle; 
	static uint16_t service_end_handle;

	static uint16_t char_uuid_16 = 0x1234; 
	static uint8_t char_uuid_128[16] = {0x12, 0x34, ... , 0xEE, 0xFF};

	// Discovers all characteristics under a service
	ble.discoverCharacteristics(conn_handle, &service);

	// Discovers only the characteristic which UUID matches the given 16-bits characteristic UUID
	// and which attribute handle is in the given service attribute handle range as well
	ble.discoverCharacteristics(conn_handle, service_start_handle, service_end_handle, char_uuid_16);
	
	// Discovers only the characteristic which UUID matches the given 128-bits characteristic UUID 
	// and which attribute handle is in the given service attribute handle range as well
	ble.discoverCharacteristics(conn_handle, service_start_handle, service_end_handle, char_uuid_128);
	
	// Discovers only the characteristic which UUID matches the given 16-bits characteristic UUID under the specified service
	ble.discoverCharacteristics(conn_handle, &service, char_uuid_16);
	
	// Discovers only the characteristic which UUID matches the given 128-bits characteristic UUID under the specified service
	ble.discoverCharacteristics(conn_handle, &service, char_uuid_128);

##### <span id="oncharacteristicdiscoveredcallback">`onCharacteristicDiscoveredCallback()`</span>

Registers a function to be called when a new characteristic being discovered.

The callback function takes three parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`characteristic`**: the discovered characteristic which type is **`gatt_client_characteristic_t`**:

		typedef struct {
		    uint16_t start_handle;
		    uint16_t value_handle;
		    uint16_t end_handle;
		    uint16_t properties;
		    uint16_t uuid16;
		    uint8_t  uuid128[16];
		} gatt_client_characteristic_t;

E.g. **`void charsDiscoveredCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_t *characteristic)`**

	static gatt_client_characteristic_t discovered_char;

	static void charsDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_characteristic_t *characteristic) {
	  if (status == BLE_STATUS_OK) {   // Found a characteristic.
	    discovered_char = *characteristic;
	  }
	  else if (status == BLE_STATUS_DONE) {
	    Serial.println("Discovers characteristic completed.");

	    // Discover other characteristics or start to discover descriptors.
	  }
	}

	// Registers the callback function
	ble.onCharacteristicDiscoveredCallback(charsDiscoveredCallback);

##### <span id="discovercharacteristicdescriptors">`discoverCharacteristicDescriptors()`</span>

Discovers the descriptor of the specified characteristic. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can discover its descriptor.

A callback function registered by [**`ble.onDescriptorDiscoveredCallback()`**](#ondescriptordiscoveredcallback) will be called once the descriptor under a characteristic being discovered.

The connection handle should be passed in as the essential parameter. The another parameter is the characteristic, the descriptor of which you are going to discover. It returns an **`uint8_t`** value which indicates the result of the discovery operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic can be obtained in the characteristic discovered callback function
	static gatt_client_characteristic_t characteristic; 

	ble.discoverCharacteristicDescriptors(conn_handle,  &characteristic);

##### <span id="ondescriptordiscoveredcallback">`onDescriptorDiscoveredCallback()`</span>

Registers a function to be called when a new descriptor being discovered.

The callback function takes three parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`descriptor`**: the discovered descriptor which type is **`gatt_client_characteristic_descriptor_t`**:

		typedef struct {
		    uint16_t handle;
		    uint16_t uuid16;
		    uint8_t  uuid128[16];
		} gatt_client_characteristic_descriptor_t;

E.g. **`void discoveredCharsDescriptorsCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_descriptor_t *descriptor)`**

	static gatt_client_characteristic_descriptor_t char_descriptor;

	static void discoveredCharsDescriptorsCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_descriptor_t *descriptor) {
	  if (status == BLE_STATUS_OK) {   // Found a descriptor.
	    char_descriptor = *descriptor;
	  }
	  else if (status == BLE_STATUS_DONE) {
	    // finish.
	    Serial.println("Discovers descriptor completed");
	    
	    // Discover other characteristics' descriptor
	  }
	}

	// Registers the callback function
	ble.onDescriptorDiscoveredCallback(discoveredCharsDescriptorsCallback);

##### <span id="readvalue">`readValue()`</span>

Reads specified characteristic value on peer device. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can read a characteristic value if the characteristic has **READ** property.

A callback function registered by [**`ble.onGattCharacteristicReadCallback()`**](#ongattcharacteristicreadcallback) will be called once the reading value operation completed.

The connection handle should be passed in as the essential parameter. The characteristic which value you are going to read can be specified by other different parameters. It returns an **`uint8_t`** value which indicates the result of the reading operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic can be obtained in the characteristic discovered callback function
	static gatt_client_characteristic_t characteristic;

	// The characteristic value attribute handle can be obtained in the characteristic discovered callback function
	static uint16_t char_value_handle;

	// The characteristic start/end attribute handle can be obtained in the characteristic discovered callback function
	static uint16_t char_start_handle;
	static uint16_t char_end_handle;

	static uint16_t char_uuid_16 = 0x1234; 
	static uint8_t char_uuid_128[16] = {0x12, 0x34, ... , 0xEE, 0xFF};

	// Read according to the characteristic
	ble.readValue(conn_handle, &characteristic);
	
	// Read according to the value attribute handle
	ble.readValue(conn_handle, characteristic_value_handle);
	
	// Read according to the 16-bits characteristic UUID and the characteristic attribute handle range
	ble.readValue(conn_handle, start_handle, end_handle, uuid16);
	
	// Read according to the 128-bits characteristic UUID and the characteristic attribute handle range
	ble.readValue(conn_handle, start_handle, end_handle, *uuid128);

##### <span id="ongattcharacteristicreadcallback">`onGattCharacteristicReadCallback()`</span>

Registers a function to be called when the reading characteristic value operation completed.

The callback function takes five parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`value_handle`**: the characteristic value attribute handle which type is **`uint16_t`**.
* **`value`**: an **`uint8_t`** pointer to the buffer that holds the read back data
* **`length`**: an **`uint16_t`** value indicates the length of the read back data

E.g. **`void gattReadCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReadCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  if (status == BLE_STATUS_OK) {
	    Serial.println(" ");
	    Serial.println("Reads characteristic value successfully");

	    Serial.print("Characteristic value attribute handle: ");
	    Serial.println(value_handle, HEX);
	        
	    Serial.print("Characteristic value : ");
	    for (index = 0; index < length; index++) {
	      Serial.print(value[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");
	  }
	  else if (status != BLE_STATUS_DONE) {
	    Serial.println("Reads characteristic value failed.");
	  }
	}

	// Registers the callback function
	ble.onGattCharacteristicReadCallback(gattReadCallback);

##### <span id="writevaluewithoutresponse">`writeValueWithoutResponse()`</span>

Writes specified characteristic value on peer device without response. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can write a characteristic value if the characteristic has **WRITE\_WITHOUT\_RESPOND** property.

Since this kind of writing operation has no response from peer device, it doesn't ensure that the data is sent to the peer device successfully, but in return, it can send more data in per unit time.

It takes four parameters: the connection handle, the value attribute handle, the data length and the data to be sent. The maximum length of the data is limited to **20** bytes. It returns an **`uint8_t`** value which indicates the result of the writing operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic value attribute handle can be obtained in the characteristic discovered callback function
	static uint16_t char_value_handle;

	static uint8_t data[20] = { ... };

	ble.writeValueWithoutResponse(conn_handle, char_value_handle, 20, data);

##### <span id="writevalue">`writeValue()`</span>

Writes specified characteristic value on peer device with response. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can write a characteristic value if the characteristic has **WRITE** property.

A callback function registered by [**`ble.onGattCharacteristicWrittenCallback()`**](#ongattcharacteristicwrittencallback) will be called once the writing value operation completed.

It takes four parameters: the connection handle, the value attribute handle, the data length and the data to be sent. The maximum length of the data is limited to **20** bytes. It returns an **`uint8_t`** value which indicates the result of the writing operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic value attribute handle can be obtained in the characteristic discovered callback function
	static uint16_t char_value_handle;

	static uint8_t data[20] = { ... };

	ble.writeValue(conn_handle, char_value_handle, 20, data);

##### <span id="ongattcharacteristicwrittencallback">`onGattCharacteristicWrittenCallback()`</span>

Registers a function to be called when the writing characteristic value operation completed.

The callback function takes two parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.

E.g. **`void gattWrittenCallback(BLEStatus_t status, uint16_t conn_handle)`**

	static void gattWrittenCallback(BLEStatus_t status, uint16_t conn_handle) {
	  if (status == BLE_STATUS_DONE) {
	    Serial.println(" ");
	    Serial.println("Writes characteristic value successfully.");
	  }
	}

	// Registers the callback function
	ble.onGattCharacteristicWrittenCallback(gattWrittenCallback);

##### <span id="readdescriptorvalue">`readDescriptorValue()`</span>

Reads specified descriptor value on peer device. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can read a characteristic descriptor if it is presented.

A callback function registered by [**`ble.onGattDescriptorReadCallback()`**](#ongattdescriptorreadcallback) will be called once the reading descriptor operation completed.

The connection handle should be passed in as the essential parameter. The characteristic which descriptor you are going to read can be specified by other different parameters. It returns an **`uint8_t`** value which indicates the result of the reading operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic descriptor can be obtained in the descriptor discovered callback function
	static gatt_client_characteristic_descriptor_t descriptor;

	// The characteristic descriptor attribute handle can be obtained in the descriptor discovered callback function
	static uint16_t char_desc_handle;

	ble.readDescriptorValue(conn_handle, &descriptor);
	
	ble.readDescriptorValue(conn_handle, char_desc_handle);

##### <span id="ongattdescriptorreadcallback">`onGattDescriptorReadCallback()`</span>

Registers a function to be called when the reading descriptor operation completed.

The callback function takes five parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`value_handle`**: the characteristic descriptor attribute handle which type is **`uint16_t`**.
* **`value`**: an **`uint8_t`** pointer to the buffer that holds the read back data
* **`length`**: an **`uint16_t`** value indicates the length of the read back data

E.g. **`void gattReadDescriptorCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReadDescriptorCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  if(status == BLE_STATUS_OK) {
	    Serial.println(" ");
	    Serial.println("Reads descriptor successfully.");

	    Serial.print("Characteristic descriptor attribute handle: ");
	    Serial.println(value_handle, HEX);

	    Serial.print("Characteristic descriptor: ");
	    for (index = 0; index < length; index++) {
	      Serial.print(value[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");
	  }
	}

	// Registers the callback function
	ble.onGattDescriptorReadCallback(gattReadDescriptorCallback);

##### <span id="writedescriptorvalue">`writeDescriptorValue()`</span>

Writes specified characteristic descriptor value on peer device. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can write a characteristic descriptor if it is presented.

A callback function registered by [**`ble.onGattDescriptorWrittenCallback()`**](#ongattdescriptorwrittencallback) will be called once the writing descriptor operation completed.

The connection handle should be passed in as the essential parameter. The rest three parameters are: the descriptor or descriptor attribute handle, the data length and the data to be sent. The maximum length of the data is limited to **20** bytes. It returns an **`uint8_t`** value which indicates the result of the writing operation - **0** for success, others for failure.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle; 

	// The characteristic descriptor can be obtained in the descriptor discovered callback function
	static gatt_client_characteristic_descriptor_t descriptor;

	// The characteristic descriptor attribute handle can be obtained in the descriptor discovered callback function
	static uint16_t char_desc_handle;

	static uint8_t data[20] = { ... };

	ble.writeDescriptorValue(conn_handle, &descriptor, 20, data);
	
	ble.writeDescriptorValue(conn_handle, char_desc_handle, 20, data);

##### <span id="ongattdescriptorwrittencallback">`onGattDescriptorWrittenCallback()`</span>

Registers a function to be called when the writing descriptor operation completed.

The callback function takes two parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.

E.g. **`void gattWriteDescriptorCallback(BLEStatus_t status, uint16_t conn_handle)`**

	static void gattWriteDescriptorCallback(BLEStatus_t status, uint16_t conn_handle) {
	  if (status == BLE_STATUS_DONE) {
	    Serial.println(" ");
	    Serial.println("Writes characteristic descriptor successfully.");
	  }
	}

	// Registers the callback function
	ble.onGattDescriptorWrittenCallback(gattWriteDescriptorCallback);

##### <span id="writeclientcharsconfigdescriptor">`writeClientCharsConfigDescriptor()`</span>

Write specified characteristic's Client Characteristic Configuration Descriptor (CCCD) value on peer device to subscribe/unsubscribe its notification/indication. Only if the peer device is connected and the characteristic discovery procedure (initiated by [**`ble.discoverCharacteristics()`**](#discovercharacteristics)) has been completed, then you can write a characteristic's CCCD if the characteristic has **NOTIFY** or **INDICATE** property. If you want to receive the notification or indication the characteristic, you have to write its CCCD to subscribe the notification/indication first.

A callback function registered by [**`ble.onGattWriteClientCharacteristicConfigCallback()`**](#ongattwriteclientcharacteristicconfigcallback) will be called once the writing CCCD operation completed.

The connection handle should be passed in as the essential parameter. The second parameter is the characteristic which has NOTIFY or INDICATE property. The third parameter is the CCCD value, which to enable/disable the notification or indication. It should be one of the following value:

* **`GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_NONE`** - Disable notification and indication
* **`GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_NOTIFICATION`** - Enable notification
* **`GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_INDICATION`** - Enable indication

If the peer device characteristic has the **NOTIFY** property, then you should use **`GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_NOTIFICATION`** to subscribe notification, which means that the local device should NOT send reponse to peer device after receiving a notification. If the peer device characteristic has the **INDICATE** property, then you should use **`GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_INDICATION`** to subscribe indication, which means that the local device should send a reponse to peer device after receiving an indication.

	// The connection handle can be obtained in the connected callback function
	static uint16_t conn_handle;

	// The characteristic can be obtained in the characteristic discovered callback function
	static gatt_client_characteristic_t characteristic; 

	// Disable the characteristic notification and indication
	writeClientCharsConfigDescritpor(conn_handle, &characteristic, GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_NONE);

	// Enable the characteristic notification
	writeClientCharsConfigDescritpor(conn_handle, &characteristic, GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_NOTIFICATION);

	// Enable the characteristic indication
	writeClientCharsConfigDescritpor(conn_handle, &characteristic, GATT_CLIENT_CHARACTERISTICS_CONFIGURATION_INDICATION);

##### <span id="ongattwriteclientcharacteristicconfigcallback">`onGattWriteClientCharacteristicConfigCallback()`</span>

Registers a function to be called when the writing Client Characteristic Configration Descriptor (CCCD) operation completed.

The callback function takes two parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.

E.g. **`void gattWriteCCCDCallback(BLEStatus_t status, uint16_t conn_handle)`**

	static void gattWriteCCCDCallback(BLEStatus_t status, uint16_t conn_handle) {
	  if (status == BLE_STATUS_DONE) {
	    Serial.println("Writes characteristic CCCD successfully.");
	  }
	}

	// Registers the callback function
	ble.onGattWriteClientCharacteristicConfigCallback(gattWriteCCCDCallback);

##### <span id="ongattnotifyupdatecallback">`onGattNotifyUpdateCallback()`</span>

Registers a function to be called when the local device received a notification from peer device.

The callback function takes five parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`value_handle`**: the characteristic value attribute handle which type is **`uint16_t`**.
* **`value`**: an **`uint8_t`** pointer to the buffer that holds the notified data
* **`length`**: an **`uint16_t`** value indicates the length of the notified data

E.g. **`void gattNotifyUpdateCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReceivedNotificationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  Serial.println(" ");
	  Serial.println("Received new notification:");

	  Serial.print("Characteristic value attribute handle: ");
	  Serial.println(value_handle, HEX);

	  Serial.print("Notified data: ");
	  for (index = 0; index < length; index++) {
	    Serial.print(value[index], HEX);
	    Serial.print(" ");
	  }
	  Serial.println(" ");
	}

	// Registers the callback function
	ble.onGattNotifyUpdateCallback(gattReceivedNotificationCallback);

##### <span id="ongattindicateupdatecallback">`onGattIndicateUpdateCallback()`</span>

Registers a function to be called when the local device received an indication from peer device.

The callback function takes five parameters and returns nothing:

* **`status`**: the operation status which type is **`BLEStatus_t`**. It should be one of the following value:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`conn_handle`**: the connection handle which type is **`uint16_t`**.
* **`value_handle`**: the characteristic descriptor attribute handle which type is **`uint16_t`**.
* **`value`**: an **`uint8_t`** pointer to the buffer that holds the indicated data
* **`length`**: an **`uint16_t`** value indicates the length of the indicated data

E.g. **`void gattReceivedIndicationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReceivedIndicationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  Serial.println(" ");
	  Serial.println("Receive new indication:");

	  Serial.print("Characteristic value attribute handle: ");
	  Serial.println(value_handle, HEX);

	  Serial.print("Indicated data: ");
	  for (index = 0; index < length; index++) {
	    Serial.print(value[index], HEX);
	    Serial.print(" ");
	  }
	  Serial.println(" ");
	}

	// Registers the callback function
	ble.onGattIndicateUpdateCallback(gattReceivedIndicationCallback);

##### <span id="addservice">`addService()`</span>

Adds a BLE service to the GATT server, the UUID of which can be either 16-bits or 128 bits. It takes a single parameter (the service UUID) and returns nothing. The following added characteristics belong to this service until a new service is added.

	static uint16_t service1_uuid = 0x1234;
	static uint8_t service2_uuid[16] = {0x12, 0x34, ... , 0xFF};
	
	void setup() {
	  ble.init();
	
	  ble.addService(service1_uuid);
	
	  // The following added characteristics belong to the BLE service1
	
	  ble.addService(service2_uuid);
	
	  // The following added characteristics belong to the BLE service2
	}

##### <span id="addcharacteristic">`addCharacteristic()`</span>

Adds a characteristic to the GATT server, the value of which should NOT be changed by GATT client. It takes four parameters:

* **`uuid`**: either a 16-bits UUID or 128-bits UUID.
* **`flags`**: the characteristic property which should be the combination of the following value:
    - **`ATT_PROPERTY_BROADCAST`**
    - **`ATT_PROPERTY_READ`**
    - **`ATT_PROPERTY_WRITE_WITHOUT_RESPONSE`**
    - **`ATT_PROPERTY_WRITE`**
    - **`ATT_PROPERTY_NOTIFY`**
    - **`ATT_PROPERTY_INDICATE`**
    - **`ATT_PROPERTY_AUTHENTICATED_SIGNED_WRITE`**
    - **`ATT_PROPERTY_EXTENDED_PROPERTIES`**
* **`data`**: an **`uint8_t`** pointer to the characteristic value
* **`data_len`**: the maximum length of the characteristic value.

It returns an **`uint16_t`** value which is the characteristic value attribute handle. The added characteristic will belong to the latest added service.

	static uint16_t service1_uuid = 0x1234;
	static uint8_t service2_uuid[16] = {0x12, 0x34, ... , 0xFF};
	static uint16_t char1_uuid = 0x5678;
	static uint8_t char2_uuid[16] = {0x11, 0x22, ..., 0xFF};

	static uint8_t char1_value[20];
	static uint16_t char1_handle;
	static uint8_t char2_value[20];
	static uint16_t char2_handle;
	
	void setup() {
	  ble.init();
	
	  ble.addService(service1_uuid);
	
	  // The following added characteristics belong to the BLE service1
	  char1_handle = ble.addCharacteristic(char1_uuid, ATT_PROPERTY_READ, char1_value, sizeof(char1_value));
	
	  ble.addService(service2_uuid);
	
	  // The following added characteristics belong to the BLE service2
	  char2_handle = ble.addCharacteristic(char2_uuid, ATT_PROPERTY_READ, char2_value, sizeof(char2_value))
	}

##### <span id="addcharacteristicdynamic">`addCharacteristicDynamic()`</span>

Adds a general characteristic to the GATT server, the value of which can be changed by GATT client. The parameters and return value are the same as [**`addCharacteristic()`**](#addcharacteristic). The added characteristic will belong to the latest added service.

##### <span id="setconnparamsrange">`setConnParamsRange()`</span>

Sets the connection parameters range. It takes a single parameter which type is **`le_connection_parameter_range_t`**:

	typedef struct le_connection_parameter_range{
	    uint16_t le_conn_interval_min;
	    uint16_t le_conn_interval_max;
	    uint16_t le_conn_latency_min;
	    uint16_t le_conn_latency_max;
	    uint16_t le_supervision_timeout_min;
	    uint16_t le_supervision_timeout_max;
	} le_connection_parameter_range_t;

##### <span id="updateconnparams">`updateConnParams()`</span>

Updates the connection parameters. It takes five parameters: which type is **`le_connection_parameter_range_t`**:

* **`conn_handle`**: the connection handle.
* **`conn_interval_min`**: an **`uint16_t`** value indicates the targte minimum connection interval.
* **`conn_interval_max`**: an **`uint16_t`** value indicates the target maximum connection interval.
* **`latency`**: an **`uint16_t`** value indicates slave latency.
* **`supervision_timeout`**: an **`uint16_t`** value indicates connection supervision timeout.

Note that the actual BLE connection parameters are:

- Minimum connection interval = `conn_interval_min` * 1.25 ms, where `conn_interval_min` ranges from 0x0006 to 0x0C80
- Maximum connection interval = `conn_interval_max` * 1.25 ms,  where `conn_interval_max` ranges from 0x0006 to 0x0C80
- The `latency ranges` from 0x0000 to 0x03E8
- Connection supervision timeout = `supervision_timeout` * 10 ms, where `supervision_timeout` ranges from 0x000A to 0x0C80

##### <span id="requestconnparamsupdate">`requestConnParamsUpdate()`</span>

Requests a update of the connection parameters. It takes five parameters: which type is **`le_connection_parameter_range_t`**:

* **`conn_handle`**: the connection handle.
* **`conn_interval_min`**: an **`uint16_t`** value indicates the targte minimum connection interval.
* **`conn_interval_max`**: an **`uint16_t`** value indicates the target maximum connection interval.
* **`latency`**: an **`uint16_t`** value indicates slave latency.
* **`supervision_timeout`**: an **`uint16_t`** value indicates connection supervision timeout.

Note that the actual request BLE connection parameters are:

- Minimum connection interval = `conn_interval_min` * 1.25 ms, where `conn_interval_min` ranges from 0x0006 to 0x0C80
- Maximum connection interval = `conn_interval_max` * 1.25 ms,  where `conn_interval_max` ranges from 0x0006 to 0x0C80
- The `latency ranges` from 0x0000 to 0x03E8
- Connection supervision timeout = `supervision_timeout` * 10 ms, where `supervision_timeout` ranges from 0x000A to 0x0C80

##### <span id="setadvertisementparams">`setAdvertisementParams()`</span>

Sets the peripheral advertising parameters:

* **Minimum advertising interval**: ranges from 0x0020 to 0x4000, default is 0x0800, unit: 0.625 msec
* **Maximum advertising_interval**: ranges from 0x0020 to 0x4000, default: is0x0800, unit: 0.625 msec
* **Advertising event type**: 
    - **`BLE_GAP_ADV_TYPE_ADV_IND`** 
    - **`BLE_GAP_ADV_TYPE_ADV_DIRECT_IND`**
    - **`BLE_GAP_ADV_TYPE_ADV_SCAN_IND`**
    - **`BLE_GAP_ADV_TYPE_ADV_NONCONN_IND`**
* **Own device address type**: 
    - **`BLE_GAP_ADDR_TYPE_PUBLIC`**
    - **`BLE_GAP_ADDR_TYPE_RANDOM`**
* **Advertising channel map**: 
    - **`BLE_GAP_ADV_CHANNEL_MAP_37`**
    - **`BLE_GAP_ADV_CHANNEL_MAP_38`**
    - **`BLE_GAP_ADV_CHANNEL_MAP_39`**
    - **`BLE_GAP_ADV_CHANNEL_MAP_ALL`**
* **Filter policies**: 
    - **`BLE_GAP_ADV_FP_ANY`**
    - **`BLE_GAP_ADV_FP_FILTER_SCANREQ`**
    - **`BLE_GAP_ADV_FP_FILTER_CONNREQ`**
    - **`BLE_GAP_ADV_FP_FILTER_BOTH`**
  
Note: If the **Advertising event type** is set to **`BLE_GAP_ADV_TYPE_ADV_SCAN_IND`** or **`BLE_GAP_ADV_TYPE_ADV_NONCONN_IND`**, then the **Minimum advertising interval** and **Maximum advertising_interval** should not be set to less than 0x00A0.

	// BLE peripheral advertising parameters
	static advParams_t adv_params = {
	  .adv_int_min   = 0x0030,
	  .adv_int_max   = 0x0030,
	  .adv_type      = BLE_GAP_ADV_TYPE_ADV_IND,
	  .dir_addr_type = BLE_GAP_ADDR_TYPE_PUBLIC,
	  .dir_addr      = {0,0,0,0,0,0},
	  .channel_map   = BLE_GAP_ADV_CHANNEL_MAP_ALL,
	  .filter_policy = BLE_GAP_ADV_FP_ANY
	};
	
	void setup() {
	  ble.init();
	
	  // Set BLE advertising parameters
	  ble.setAdvertisementParams(&adv_params);
	}

##### <span id="setadvertisementdata">`setAdvertisementData()`</span>

Sets the peripheral advertising data. The advertising data is essential and is limited to **31** bytes and must follow the format as defined in Bluetooth Core Specification **[Vol 3] Part C, Section 11**. Usually a unit in the advertising data is made up of "length + AD type + AD data". Regarding to BLE devices, the AD type of the first unit must be **`BLE_GAP_AD_TYPE_FLAGS`** and the followed AD data should be **`BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE`**:

	// BLE peripheral advertising data
	static uint8_t adv_data[] = {
	  0x02,
	  BLE_GAP_AD_TYPE_FLAGS,
	  BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE,   
	  
	  0x11,
	  BLE_GAP_AD_TYPE_128BIT_SERVICE_UUID_COMPLETE,
	  0x1e, 0x94, 0x8d, 0xf1, 0x48, 0x31, 0x94, 0xba, 0x75, 0x4c, 0x3e, 0x50, 0x00, 0x00, 0x3d, 0x71 
	};

	void setup() {
	  ble.init();
	
	  // Set BLE advertising and scan respond data
	  ble.setAdvertisementData(sizeof(adv_data), adv_data);
	}

##### <span id="setscanresponsedata">`setScanResponseData()`</span>

Sets the peripheral scan response data. The scan response data is optional and is limited to **31** bytes and must follow the format as defined in Bluetooth Core Specification **[Vol 3] Part C, Section 11**. Usually a unit in the scan response data is made up of "length + AD type + AD data".

	// BLE peripheral scan response data
	static uint8_t scan_response[] = {
	  0x08,
	  BLE_GAP_AD_TYPE_COMPLETE_LOCAL_NAME,
	  'R', 'B',  'L', '-', 'D', 'U', 'O'
	};

	void setup() {
	  ble.init();
	
	  // Set BLE advertising and scan respond data
	  ble.setAdvertisementData(sizeof(adv_data), adv_data);
	}

##### <span id="startadvertising">`startAdvertising()`</span>

Starts advertising to make the device discoverable to BLE scanners. Before calling this function, you need to set the advertising data by calling [**`ble.setAdvertisementData()`**](#setadvertisementdata) first.

	// BLE peripheral advertising data
	static uint8_t adv_data[] = {
	  0x02,
	  BLE_GAP_AD_TYPE_FLAGS,
	  BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE,   
	  
	  0x11,
	  BLE_GAP_AD_TYPE_128BIT_SERVICE_UUID_COMPLETE,
	  0x1e, 0x94, 0x8d, 0xf1, 0x48, 0x31, 0x94, 0xba, 0x75, 0x4c, 0x3e, 0x50, 0x00, 0x00, 0x3d, 0x71 
	};

	void setup() {
	  ble.init();
	
	  // Set BLE advertising and scan respond data
	  ble.setAdvertisementData(sizeof(adv_data), adv_data);

	  // Starts advertising
	  ble.startAdvertising();
	}

##### <span id="stopadvertising">`stopAdvertising()`</span>

Stops advertising. When the device is advertising, you can call this function to stop it so that it is not discoverable to BLE scanners.

	ble.stopAdvertising();

##### <span id="attservercansendpacket">`attServerCanSendPacket()`</span>

Checks if the device can send notification or indication to peer device. Only if the GATT client has subscribed the notification or indication by [**`ble.writeClientCharsConfigDescriptor()`**](#writeClientCharsConfigDescriptor), then you can send it. It returns an **`int`** value indicating if you can send notification or indication.

	// The characteristic value attribute handle can be obtained when you add the characteristic
	static uint16_t char_value_handle;

	static uint8_t data[20];

	if(ble.attServerCanSendPacket()) {
	  ble.sendNotify(char_value_handle, data, sizeof(data));
	}

##### <span id="sendnotify">`sendNotify()`</span>

Notifis the peer device that the characteristic value has been changed. Only if the GATT client has subscribed the notification [**`ble.writeClientCharsConfigDescriptor()`**](#writeClientCharsConfigDescriptor), then you can send it. 

It takes three parameters: the characteristic value attribute handle, the data to be sent and the length of the data. The maximum length of the data is limited to **20** bytes.

	// The characteristic value attribute handle can be obtained when you add the characteristic
	static uint16_t char_value_handle;

	static uint8_t data[20];

	if(ble.attServerCanSendPacket()) {
	  ble.sendNotify(char_value_handle, data, sizeof(data));
	}

##### <span id="sendindicate">`sendIndicate()`</span>

Indicates the peer device that the characteristic value has been changed.  Only if the GATT client has subscribed the indication [**`ble.writeClientCharsConfigDescriptor()`**](#writeClientCharsConfigDescriptor), then you can send it. 

It takes three parameters: the characteristic value attribute handle, the data to be sent and the length of the data. The maximum length of the data is limited to **20** bytes. A reponse from the GATT client is necessary.

	// The characteristic value attribute handle can be obtained when you add the characteristic
	static uint16_t char_value_handle;

	static uint8_t data[20];

	if(ble.attServerCanSendPacket()) {
	  ble.sendIndicate(char_value_handle, data, sizeof(data));
	}
	
##### <span id="ondatareadcallback">`onDataReadCallback()`</span>

Registers a function to be called when a characteristic value is read by peer device.

The callback function takes three parameters and returns an **`uint16_t`** value:

* **`value_handle`**: the attribute handle specifying which attribute being read.
* **`buffer`**: an **`uint8_t`** pointer to the buffer that will be read by peer device.
* **`buffer_size`**: an **`uint16_t`** value indicates the length of the buffer.

E.g. **`uint16_t gattReadCallback(uint16_t value_handle, uint8_t * buffer, uint16_t buffer_size)`**

	// The characteristic value attribute handle can be obtained when you add the characteristic
	static uint16_t char1_handle;
	static uint16_t char2_handle;

	static uint8_t char1_data[20];
	static uint8_t char2_data[20];

	static uint16_t gattReadCallback(uint16_t value_handle, uint8_t * buffer, uint16_t buffer_size) {   
	  uint8_t ret_len = 0;
	
	  Serial.print("Reads attribute value, handle: ");
	  Serial.println(value_handle, HEX);
	
	  if (char1_handle == value_handle) {   // Characteristic value handle.
	    memcpy(buffer, char1_data, sizeof(char1_data));
	    ret_len = sizeof(char1_data);
	  }
	  else if (char2_handle == value_handle) {
	    memcpy(buffer, char2_data, sizeof(char2_data));
	    ret_len = sizeof(char2_data);
	  }

	  return ret_len;
	}

	// Registers the callback function
	ble.onDataReadCallback(gattReadCallback);

##### <span id="ondatawritecallback">`onDataWriteCallback()`</span>

Registers a function to be called when a characteristic value is written by peer device.

The callback function takes three parameters and returns the an **`int`** value:

* **`value_handle`**: the attribute handle specifying which attribute being written.
* **`buffer`**: an **`uint8_t`** pointer to the buffer that holds the data from peer device.
* **`buffer_size`**: an **`uint16_t`** value indicates the length of the data.

E.g. **`int gattWriteCallback(uint16_t value_handle, uint8_t *buffer, uint16_t buffer_size)`**

	// The characteristic value attribute handle can be obtained when you add the characteristic
	static uint16_t char1_handle;
	static uint16_t char2_handle;

	static uint8_t char1_data[20];
	static uint8_t char2_data[20];

	static int gattWriteCallback(uint16_t value_handle, uint8_t *buffer, uint16_t buffer_size) {
	  Serial.print("Write attribute value, handler: ");
	  Serial.println(value_handle, HEX);
	
	  if (char1_handle == value_handle) {
	    memcpy(char1_data, buffer, size);
	    Serial.print("Written value: ");
	    for (uint8_t index = 0; index < buffer_size; index++) {
	      Serial.print(char1_data[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");
	  }
	  else if (character2_handle == value_handle) {
	    memcpy(char2_data, buffer, size);
	    Serial.print("Written value: ");
	    for (uint8_t index = 0; index < buffer_size; index++) {
	      Serial.print(char2_data[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");
	  }

	  return 0;
	}

	// Registers the callback function
	ble.onDataWriteCallback(gattWriteCallback);


## Support

* [RedBear Discussion](http://discuss.redbear.cc)
* [Particle Community](https://community.particle.io)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
