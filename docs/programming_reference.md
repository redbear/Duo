# Duo: Programming Reference
---

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

### Summary

##### Inherit from Particle Reference
- [Input/Output](#inputoutput)
- [Low Level Input/Output](#low-level-inputoutput)
- [Advanced I/O](#advanced-io)
- [Interrupts](#interrupts)
- [Software Timers](#software-timers)
- [Serial](#serial)
- [SPI](#spi)
- [Wire (I2C)](#wire-i2c)
- [CAN (CANbus)](#can-canbus)
- [Servo](#servo)
- [RGB](#rgb)
- [EEPROM Emulation](#eeprom-emulation)
- [Backup RAM (SRAM)](#backup-ram-sram)
- [Application Watchdog](#application-watchdog)
- [Time](#time)
- [Math](#math)
- [Random Numbers](#random-numbers)
- [String](#string)
- [WiFi](#wifi)
- [IPAddress](#ipaddress)
- [TCPServer](#tcpserver)
- [TCPClient](#tcpclient)
- [UDP](#udp)
- [Stream](#stream)
- [SoftAP HTTP Pages](#softap-http-pages)
- [Cloud Functions](#cloud-functions)
- [System Calls](#system-calls)
- [System Modes](#system-modes)
- [System Thread](#system-thread)
- [System Events](#system-events)
- [Macros](#macros)
- [Other Functions](#other-functions)
- [Preprocessor](https://docs.particle.io/reference/firmware/photon/#preprocessor)

##### Addition Reference

- [External SPI Flash](#external-spi-flash)
- [Bluetooth Low Energy (BLE)](#bluetooth-low-energy-ble)

---

### <span id="inputoutput">Input/Output</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#input-output)        

[**`pinMode()`**](https://docs.particle.io/reference/firmware/photon/#pinmode-) - **`INPUT`**, **`INPUT_PULLUP`**, **`INPUT_PULLDOWN`** or **`OUTPUT`**    
[**`getPinMode()`**](https://docs.particle.io/reference/firmware/photon/#getpinmode-pin-)    
[**`digitalWrite()`**](https://docs.particle.io/reference/firmware/photon/#digitalwrite-) - **`HIGH`** or **`LOW`**    
[**`digitalRead()`**](https://docs.particle.io/reference/firmware/photon/#digitalread-)    
[**`analogWrite()`**](https://docs.particle.io/reference/firmware/photon/#analogwrite-pwm-) - PWM (0 ~ 255)    
[**`analogWrite()`**](https://docs.particle.io/reference/firmware/photon/#analog-output-dac-) - DAC (0 ~ 4095)    
[**`analogRead()`**](https://docs.particle.io/reference/firmware/photon/#analogread-adc-) - (0 ~ 4095)    
[**`setADCSampleTime()`**](https://docs.particle.io/reference/firmware/photon/#setadcsampletime-)

### <span id="low-level-inputoutput">Low Level Input/Output</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#low-level-input-output)       

[**`pinSetFast()`**](https://docs.particle.io/reference/firmware/photon/#pinsetfast-)    
[**`pinResetFast()`**](https://docs.particle.io/reference/firmware/photon/#pinresetfast-)    
[**`digitalWriteFast()`**](https://docs.particle.io/reference/firmware/photon/#digitalwritefast-)     
[**`pinReadFast()`**](https://docs.particle.io/reference/firmware/photon/#pinreadfast-)   

### <span id="advanced-io">Advanced I/O</span> 

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#advanced-i-o)       

[**`tone()`**](https://docs.particle.io/reference/firmware/photon/#tone-)    
[**`noTone()`**](https://docs.particle.io/reference/firmware/photon/#notone-)    
[**`shiftOut()`**](https://docs.particle.io/reference/firmware/photon/#shiftout-)    
[**`shiftIn()`**](https://docs.particle.io/reference/firmware/photon/#shiftin-)          
[**`pulseIn()`**](https://docs.particle.io/reference/firmware/photon/#pulsein-)         
 
### <span id="interrupts">Interrupts</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#interrupts)     

[**`attachInterrupt()`**](https://docs.particle.io/reference/firmware/photon/#attachinterrupt-)    
[**`detachInterrupt()`**](https://docs.particle.io/reference/firmware/photon/#detachinterrupt-)    
[**`interrupts()`**](https://docs.particle.io/reference/firmware/photon/#interrupts-)    
[**`noInterrupts()`**](https://docs.particle.io/reference/firmware/photon/#nointerrupts-)    

### <span id="software-timers">Software Timers</span>

Built-in class **`Timer`**. [Details...](https://docs.particle.io/reference/firmware/photon/#software-timers)      

[Class member callbacks](https://docs.particle.io/reference/firmware/photon/#class-member-callbacks)    
[**`start()`**](https://docs.particle.io/reference/firmware/photon/#start-)    
[**`stop()`**](https://docs.particle.io/reference/firmware/photon/#stop--2)    
[**`changePeriod()`**](https://docs.particle.io/reference/firmware/photon/#changeperiod-)    
[**`reset()`**](https://docs.particle.io/reference/firmware/photon/#reset--1)    
[**`startFromISR()`**](https://docs.particle.io/reference/firmware/photon/#startfromisr-)    
[**`stopFromISR()`**](https://docs.particle.io/reference/firmware/photon/#stopfromisr-)    
[**`resetFromISR()`**](https://docs.particle.io/reference/firmware/photon/#resetfromisr-)    
[**`changePeriodFromISR()`**](https://docs.particle.io/reference/firmware/photon/#changeperiodfromisr-)    
[**`dispose()`**](https://docs.particle.io/reference/firmware/photon/#dispose-)    
[**`isActive()`**](https://docs.particle.io/reference/firmware/photon/#isactive-)   

### <span id="serial">Serial</span>   
    
Differing from the Photon, the USART2 on the Duo is layed out to the side pins and the **`Serial2`** object is constructed in the system firmware, so that you can directly call the methods of **`Serial2`** without including extra header files.

Built-in instances **`Serial`**, **`Serial1`**, **`Serial2`**. [Details...](https://docs.particle.io/reference/firmware/photon/#serial)     

[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin-)    
[**`end()`**](https://docs.particle.io/reference/firmware/photon/#end-)    
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available-)    
[**`availableForWrite()`**](https://docs.particle.io/reference/firmware/photon/#availableforwrite-)    
[**`blockOnOverrun()`**](https://docs.particle.io/reference/firmware/photon/#blockonoverrun-)    
[**`serialEvent()`**](https://docs.particle.io/reference/firmware/photon/#serialevent-)    
[**`peek()`**](https://docs.particle.io/reference/firmware/photon/#peek-)    
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write-)    
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read-)    
[**`print()`**](https://docs.particle.io/reference/firmware/photon/#print-)    
[**`println()`**](https://docs.particle.io/reference/firmware/photon/#println-)    
[**`printf()`**](https://docs.particle.io/reference/firmware/photon/#printf-)    
[**`printlnf()`**](https://docs.particle.io/reference/firmware/photon/#printlnf-)    
[**`flush()`**](https://docs.particle.io/reference/firmware/photon/#flush-)    
[**`halfduplex()`**](https://docs.particle.io/reference/firmware/photon/#halfduplex-)    
Inherited [Stream](#stream) methods 

### <span id="spi">SPI</span>

Built-in instances **`SPI`**, **`SPI1`**. [Details...](https://docs.particle.io/reference/firmware/photon/#spi)    

[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin--1)    
[**`end()`**](https://docs.particle.io/reference/firmware/photon/#end--1)    
[**`setBitOrder()`**](https://docs.particle.io/reference/firmware/photon/#setbitorder-)    
[**`setClockSpeed()`**](https://docs.particle.io/reference/firmware/photon/#setclockspeed)    
[**`setClickDividerReference()`**](https://docs.particle.io/reference/firmware/photon/#setclockdividerreference)    
[**`setClockDivider()`**](https://docs.particle.io/reference/firmware/photon/#setclockdivider-)    
[**`setDataMode()`**](https://docs.particle.io/reference/firmware/photon/#setdatamode-)    
[**`transfer()`**](https://docs.particle.io/reference/firmware/photon/#transfer-)    
[**`transferCancel()`**](https://docs.particle.io/reference/firmware/photon/#transfercancel-)    
[**`onSelect()`**](https://docs.particle.io/reference/firmware/photon/#onselect-)    
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--1)    

### <span id="wire-i2c">Wire (I2C)</span>

Built-in instance **`I2C`**. [Details...](https://docs.particle.io/reference/firmware/photon/#wire-i2c-)     

[**`setSpeed()`**](https://docs.particle.io/reference/firmware/photon/#setspeed-)    
[**`stretchClock()`**](https://docs.particle.io/reference/firmware/photon/#stretchclock-)    
[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin--2)    
[**`end()`**](https://docs.particle.io/reference/firmware/photon/#end--2)    
[**`isEnabled()`**](https://docs.particle.io/reference/firmware/photon/#isenabled-)    
[**`requestFrom()`**](https://docs.particle.io/reference/firmware/photon/#requestfrom-)    
[**`reset()`**](https://docs.particle.io/reference/firmware/photon/#reset-)    
[**`beginTransmission()`**](https://docs.particle.io/reference/firmware/photon/#begintransmission-)    
[**`endTransmission()`**](https://docs.particle.io/reference/firmware/photon/#endtransmission-)    
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--1)    
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--2)    
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read--1)    
[**`peek()`**](https://docs.particle.io/reference/firmware/photon/#peek--1)    
[**`onReceive()`**](https://docs.particle.io/reference/firmware/photon/#onreceive-)    
[**`onRequest()`**](https://docs.particle.io/reference/firmware/photon/#onrequest-)    
Inherited [Stream](#stream) methods  

### <span id="can-canbus">CAN (CANbus)</span>

Built-in class **`CANChannel`**. [Details...](https://docs.particle.io/reference/firmware/photon/#can-canbus-)     

[**`CANMessage`**](https://docs.particle.io/reference/firmware/photon/#canmessage)    
[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin--3)    
[**`end()`**](https://docs.particle.io/reference/firmware/photon/#end--3)     
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--3)    
[**`receive()`**](https://docs.particle.io/reference/firmware/photon/#receive-)    
[**`transmit()`**](https://docs.particle.io/reference/firmware/photon/#transmit-)    
[**`addFilter()`**](https://docs.particle.io/reference/firmware/photon/#addfilter-)    
[**`clearFilters()`**](https://docs.particle.io/reference/firmware/photon/#clearfilters-)    
[**`isEnabled()`**](https://docs.particle.io/reference/firmware/photon/#isenabled--1)    
[**`errorStatus()`**](https://docs.particle.io/reference/firmware/photon/#errorstatus-)    

### <span id="servo">Servo</span>

Built-in class **`Servo`**. [Details...](https://docs.particle.io/reference/firmware/photon/#servo)     

[**`attach()`**](https://docs.particle.io/reference/firmware/photon/#attach-)     
[**`attached()`**](https://docs.particle.io/reference/firmware/photon/#attached-)    
[**`detach()`**](https://docs.particle.io/reference/firmware/photon/#detach-)           
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--5)    
[**`writeMicroseconds()`**](https://docs.particle.io/reference/firmware/photon/#writemicroseconds-)    
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read--4)          
[**`setTrim()`**](https://docs.particle.io/reference/firmware/photon/#settrim-)    

### <span id="rgb">RGB</span>

Built-in instance **`RGB`**. [Details...](https://docs.particle.io/reference/firmware/photon/#rgb)    

[**`control()`**](https://docs.particle.io/reference/firmware/photon/#control-user_control-)    
[**`controlled()`**](https://docs.particle.io/reference/firmware/photon/#controlled-)    
[**`color()`**](https://docs.particle.io/reference/firmware/photon/#color-red-green-blue-)    
[**`brightness()`**](https://docs.particle.io/reference/firmware/photon/#brightness-val-)    
[**`onChange()`**](https://docs.particle.io/reference/firmware/photon/#onchange-handler-)    

### <span id="eeprom-emulation">EEPROM Emulation</span>

Built-in instance **`EEPROM`**. [Details...](https://docs.particle.io/reference/firmware/photon/#eeprom)    

[**`length()`**](https://docs.particle.io/reference/firmware/photon/#length-)    
[**`put()`**](https://docs.particle.io/reference/firmware/photon/#put-)    
[**`get()`**](https://docs.particle.io/reference/firmware/photon/#get-)    
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read--5)    
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--6)    
[**`clear()`**](https://docs.particle.io/reference/firmware/photon/#clear-)    
[**`hasPendingErase()`**](https://docs.particle.io/reference/firmware/photon/#haspendingerase-)    
[**`performPendingErase()`**](https://docs.particle.io/reference/firmware/photon/#performpendingerase-)    

### <span id="backup-ram-sram">Backup RAM (SRAM)</span>

Backup RAM. [Details...](https://docs.particle.io/reference/firmware/photon/#backup-ram-sram-)    

* [Storing data in Backup RAM (SRAM)](https://docs.particle.io/reference/firmware/photon/#storing-data-in-backup-ram-sram-)    
* [Enabling Backup RAM (SRAM)](https://docs.particle.io/reference/firmware/photon/#enabling-backup-ram-sram-)    
* [Making changes to the layout or bytes of retained variables](https://docs.particle.io/reference/firmware/photon/#making-changes-to-the-layout-or-types-of-retained-variables)    

### <span id="application-watchdog">Application Watchdog</span>

Built-in class **`ApplicationWatchdog`**. [Details...](https://docs.particle.io/reference/firmware/photon/#application-watchdog)    
 
[**`checkin()`**](https://docs.particle.io/reference/firmware/photon/#application-watchdog)    

### <span id="time">Time</span>

Built-in instance **`Time`**. [Details...](https://docs.particle.io/reference/firmware/photon/#time)    

[**`hour()`**](https://docs.particle.io/reference/firmware/photon/#hour-)    
[**`hourFormat12()`**](https://docs.particle.io/reference/firmware/photon/#hourformat12-)    
[**`isAM()`**](https://docs.particle.io/reference/firmware/photon/#isam-)    
[**`isPM()`**](https://docs.particle.io/reference/firmware/photon/#ispm-)    
[**`minute()`**](https://docs.particle.io/reference/firmware/photon/#minute-)    
[**`second()`**](https://docs.particle.io/reference/firmware/photon/#second-)    
[**`day()`**](https://docs.particle.io/reference/firmware/photon/#day-)        
[**`weekday()`**](https://docs.particle.io/reference/firmware/photon/#weekday-)    
[**`month()`**](https://docs.particle.io/reference/firmware/photon/#month-)    
[**`year()`**](https://docs.particle.io/reference/firmware/photon/#year-)    
[**`now()`**](https://docs.particle.io/reference/firmware/photon/#now-)    
[**`local()`**](https://docs.particle.io/reference/firmware/photon/#local-)    
[**`zone()`**](https://docs.particle.io/reference/firmware/photon/#zone-)    
[**`setTime()`**](https://docs.particle.io/reference/firmware/photon/#settime-)    
[**`timeStr()`**](https://docs.particle.io/reference/firmware/photon/#timestr-)    
[**`format()`**](https://docs.particle.io/reference/firmware/photon/#format-)    
[**`setFormat()`**](https://docs.particle.io/reference/firmware/photon/#setformat-)    
[**`getFormat()`**](https://docs.particle.io/reference/firmware/photon/#getformat-)    
[**`millis()`**](https://docs.particle.io/reference/firmware/photon/#millis-)    
[**`micros()`**](https://docs.particle.io/reference/firmware/photon/#micros-)    
[**`delay()`**](https://docs.particle.io/reference/firmware/photon/#delay-)    
[**`delayMicroseconds()`**](https://docs.particle.io/reference/firmware/photon/#delaymicroseconds-)    

### <span id="math">Math</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#math)    

[**`min()`**](https://docs.particle.io/reference/firmware/photon/#min-)    
[**`max()`**](https://docs.particle.io/reference/firmware/photon/#max-)    
[**`abs()`**](https://docs.particle.io/reference/firmware/photon/#abs-)    
[**`constrain()`**](https://docs.particle.io/reference/firmware/photon/#constrain-)    
[**`map()`**](https://docs.particle.io/reference/firmware/photon/#map-)    
[**`pow()`**](https://docs.particle.io/reference/firmware/photon/#pow-)    
[**`sqrt()`**](https://docs.particle.io/reference/firmware/photon/#sqrt-)    

### <span id="random-numbers">Random Numbers</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#random-numbers)    

[**`random()`**](https://docs.particle.io/reference/firmware/photon/#random-)    
[**`randomSeed()`**](https://docs.particle.io/reference/firmware/photon/#randomseed-)    

### <span id="string">String</span>

Built-in class **`String`**. [Details...](https://docs.particle.io/reference/firmware/photon/#string-class)    

[**`charAt()`**](https://docs.particle.io/reference/firmware/photon/#charat-)    
[**`compareTo()`**](https://docs.particle.io/reference/firmware/photon/#compareto-)    
[**`concat()`**](https://docs.particle.io/reference/firmware/photon/#concat-)    
[**`endsWith()`**](https://docs.particle.io/reference/firmware/photon/#endswith-)    
[**`startsWith()`**](https://docs.particle.io/reference/firmware/photon/#startswith-)    
[**`equals()`**](https://docs.particle.io/reference/firmware/photon/#equals-)    
[**`equalsIgnoreCase()`**](https://docs.particle.io/reference/firmware/photon/#equalsignorecase-)    
[**`format()`**](https://docs.particle.io/reference/firmware/photon/#format--1)    
[**`getBytes()`**](https://docs.particle.io/reference/firmware/photon/#getbytes-)    
[**`indexOf()`**](https://docs.particle.io/reference/firmware/photon/#indexof-)    
[**`lastIndexOf()`**](https://docs.particle.io/reference/firmware/photon/#lastindexof-)    
[**`length()`**](https://docs.particle.io/reference/firmware/photon/#length--1)    
[**`remove()`**](https://docs.particle.io/reference/firmware/photon/#remove-)    
[**`replace()`**](https://docs.particle.io/reference/firmware/photon/#replace-)    
[**`reserve()`**](https://docs.particle.io/reference/firmware/photon/#reserve-)    
[**`setCharAt()`**](https://docs.particle.io/reference/firmware/photon/#setcharat-)    
[**`substring()`**](https://docs.particle.io/reference/firmware/photon/#substring-)    
[**`toCharArray()`**](https://docs.particle.io/reference/firmware/photon/#tochararray-)    
[**`toFloat()`**](https://docs.particle.io/reference/firmware/photon/#tofloat-)    
[**`toInt()`**](https://docs.particle.io/reference/firmware/photon/#toint-)    
[**`toLowerCase()`**](https://docs.particle.io/reference/firmware/photon/#tolowercase-)    
[**`toUpperCase()`**](https://docs.particle.io/reference/firmware/photon/#touppercase-)    
[**`trim()`**](https://docs.particle.io/reference/firmware/photon/#trim-)    

### <span id="wifi">WiFi</span>

Built-in instance **`WiFi`**. [Details...](https://docs.particle.io/reference/firmware/photon/#wifi)    

[**`on()`**](https://docs.particle.io/reference/firmware/photon/#on-)    
[**`off()`**](https://docs.particle.io/reference/firmware/photon/#off-)    
[**`connect()`**](https://docs.particle.io/reference/firmware/photon/#connect-)    
[**`disconnect()`**](https://docs.particle.io/reference/firmware/photon/#disconnect-)    
[**`connecting()`**](https://docs.particle.io/reference/firmware/photon/#connecting-)    
[**`ready()`**](https://docs.particle.io/reference/firmware/photon/#ready-)    
[**`selectAntenna()`**](https://docs.particle.io/reference/firmware/photon/#selectantenna-)    
[**`listen()`**](https://docs.particle.io/reference/firmware/photon/#listen-)    
[**`listening()`**](https://docs.particle.io/reference/firmware/photon/#listening-)    
[**`setCredentials()`**](https://docs.particle.io/reference/firmware/photon/#setcredentials-)    
[**`getCredentials()`**](https://docs.particle.io/reference/firmware/photon/#getcredentials-)    
[**`clearCredentials()`**](https://docs.particle.io/reference/firmware/photon/#clearcredentials-)    
[**`hasCredentials()`**](https://docs.particle.io/reference/firmware/photon/#hascredentials-)    
[**`macAddress()`**](https://docs.particle.io/reference/firmware/photon/#macaddress-)    
[**`SSID()`**](https://docs.particle.io/reference/firmware/photon/#ssid-)    
[**`BSSID()`**](https://docs.particle.io/reference/firmware/photon/#bssid-)    
[**`RSSI()`**](https://docs.particle.io/reference/firmware/photon/#rssi-)    
[**`ping()`**](https://docs.particle.io/reference/firmware/photon/#ping-)    
[**`scan()`**](https://docs.particle.io/reference/firmware/photon/#scan-)    
[**`resolve()`**](https://docs.particle.io/reference/firmware/photon/#resolve-)        
[**`localIP()`**](https://docs.particle.io/reference/firmware/photon/#localip-)    
[**`subnetMask()`**](https://docs.particle.io/reference/firmware/photon/#subnetmask-)    
[**`gatewayIP()`**](https://docs.particle.io/reference/firmware/photon/#gatewayip-)    
[**`dnsServerIP()`**](https://docs.particle.io/reference/firmware/photon/#dnsserverip-)    
[**`dhcpServerIP()`**](https://docs.particle.io/reference/firmware/photon/#dhcpserverip-)    
[**`setStaticIP()`**](https://docs.particle.io/reference/firmware/photon/#setstaticip-)    
[**`useStaticIP()`**](https://docs.particle.io/reference/firmware/photon/#usestaticip-)    
[**`useDynamicIP()`**](https://docs.particle.io/reference/firmware/photon/#usedynamicip-)    

### <span id="ipaddress">IPAddress</span>

Built-in class **`IPAddress`**. [Details...](https://docs.particle.io/reference/firmware/photon/#ipaddress)    

[**`=`**](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[**`==`**](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[**`!=`**](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[**`[]`**](https://docs.particle.io/reference/firmware/photon/#ipaddress)    

### <span id="tcpserver">TCPServer</span>

Built-in class **`TCPServer`**. [Details...](https://docs.particle.io/reference/firmware/photon/#tcpserver)    

[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin--4)    
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--4)    
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--2)    
[**`print()`**](https://docs.particle.io/reference/firmware/photon/#print--1)    
[**`println()`**](https://docs.particle.io/reference/firmware/photon/#println--1)    

### <span id="tcpclient">TCPClient</span>

Built-in class **`TCPClient`**. [Details...](https://docs.particle.io/reference/firmware/photon/#tcpclient)    

[**`connect()`**](https://docs.particle.io/reference/firmware/photon/#connect--1)    
[**`connected()`**](https://docs.particle.io/reference/firmware/photon/#connected-)    
[**`stop()`**](https://docs.particle.io/reference/firmware/photon/#stop-)     
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--3)    
[**`print()`**](https://docs.particle.io/reference/firmware/photon/#print--2)    
[**`println()`**](https://docs.particle.io/reference/firmware/photon/#println--2)    
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--5)    
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read--2)    
[**`flush()`**](https://docs.particle.io/reference/firmware/photon/#flush--1)    
[**`remoteIP()`**](https://docs.particle.io/reference/firmware/photon/#remoteip-)     
Inherited [Stream](#stream) methods   

### <span id="udp">UDP</span>

Built-in class **`UDP`**. [Details...](https://docs.particle.io/reference/firmware/photon/#udp)    
  
[**`begin()`**](https://docs.particle.io/reference/firmware/photon/#begin--5)    
[**`stop()`**](https://docs.particle.io/reference/firmware/photon/#stop--1)     
[**`available()`**](https://docs.particle.io/reference/firmware/photon/#available--6)    
[**`beginPacket()`**](https://docs.particle.io/reference/firmware/photon/#beginpacket-)     
[**`endPacket()`**](https://docs.particle.io/reference/firmware/photon/#endpacket-)    
[**`sendPacket()`**](https://docs.particle.io/reference/firmware/photon/#sendpacket-)    
[**`parsePacket()`**](https://docs.particle.io/reference/firmware/photon/#parsepacket-)      
[**`write()`**](https://docs.particle.io/reference/firmware/photon/#write--4)      
[**`read()`**](https://docs.particle.io/reference/firmware/photon/#read--3)        
[**`remoteIP()`**](https://docs.particle.io/reference/firmware/photon/#remoteip--1)    
[**`remotePort()`**](https://docs.particle.io/reference/firmware/photon/#remoteport-)    
[**`setBuffer()`**](https://docs.particle.io/reference/firmware/photon/#setbuffer-)    
[**`releaseBuffer()`**](https://docs.particle.io/reference/firmware/photon/#releasebuffer-)        
[**`joinMulticast()`**](https://docs.particle.io/reference/firmware/photon/#joinmulticast-)    
[**`leaveMulticast()`**](https://docs.particle.io/reference/firmware/photon/#leavemulticast-)    
Inherited [Stream](#stream) methods 

### <span id="stream">Stream</span>

Built-in class **`Stream`**, inherited by **`Serial`**, **`Wire`**, **`TCPClient`** and **`UDP`**. [Details...](https://docs.particle.io/reference/firmware/photon/#stream-class)    

[**`setTimeout()`**](https://docs.particle.io/reference/firmware/photon/#settimeout-)    
[**`find()`**](https://docs.particle.io/reference/firmware/photon/#find-)    
[**`findUntil()`**](https://docs.particle.io/reference/firmware/photon/#finduntil-)    
[**`readBytes()`**](https://docs.particle.io/reference/firmware/photon/#readbytes-)    
[**`readBytesUntil()`**](https://docs.particle.io/reference/firmware/photon/#readbytesuntil-)    
[**`readString()`**](https://docs.particle.io/reference/firmware/photon/#readstring-)    
[**`readStringUntil()`**](https://docs.particle.io/reference/firmware/photon/#readstringuntil-)    
[**`parseInt()`**](https://docs.particle.io/reference/firmware/photon/#parseint-)    
[**`parseFloat()`**](https://docs.particle.io/reference/firmware/photon/#parsefloat-)    

### <span id="softap-http-pages">SoftAP HTTP Pages</span>

SoftAP HTTP pages. [Details...](https://docs.particle.io/reference/firmware/photon/#softap-http-pages)

* [The page callback function](https://docs.particle.io/reference/firmware/photon/#the-page-callback-function)    
* [Retrieving the request data](https://docs.particle.io/reference/firmware/photon/#retrieving-the-request-data)    
* [Sending a response](https://docs.particle.io/reference/firmware/photon/#sending-a-response)    
* [The default page](https://docs.particle.io/reference/firmware/photon/#the-default-page)    
* [Sending a Redirect](https://docs.particle.io/reference/firmware/photon/#sending-a-redirect)    

### <span id="cloud-functions">Cloud Functions</span>

Built-in instance **`Particle`**. [Details...](https://docs.particle.io/reference/firmware/photon/#cloud-functions)    

[**`connect()`**](https://docs.particle.io/reference/firmware/photon/#particle-connect-)    
[**`connected()`**](https://docs.particle.io/reference/firmware/photon/#particle-connected-)    
[**`process()`**](https://docs.particle.io/reference/firmware/photon/#particle-process-)    
[**`disconnect()`**](https://docs.particle.io/reference/firmware/photon/#particle-disconnect-)    
[**`variable()`**](https://docs.particle.io/reference/firmware/photon/#particle-variable-) - Expose a variable through the Cloud so that it can be called with **GET** method     
[**`function()`**](https://docs.particle.io/reference/firmware/photon/#particle-function-) - Expose a function through the Cloud so that it can be called with **POST** method     
[**`publish()`**](https://docs.particle.io/reference/firmware/photon/#particle-publish-) - Publish an event through the Particle Cloud that will be forwarded to all registered listeners    
[**`subscribe()`**](https://docs.particle.io/reference/firmware/photon/#particle-subscribe-) - Subscribe to events published by devices    
[**`unsubscribe()`**](https://docs.particle.io/reference/firmware/photon/#particle-unsubscribe-) - Removes all subscription handlers previously registered with `Particle.subscribe()`    
[**`syncTime()`**](https://docs.particle.io/reference/firmware/photon/#particle-synctime-)    

* [Get Public IP](https://docs.particle.io/reference/firmware/photon/#get-public-ip)    
* [Get Device name](https://docs.particle.io/reference/firmware/photon/#get-device-name)    
* [Get Random seed](https://docs.particle.io/reference/firmware/photon/#get-random-seed)    

### <span id="system-calls">System Calls</span>

Built-in instance **`System`**. [Details...](https://docs.particle.io/reference/firmware/photon/#system-calls)    

[**`version()`**](https://docs.particle.io/reference/firmware/photon/#version-)    
[**`versionNumber()`**](https://docs.particle.io/reference/firmware/photon/#versionnumber-)    
[**`buttonPushed()`**](https://docs.particle.io/reference/firmware/photon/#buttonpushed-)    
[**`ticks()`**](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[**`ticksPerMicrosecond()`**](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[**`ticksDelay()`**](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[**`freeMemory()`**](https://docs.particle.io/reference/firmware/photon/#freememory-)    
[**`dfu()`**](https://docs.particle.io/reference/firmware/photon/#dfu-)    
[**`deviceID()`**](https://docs.particle.io/reference/firmware/photon/#deviceid-)    
[**`enterSafeMode()`**](https://docs.particle.io/reference/firmware/photon/#entersafemode-)    
[**`sleep()`**](https://docs.particle.io/reference/firmware/photon/#sleep-sleep-)    
[**`reset()`**](https://docs.particle.io/reference/firmware/photon/#reset--2)    
[**`on()`**](https://docs.particle.io/reference/firmware/photon/#system-events-overview) - register a system event handler    
[**`enableUpdates()`**](https://docs.particle.io/reference/firmware/photon/#system-enableupdates-)    
[**`disableUpdates()`**](https://docs.particle.io/reference/firmware/photon/#system-disableupdates-)     
[**`updatesEnabled()`**](https://docs.particle.io/reference/firmware/photon/#system-updatesenabled-)    
[**`updatesPending()`**](https://docs.particle.io/reference/firmware/photon/#system-updatespending-)    

### <span id="system-modes">System Modes</span>

System modes. [Details...](https://docs.particle.io/reference/firmware/photon/#system-modes)

[**`SYSTEM_MODE()`**](https://docs.particle.io/reference/firmware/photon/#system-modes) - default to **`AUTOMATIC`** mode        

- [**`AUTOMATIC`**](https://docs.particle.io/reference/firmware/photon/#automatic-mode): Automatically try to connect to Wi-Fi and the Particle Cloud and handle the cloud messages.    
- [**`SEMI_AUTOMATIC`**](https://docs.particle.io/reference/firmware/photon/#semi-automatic-mode): Manually connect to Wi-Fi and the Particle Cloud, but automatically handle the cloud messages.    
- [**`MANUAL`**](https://docs.particle.io/reference/firmware/photon/#manual-mode): Manually connect to Wi-Fi and the Particle Cloud and handle the cloud messages.

### <span id="system-thread">System Thread</span>

System thread. [Details...](https://docs.particle.io/reference/firmware/photon/#system-thread)

[**`SYSTEM_THREAD()`**](https://docs.particle.io/reference/firmware/photon/#system-thread)    
[**`SINGLE_THREADED_BLOCK()`**](https://docs.particle.io/reference/firmware/photon/#single_threaded_block-)    
[**`AUTOMIC_BLOCK()`**](https://docs.particle.io/reference/firmware/photon/#atomic_block-)    

* [System Threading Behavior](https://docs.particle.io/reference/firmware/photon/#system-threading-behavior)    
* [System Functions](https://docs.particle.io/reference/firmware/photon/#system-functions)    
* [Task Switching](https://docs.particle.io/reference/firmware/photon/#task-switching)    
* [Synchronizing Access to Shared System Resources](https://docs.particle.io/reference/firmware/photon/#synchronizing-access-to-shared-system-resources)    
* [Waiting for the system](https://docs.particle.io/reference/firmware/photon/#waiting-for-the-system)    

### <span id="system-events">System Events</span>

System events. [Details...](https://docs.particle.io/reference/firmware/photon/#system-events)

* [System Events Overview](https://docs.particle.io/reference/firmware/photon/#system-events-overview)    
* [System Events Reference](https://docs.particle.io/reference/firmware/photon/#system-events-reference)    

### <span id="macros">Macros</span>

Macros. [Details...](https://docs.particle.io/reference/firmware/photon/#macros)

[**`STARTUP()`**](https://docs.particle.io/reference/firmware/photon/#startup-)    
[**`PRODUCT_ID()`**](https://docs.particle.io/reference/firmware/photon/#product_id-)    

### <span id="other-functions">Other Functions</span>

Note that most of the functions in newlib described at [https://sourceware.org/newlib/libc.html](https://sourceware.org/newlib/libc.html) are available for use in addition to the functions outlined above.

### <span id="external-spi-flash">External SPI Flash</span> 

The Duo is soldered with an external non-volatile SPI flash, which memory is up to 2MB and every sector is made up of 4K bytes. But only the first 768KB (192 sectors) are available for user use, the rest memory space are reserved for system use, see the [Firmware Architecture Overview](firmware_architecture_overview.md).

Built-in instance **`sFLASH`**.      

[**`eraseSector()`**](#erasesector)      
[**`writeBuffer()`**](#writebuffer)    
[**`readBuffer()`**](#readbuffer)    
[**`selfTest()`**](#selftest)

##### <span id="erasesector">`eraseSector()`</span> 

This method erases a given sector of the external flash. The pass in parameter **`uint32_t SectorAddr`** can be any of the address as long as it is located in the sector, i.e. the sector you are going to erase is (**`SectorAddr >> 3`**). Operation to the reserved sectors makes no effect.
 
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
	
	  if( selfTest() == 0 ) {
	    Serial.println("The external SPI flash functions well.");
	  }
	  else {
	    Serial.print("There is something wrong with the external SPI flash!");
	  }
	}
	
	void loop() {
	}

### <span id="bluetooth-low-energy-ble">Bluetooth Low Energy (BLE)</span> 

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
[**`setRandomAddrMode()`**](#setrandomaddrmode)    
[**`setRandomAddr()`**](#setrandomaddr)    
[**`setPublicBDAddr()`**](#setpublicbdaddr)    
[**`getLocalBdAddr()`**](#getlocalbdaddr)    

#### Generic Access Profile (GAP) 

[**`onConnectedCallback()`**](#onconnectedcallback)    
[**`onDisconnectedCallback()`**](#ondisconnectedcallback)    

BLE Central:    
[**`setScanParams()`**](#setscanparams)    
[**`startScanning()`**](#startscanning)    
[**`stopScanning()`**](#stopscanning)       
[**`connect()`**](#connect)    
[**`disconnect()`**](#disconnect)    
[**`onScanReportCallback()`**](#onscanreportcallback) 

BLE Peripheral:    
[**`setLocalName()`**](#setlocalname)    
[**`setConnParams()`**](#setconnparams)    
[**`setAdvertisementParams()`**](#setadvertisementparams)    
[**`setAdvertisementData()`**](#setadvertisementdata)    
[**`setScanResponseData()`**](#setscanresponsedata)    
[**`startAdvertising()`**](#startadvertising)    
[**`stopAdvertising()`**](#stopadvertising)  

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

Enables the HCI interface between Host and Controller, as well as initialize the Controller to the default state. It will create a thread to deal with the HCI commands and events. It **MUST** be called before calling any other BLE methods.

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

Disconnects from the peer device that is connected through [**`ble.connect()`**](#connect). It takes a single parameter - the connection handle that is assigned when connection established before.

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`gatt_client_service_t`** The discovered service

E.g. **`void serviceDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_service_t *service)`**

	static gatt_client_service_t discovered_service;

	static void serviceDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_service_t *service) {
	  uint8_t index;
	  if (status == BLE_STATUS_OK) {   // Found a service.
	    Serial.println(" ");
	    Serial.print("Service start handle: ");
	    Serial.println(service->start_group_handle, HEX);

	    Serial.print("Service end handle: ");
	    Serial.println(service->end_group_handle, HEX);

	    Serial.print("16-bits service UUID: ");
	    Serial.println(service->uuid16, HEX);

	    Serial.print("128-bits service UUID: ");
	    for (index = 0; index < 16; index++) {
	      Serial.print(service->uuid128[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");

	    discovered_service[service_index++] = *service;
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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`gatt_client_characteristic_t`** The discovered characteristic

E.g. **`void charsDiscoveredCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_t *characteristic)`**

	static gatt_client_characteristic_t discovered_char;

	static void charsDiscoveredCallback(BLEStatus_t status, uint16_t conn_handle, gatt_client_characteristic_t *characteristic) {
	  uint8_t index;
	  if (status == BLE_STATUS_OK) {   // Found a characteristic.
	    Serial.println(" ");
	    Serial.print("Characteristic start handle: ");
	    Serial.println(characteristic->start_handle, HEX);

	    Serial.print("Characteristic value handle: ");
	    Serial.println(characteristic->value_handle, HEX);

	    Serial.print("Characteristic end_handle: ");
	    Serial.println(characteristic->end_handle, HEX);

	    Serial.print("Characteristic properties: ");
	    Serial.println(characteristic->properties, HEX);

	    Serial.print("16-bits characteristic UUID: ");
	    Serial.println(characteristic->uuid16, HEX);

	    Serial.print("128-bits characteristic UUID: ");
	    for (index = 0; index < 16; index++) {
	      Serial.print(characteristic->uuid128[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`gatt_client_characteristic_t`** The discovered descriptor

E.g. **`void discoveredCharsDescriptorsCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_descriptor_t *descriptor)`**

	static gatt_client_characteristic_descriptor_t char_descriptor;

	static void discoveredCharsDescriptorsCallback(BLEStatus_t status, uint16_t con_handle, gatt_client_characteristic_descriptor_t *descriptor) {
	  uint8_t index;
	  if (status == BLE_STATUS_OK) {   // Found a descriptor.
	    Serial.println(" ");
	    Serial.print("Descriptor handle: ");
	    Serial.println(descriptor->handle, HEX);

	    Serial.print("16-bits descriptor UUID: ");
	    Serial.println(descriptor->uuid16, HEX);

	    Serial.print("128-bits descriptor UUID: ");
	    for (index = 0; index < 16; index++) {
	      Serial.print(descriptor->uuid128[index], HEX);
	      Serial.print(" ");
	    }
	    Serial.println(" ");

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`uint16_t`** The characteristic value attribute handle
* **`uint8_t *`** A pointer to the buffer that holds the read back data
* **`uint16_t`** The length of the read back data

E.g. **`void gattReadCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReadCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  if (status == BLE_STATUS_OK) {
	    Serial.println(" ");
	    Serial.println("Reads characteristic value successfully");
	    Serial.print("Connection handle: ");
	    Serial.println(conn_handle, HEX);

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`uint16_t`** The characteristic descriptor attribute handle
* **`uint8_t *`** A pointer to the buffer that holds the read back data
* **`uint16_t`** The length of the read back data

E.g. **`void gattReadDescriptorCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReadDescriptorCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  if(status == BLE_STATUS_OK) {
	    Serial.println(" ");
	    Serial.println("Reads descriptor successfully.");

	    Serial.print("Connection handle: ");
	    Serial.println(conn_handle, HEX);

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`uint16_t`** The characteristic value attribute handle
* **`uint8_t *`** A pointer to the buffer that holds the notified data
* **`uint16_t`** The length of the notified data

E.g. **`void gattNotifyUpdateCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReceivedNotificationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  Serial.println(" ");
	  Serial.println("Received new notification:");

	  Serial.print("Connection handle: ");
	  Serial.println(con_handle, HEX);

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

* **`BLEStatus_t`** BLE status, which should be one of the following:
    - **`BLE_STATUS_OK`**
    - **`BLE_STATUS_DONE`**
    - **`BLE_STATUS_CONNECTION_TIMEOUT`**
    - **`BLE_STATUS_CONNECTION_ERROR`**
    - **`BLE_STATUS_OTHER_ERROR`**
* **`uint16_t`** The connection handle
* **`uint16_t`** The characteristic value attribute handle
* **`uint8_t *`** A pointer to the buffer that holds the indicated data
* **`uint16_t`** The length of the indicated data

E.g. **`void gattReceivedIndicationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length)`**

	static void gattReceivedIndicationCallback(BLEStatus_t status, uint16_t conn_handle, uint16_t value_handle, uint8_t *value, uint16_t length) {
	  uint8_t index;
	  Serial.println(" ");
	  Serial.println("Receive new indication:");

	  Serial.print("Connection handle: ");
	  Serial.println(con_handle, HEX);

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

Adds a BLE service to the GATT server.

##### <span id="addcharacteristic">`addCharacteristic()`</span>

Add a BLE characteristic to the GATT server.

##### <span id="addcharacteristicdynamic">`addCharacteristicDynamic()`</span>

Add a dynamic BLE characteristic to the GATT server.

##### <span id="setlocalname">`setLocalName()`</span>

Set the local name of the BLE device.

##### <span id="setconnparams">`setConnParams()`</span>

Set the preferred connection parameters.

##### <span id="setadvertisementparams">`setAdvertisementParams()`</span>

Set the advertising parameters.

##### <span id="setadvertisementdata">`setAdvertisementData()`</span>

Set the advertising data.

##### <span id="setscanresponsedata">`setScanResponseData()`</span>

Set the scan respond data.

##### <span id="startadvertising">`startAdvertising()`</span>

Start advertising.

##### <span id="stopadvertising">`stopAdvertising()`</span>

Stop advertising.

##### <span id="attservercansendpacket">`attServerCanSendPacket()`</span>

Check if the device can send notification or indication to remote device.

##### <span id="sendnotify">`sendNotify()`</span>

Send a notification to remote device.

##### <span id="sendindicate">`sendIndicate()`</span>

Send an indication to remote device.

##### <span id="ondatareadcallback">`onDataReadCallback()`</span>

Register the callback function when characteristic value is read by remote device.

##### <span id="ondatawritecallback">`onDataWriteCallback()`</span>

Register the call back function when characteristic value is written by remote device.


## Support

* [RedBear Discussion](http://discuss.redbear.cc)
* [Particle Community](https://community.particle.io)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.