# Duo: Programming Reference
---

The Duo is installed the customed Particle firmware by default during manufacturing. You can build your own applications around the system firmware, which with lots of functions and libraries built-in so that you can invoke them directly in your sketch. The programming language and application architecture are almost Arduino compatible -- all you want should be achieved in the `setup()` and `loop()` function.

* `setup()` - Runs once at the beginning of your program    
* `loop()` - Runs continuously over and over

E.g.:

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

[`pinMode()`](https://docs.particle.io/reference/firmware/photon/#pinmode-) - `INPUT`, `INPUT_PULLUP`, `INPUT_PULLDOWN` or `OUTPUT`    
[`getPinMode()`](https://docs.particle.io/reference/firmware/photon/#getpinmode-pin-)    
[`digitalWrite()`](https://docs.particle.io/reference/firmware/photon/#digitalwrite-) - `HIGH` or `LOW`    
[`digitalRead()`](https://docs.particle.io/reference/firmware/photon/#digitalread-)    
[`analogWrite()`](https://docs.particle.io/reference/firmware/photon/#analogwrite-pwm-) - PWM (0 ~ 255)    
[`analogWrite()`](https://docs.particle.io/reference/firmware/photon/#analog-output-dac-) - DAC (0 ~ 4095)    
[`analogRead()`](https://docs.particle.io/reference/firmware/photon/#analogread-adc-) - (0 ~ 4095)    
[`setADCSampleTime()`](https://docs.particle.io/reference/firmware/photon/#setadcsampletime-)

### <span id="low-level-inputoutput">Low Level Input/Output</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#low-level-input-output)       

[`pinSetFast()`](https://docs.particle.io/reference/firmware/photon/#pinsetfast-)    
[`pinResetFast()`](https://docs.particle.io/reference/firmware/photon/#pinresetfast-)    
[`digitalWriteFast()`](https://docs.particle.io/reference/firmware/photon/#digitalwritefast-)     
[`pinReadFast()`](https://docs.particle.io/reference/firmware/photon/#pinreadfast-)   

### <span id="advanced-io">Advanced I/O</span> 

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#advanced-i-o)       

[`tone()`](https://docs.particle.io/reference/firmware/photon/#tone-)    
[`noTone()`](https://docs.particle.io/reference/firmware/photon/#notone-)    
[`shiftOut()`](https://docs.particle.io/reference/firmware/photon/#shiftout-)    
[`shiftIn()`](https://docs.particle.io/reference/firmware/photon/#shiftin-)          
[`pulseIn()`](https://docs.particle.io/reference/firmware/photon/#pulsein-)         
 
### <span id="interrupts">Interrupts</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#interrupts)     

[`attachInterrupt()`](https://docs.particle.io/reference/firmware/photon/#attachinterrupt-)    
[`detachInterrupt()`](https://docs.particle.io/reference/firmware/photon/#detachinterrupt-)    
[`interrupts()`](https://docs.particle.io/reference/firmware/photon/#interrupts-)    
[`noInterrupts()`](https://docs.particle.io/reference/firmware/photon/#nointerrupts-)    

### <span id="software-timers">Software Timers</span>

Built-in class `Timer`. [Details...](https://docs.particle.io/reference/firmware/photon/#software-timers)      

[Class member callbacks](https://docs.particle.io/reference/firmware/photon/#class-member-callbacks)    
[`start()`](https://docs.particle.io/reference/firmware/photon/#start-)    
[`stop()`](https://docs.particle.io/reference/firmware/photon/#stop--2)    
[`changePeriod()`](https://docs.particle.io/reference/firmware/photon/#changeperiod-)    
[`reset()`](https://docs.particle.io/reference/firmware/photon/#reset--1)    
[`startFromISR()`](https://docs.particle.io/reference/firmware/photon/#startfromisr-)    
[`stopFromISR()`](https://docs.particle.io/reference/firmware/photon/#stopfromisr-)    
[`resetFromISR()`](https://docs.particle.io/reference/firmware/photon/#resetfromisr-)    
[`changePeriodFromISR()`](https://docs.particle.io/reference/firmware/photon/#changeperiodfromisr-)    
[`dispose()`](https://docs.particle.io/reference/firmware/photon/#dispose-)    
[`isActive()`](https://docs.particle.io/reference/firmware/photon/#isactive-)   

### <span id="serial">Serial</span>   
    
Differing from the Photon, the USART2 on the Duo is layed out to the side pins and the `Serial2` object is constructed in the system firmware, so that you can directly call the methods of `Serial2` without including extra header files.

Built-in instances `Serial`, `Serial1`, `Serial2`. [Details...](https://docs.particle.io/reference/firmware/photon/#serial)     

[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin-)    
[`end()`](https://docs.particle.io/reference/firmware/photon/#end-)    
[`available()`](https://docs.particle.io/reference/firmware/photon/#available-)    
[`availableForWrite()`](https://docs.particle.io/reference/firmware/photon/#availableforwrite-)    
[`blockOnOverrun()`](https://docs.particle.io/reference/firmware/photon/#blockonoverrun-)    
[`serialEvent()`](https://docs.particle.io/reference/firmware/photon/#serialevent-)    
[`peek()`](https://docs.particle.io/reference/firmware/photon/#peek-)    
[`write()`](https://docs.particle.io/reference/firmware/photon/#write-)    
[`read()`](https://docs.particle.io/reference/firmware/photon/#read-)    
[`print()`](https://docs.particle.io/reference/firmware/photon/#print-)    
[`println()`](https://docs.particle.io/reference/firmware/photon/#println-)    
[`printf()`](https://docs.particle.io/reference/firmware/photon/#printf-)    
[`printlnf()`](https://docs.particle.io/reference/firmware/photon/#printlnf-)    
[`flush()`](https://docs.particle.io/reference/firmware/photon/#flush-)    
[`halfduplex()`](https://docs.particle.io/reference/firmware/photon/#halfduplex-)    
Inherited [Stream](#stream) methods 

### <span id="spi">SPI</span>

Built-in instances `SPI`, `SPI1`. [Details...](https://docs.particle.io/reference/firmware/photon/#spi)    

[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin--1)    
[`end()`](https://docs.particle.io/reference/firmware/photon/#end--1)    
[`setBitOrder()`](https://docs.particle.io/reference/firmware/photon/#setbitorder-)    
[`setClockSpeed()`](https://docs.particle.io/reference/firmware/photon/#setclockspeed)    
[`setClickDividerReference()`](https://docs.particle.io/reference/firmware/photon/#setclockdividerreference)    
[`setClockDivider()`](https://docs.particle.io/reference/firmware/photon/#setclockdivider-)    
[`setDataMode()`](https://docs.particle.io/reference/firmware/photon/#setdatamode-)    
[`transfer()`](https://docs.particle.io/reference/firmware/photon/#transfer-)    
[`transferCancel()`](https://docs.particle.io/reference/firmware/photon/#transfercancel-)    
[`onSelect()`](https://docs.particle.io/reference/firmware/photon/#onselect-)    
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--1)    

### <span id="wire-i2c">Wire (I2C)</span>

Built-in instance `I2C`. [Details...](https://docs.particle.io/reference/firmware/photon/#wire-i2c-)     

[`setSpeed()`](https://docs.particle.io/reference/firmware/photon/#setspeed-)    
[`stretchClock()`](https://docs.particle.io/reference/firmware/photon/#stretchclock-)    
[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin--2)    
[`end()`](https://docs.particle.io/reference/firmware/photon/#end--2)    
[`isEnabled()`](https://docs.particle.io/reference/firmware/photon/#isenabled-)    
[`requestFrom()`](https://docs.particle.io/reference/firmware/photon/#requestfrom-)    
[`reset()`](https://docs.particle.io/reference/firmware/photon/#reset-)    
[`beginTransmission()`](https://docs.particle.io/reference/firmware/photon/#begintransmission-)    
[`endTransmission()`](https://docs.particle.io/reference/firmware/photon/#endtransmission-)    
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--1)    
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--2)    
[`read()`](https://docs.particle.io/reference/firmware/photon/#read--1)    
[`peek()`](https://docs.particle.io/reference/firmware/photon/#peek--1)    
[`onReceive()`](https://docs.particle.io/reference/firmware/photon/#onreceive-)    
[`onRequest()`](https://docs.particle.io/reference/firmware/photon/#onrequest-)    
Inherited [Stream](#stream) methods  

### <span id="can-canbus">CAN (CANbus)</span>

Built-in class `CANChannel`. [Details...](https://docs.particle.io/reference/firmware/photon/#can-canbus-)     

[`CANMessage`](https://docs.particle.io/reference/firmware/photon/#canmessage)    
[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin--3)    
[`end()`](https://docs.particle.io/reference/firmware/photon/#end--3)     
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--3)    
[`receive()`](https://docs.particle.io/reference/firmware/photon/#receive-)    
[`transmit()`](https://docs.particle.io/reference/firmware/photon/#transmit-)    
[`addFilter()`](https://docs.particle.io/reference/firmware/photon/#addfilter-)    
[`clearFilters()`](https://docs.particle.io/reference/firmware/photon/#clearfilters-)    
[`isEnabled()`](https://docs.particle.io/reference/firmware/photon/#isenabled--1)    
[`errorStatus()`](https://docs.particle.io/reference/firmware/photon/#errorstatus-)    

### <span id="servo">Servo</span>

Built-in class `Servo`. [Details...](https://docs.particle.io/reference/firmware/photon/#servo)     

[`attach()`](https://docs.particle.io/reference/firmware/photon/#attach-)     
[`attached()`](https://docs.particle.io/reference/firmware/photon/#attached-)    
[`detach()`](https://docs.particle.io/reference/firmware/photon/#detach-)           
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--5)    
[`writeMicroseconds()`](https://docs.particle.io/reference/firmware/photon/#writemicroseconds-)    
[`read()`](https://docs.particle.io/reference/firmware/photon/#read--4)          
[`setTrim()`](https://docs.particle.io/reference/firmware/photon/#settrim-)    

### <span id="rgb">RGB</span>

Built-in instance `RGB`. [Details...](https://docs.particle.io/reference/firmware/photon/#rgb)    

[`control()`](https://docs.particle.io/reference/firmware/photon/#control-user_control-)    
[`controlled()`](https://docs.particle.io/reference/firmware/photon/#controlled-)    
[`color()`](https://docs.particle.io/reference/firmware/photon/#color-red-green-blue-)    
[`brightness()`](https://docs.particle.io/reference/firmware/photon/#brightness-val-)    
[`onChange()`](https://docs.particle.io/reference/firmware/photon/#onchange-handler-)    

### <span id="eeprom-emulation">EEPROM Emulation</span>

Built-in instance `EEPROM`. [Details...](https://docs.particle.io/reference/firmware/photon/#eeprom)    

[`length()`](https://docs.particle.io/reference/firmware/photon/#length-)    
[`put()`](https://docs.particle.io/reference/firmware/photon/#put-)    
[`get()`](https://docs.particle.io/reference/firmware/photon/#get-)    
[`read()`](https://docs.particle.io/reference/firmware/photon/#read--5)    
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--6)    
[`clear()`](https://docs.particle.io/reference/firmware/photon/#clear-)    
[`hasPendingErase()`](https://docs.particle.io/reference/firmware/photon/#haspendingerase-)    
[`performPendingErase()`](https://docs.particle.io/reference/firmware/photon/#performpendingerase-)    

### <span id="backup-ram-sram">Backup RAM (SRAM)</span>

Backup RAM. [Details...](https://docs.particle.io/reference/firmware/photon/#backup-ram-sram-)    

* [Storing data in Backup RAM (SRAM)](https://docs.particle.io/reference/firmware/photon/#storing-data-in-backup-ram-sram-)    
* [Enabling Backup RAM (SRAM)](https://docs.particle.io/reference/firmware/photon/#enabling-backup-ram-sram-)    
* [Making changes to the layout or bytes of retained variables](https://docs.particle.io/reference/firmware/photon/#making-changes-to-the-layout-or-types-of-retained-variables)    

### <span id="application-watchdog">Application Watchdog</span>

Built-in class `ApplicationWatchdog`. [Details...](https://docs.particle.io/reference/firmware/photon/#application-watchdog)    
 
[`checkin()`](https://docs.particle.io/reference/firmware/photon/#application-watchdog)    

### <span id="time">Time</span>

Built-in instance `Time`. [Details...](https://docs.particle.io/reference/firmware/photon/#time)    

[`hour()`](https://docs.particle.io/reference/firmware/photon/#hour-)    
[`hourFormat12()`](https://docs.particle.io/reference/firmware/photon/#hourformat12-)    
[`isAM()`](https://docs.particle.io/reference/firmware/photon/#isam-)    
[`isPM()`](https://docs.particle.io/reference/firmware/photon/#ispm-)    
[`minute()`](https://docs.particle.io/reference/firmware/photon/#minute-)    
[`second()`](https://docs.particle.io/reference/firmware/photon/#second-)    
[`day()`](https://docs.particle.io/reference/firmware/photon/#day-)        
[`weekday()`](https://docs.particle.io/reference/firmware/photon/#weekday-)
[`month()`](https://docs.particle.io/reference/firmware/photon/#month-)    
[`year()`](https://docs.particle.io/reference/firmware/photon/#year-)    
[`now()`](https://docs.particle.io/reference/firmware/photon/#now-)    
[`local()`](https://docs.particle.io/reference/firmware/photon/#local-)    
[`zone()`](https://docs.particle.io/reference/firmware/photon/#zone-)    
[`setTime()`](https://docs.particle.io/reference/firmware/photon/#settime-)    
[`timeStr()`](https://docs.particle.io/reference/firmware/photon/#timestr-)    
[`format()`](https://docs.particle.io/reference/firmware/photon/#format-)    
[`setFormat()`](https://docs.particle.io/reference/firmware/photon/#setformat-)    
[`getFormat()`](https://docs.particle.io/reference/firmware/photon/#getformat-)    
[`millis()`](https://docs.particle.io/reference/firmware/photon/#millis-)    
[`micros()`](https://docs.particle.io/reference/firmware/photon/#micros-)    
[`delay()`](https://docs.particle.io/reference/firmware/photon/#delay-)    
[`delayMicroseconds()`](https://docs.particle.io/reference/firmware/photon/#delaymicroseconds-)    

### <span id="math">Math</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#math)    

[`min()`](https://docs.particle.io/reference/firmware/photon/#min-)    
[`max()`](https://docs.particle.io/reference/firmware/photon/#max-)    
[`abs()`](https://docs.particle.io/reference/firmware/photon/#abs-)    
[`constrain()`](https://docs.particle.io/reference/firmware/photon/#constrain-)    
[`map()`](https://docs.particle.io/reference/firmware/photon/#map-)    
[`pow()`](https://docs.particle.io/reference/firmware/photon/#pow-)    
[`sqrt()`](https://docs.particle.io/reference/firmware/photon/#sqrt-)    

### <span id="random-numbers">Random Numbers</span>

Built-in global functions. [Details...](https://docs.particle.io/reference/firmware/photon/#random-numbers)    

[`random()`](https://docs.particle.io/reference/firmware/photon/#random-)    
[`randomSeed()`](https://docs.particle.io/reference/firmware/photon/#randomseed-)    

### <span id="string">String</span>

Built-in class `String`. [Details...](https://docs.particle.io/reference/firmware/photon/#string-class)    

[`charAt()`](https://docs.particle.io/reference/firmware/photon/#charat-)    
[`compareTo()`](https://docs.particle.io/reference/firmware/photon/#compareto-)    
[`concat()`](https://docs.particle.io/reference/firmware/photon/#concat-)    
[`endsWith()`](https://docs.particle.io/reference/firmware/photon/#endswith-)    
[`startsWith()`](https://docs.particle.io/reference/firmware/photon/#startswith-)    
[`equals()`](https://docs.particle.io/reference/firmware/photon/#equals-)    
[`equalsIgnoreCase()`](https://docs.particle.io/reference/firmware/photon/#equalsignorecase-)    
[`format()`](https://docs.particle.io/reference/firmware/photon/#format--1)    
[`getBytes()`](https://docs.particle.io/reference/firmware/photon/#getbytes-)    
[`indexOf()`](https://docs.particle.io/reference/firmware/photon/#indexof-)    
[`lastIndexOf()`](https://docs.particle.io/reference/firmware/photon/#lastindexof-)    
[`length()`](https://docs.particle.io/reference/firmware/photon/#length--1)    
[`remove()`](https://docs.particle.io/reference/firmware/photon/#remove-)    
[`replace()`](https://docs.particle.io/reference/firmware/photon/#replace-)    
[`reserve()`](https://docs.particle.io/reference/firmware/photon/#reserve-)    
[`setCharAt()`](https://docs.particle.io/reference/firmware/photon/#setcharat-)    
[`substring()`](https://docs.particle.io/reference/firmware/photon/#substring-)    
[`toCharArray()`](https://docs.particle.io/reference/firmware/photon/#tochararray-)    
[`toFloat()`](https://docs.particle.io/reference/firmware/photon/#tofloat-)    
[`toInt()`](https://docs.particle.io/reference/firmware/photon/#toint-)    
[`toLowerCase()`](https://docs.particle.io/reference/firmware/photon/#tolowercase-)    
[`toUpperCase()`](https://docs.particle.io/reference/firmware/photon/#touppercase-)    
[`trim()`](https://docs.particle.io/reference/firmware/photon/#trim-)    

### <span id="wifi">WiFi</span>

Built-in instance `WiFi`. [Details...](https://docs.particle.io/reference/firmware/photon/#wifi)    

[`on()`](https://docs.particle.io/reference/firmware/photon/#on-)    
[`off()`](https://docs.particle.io/reference/firmware/photon/#off-)    
[`connect()`](https://docs.particle.io/reference/firmware/photon/#connect-)    
[`disconnect()`](https://docs.particle.io/reference/firmware/photon/#disconnect-)    
[`connecting()`](https://docs.particle.io/reference/firmware/photon/#connecting-)    
[`ready()`](https://docs.particle.io/reference/firmware/photon/#ready-)    
[`selectAntenna()`](https://docs.particle.io/reference/firmware/photon/#selectantenna-)    
[`listen()`](https://docs.particle.io/reference/firmware/photon/#listen-)    
[`listening()`](https://docs.particle.io/reference/firmware/photon/#listening-)    
[`setCredentials()`](https://docs.particle.io/reference/firmware/photon/#setcredentials-)    
[`getCredentials()`](https://docs.particle.io/reference/firmware/photon/#getcredentials-)    
[`clearCredentials()`](https://docs.particle.io/reference/firmware/photon/#clearcredentials-)    
[`hasCredentials()`](https://docs.particle.io/reference/firmware/photon/#hascredentials-)    
[`macAddress()`](https://docs.particle.io/reference/firmware/photon/#macaddress-)    
[`SSID()`](https://docs.particle.io/reference/firmware/photon/#ssid-)    
[`BSSID()`](https://docs.particle.io/reference/firmware/photon/#bssid-)    
[`RSSI()`](https://docs.particle.io/reference/firmware/photon/#rssi-)    
[`ping()`](https://docs.particle.io/reference/firmware/photon/#ping-)    
[`scan()`](https://docs.particle.io/reference/firmware/photon/#scan-)    
[`resolve()`](https://docs.particle.io/reference/firmware/photon/#resolve-)        
[`localIP()`](https://docs.particle.io/reference/firmware/photon/#localip-)
[`subnetMask()`](https://docs.particle.io/reference/firmware/photon/#subnetmask-)    
[`gatewayIP()`](https://docs.particle.io/reference/firmware/photon/#gatewayip-)    
[`dnsServerIP()`](https://docs.particle.io/reference/firmware/photon/#dnsserverip-)    
[`dhcpServerIP()`](https://docs.particle.io/reference/firmware/photon/#dhcpserverip-)    
[`setStaticIP()`](https://docs.particle.io/reference/firmware/photon/#setstaticip-)    
[`useStaticIP()`](https://docs.particle.io/reference/firmware/photon/#usestaticip-)    
[`useDynamicIP()`](https://docs.particle.io/reference/firmware/photon/#usedynamicip-)    

### <span id="ipaddress">IPAddress</span>

Built-in class `IPAddress`. [Details...](https://docs.particle.io/reference/firmware/photon/#ipaddress)    

[`=`](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[`==`](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[`!=`](https://docs.particle.io/reference/firmware/photon/#ipaddress)    
[`[]`](https://docs.particle.io/reference/firmware/photon/#ipaddress)    

### <span id="tcpserver">TCPServer</span>

Built-in class `TCPServer`. [Details...](https://docs.particle.io/reference/firmware/photon/#tcpserver)    

[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin--4)    
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--4)    
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--2)    
[`print()`](https://docs.particle.io/reference/firmware/photon/#print--1)    
[`println()`](https://docs.particle.io/reference/firmware/photon/#println--1)    

### <span id="tcpclient">TCPClient</span>

Built-in class `TCPClient`. [Details...](https://docs.particle.io/reference/firmware/photon/#tcpclient)    

[`connect()`](https://docs.particle.io/reference/firmware/photon/#connect--1)    
[`connected()`](https://docs.particle.io/reference/firmware/photon/#connected-)    
[`stop()`](https://docs.particle.io/reference/firmware/photon/#stop-)     
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--3)    
[`print()`](https://docs.particle.io/reference/firmware/photon/#print--2)    
[`println()`](https://docs.particle.io/reference/firmware/photon/#println--2)    
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--5)    
[`read()`](https://docs.particle.io/reference/firmware/photon/#read--2)    
[`flush()`](https://docs.particle.io/reference/firmware/photon/#flush--1)    
[`remoteIP()`](https://docs.particle.io/reference/firmware/photon/#remoteip-)     
Inherited [Stream](#stream) methods   

### <span id="udp">UDP</span>

Built-in class `UDP`. [Details...](https://docs.particle.io/reference/firmware/photon/#udp)    
  
[`begin()`](https://docs.particle.io/reference/firmware/photon/#begin--5)    
[`stop()`](https://docs.particle.io/reference/firmware/photon/#stop--1)     
[`available()`](https://docs.particle.io/reference/firmware/photon/#available--6)    
[`beginPacket()`](https://docs.particle.io/reference/firmware/photon/#beginpacket-)     
[`endPacket()`](https://docs.particle.io/reference/firmware/photon/#endpacket-)    
[`sendPacket()`](https://docs.particle.io/reference/firmware/photon/#sendpacket-)    
[`parsePacket()`](https://docs.particle.io/reference/firmware/photon/#parsepacket-)      
[`write()`](https://docs.particle.io/reference/firmware/photon/#write--4)      
[`read()`](https://docs.particle.io/reference/firmware/photon/#read--3)        
[`remoteIP()`](https://docs.particle.io/reference/firmware/photon/#remoteip--1)    
[`remotePort()`](https://docs.particle.io/reference/firmware/photon/#remoteport-)    
[`setBuffer()`](https://docs.particle.io/reference/firmware/photon/#setbuffer-)    
[`releaseBuffer()`](https://docs.particle.io/reference/firmware/photon/#releasebuffer-)        
[`joinMulticast()`](https://docs.particle.io/reference/firmware/photon/#joinmulticast-)    
[`leaveMulticast()`](https://docs.particle.io/reference/firmware/photon/#leavemulticast-)    
Inherited [Stream](#stream) methods 

### <span id="stream">Stream</span>

Built-in class `Stream`, inherited by `Serial`, `Wire`, `TCPClient` and `UDP`. [Details...](https://docs.particle.io/reference/firmware/photon/#stream-class)    

[`setTimeout()`](https://docs.particle.io/reference/firmware/photon/#settimeout-)    
[`find()`](https://docs.particle.io/reference/firmware/photon/#find-)    
[`findUntil()`](https://docs.particle.io/reference/firmware/photon/#finduntil-)    
[`readBytes()`](https://docs.particle.io/reference/firmware/photon/#readbytes-)    
[`readBytesUntil()`](https://docs.particle.io/reference/firmware/photon/#readbytesuntil-)    
[`readString()`](https://docs.particle.io/reference/firmware/photon/#readstring-)    
[`readStringUntil()`](https://docs.particle.io/reference/firmware/photon/#readstringuntil-)    
[`parseInt()`](https://docs.particle.io/reference/firmware/photon/#parseint-)    
[`parseFloat()`](https://docs.particle.io/reference/firmware/photon/#parsefloat-)    

### <span id="softap-http-pages">SoftAP HTTP Pages</span>

SoftAP HTTP pages. [Details...](https://docs.particle.io/reference/firmware/photon/#softap-http-pages)

* [The page callback function](https://docs.particle.io/reference/firmware/photon/#the-page-callback-function)    
* [Retrieving the request data](https://docs.particle.io/reference/firmware/photon/#retrieving-the-request-data)    
* [Sending a response](https://docs.particle.io/reference/firmware/photon/#sending-a-response)    
* [The default page](https://docs.particle.io/reference/firmware/photon/#the-default-page)    
* [Sending a Redirect](https://docs.particle.io/reference/firmware/photon/#sending-a-redirect)    

### <span id="cloud-functions">Cloud Functions</span>

Built-in instance `Particle`. [Details...](https://docs.particle.io/reference/firmware/photon/#cloud-functions)    

[`connect()`](https://docs.particle.io/reference/firmware/photon/#particle-connect-)    
[`connected()`](https://docs.particle.io/reference/firmware/photon/#particle-connected-)    
[`process()`](https://docs.particle.io/reference/firmware/photon/#particle-process-)    
[`disconnect()`](https://docs.particle.io/reference/firmware/photon/#particle-disconnect-)    
[`variable()`](https://docs.particle.io/reference/firmware/photon/#particle-variable-) - Expose a variable through the Cloud so that it can be called with **GET** method     
[`function()`](https://docs.particle.io/reference/firmware/photon/#particle-function-) - Expose a function through the Cloud so that it can be called with **POST** method     
[`publish()`](https://docs.particle.io/reference/firmware/photon/#particle-publish-) - Publish an event through the Particle Cloud that will be forwarded to all registered listeners    
[`subscribe()`](https://docs.particle.io/reference/firmware/photon/#particle-subscribe-) - Subscribe to events published by devices    
[`unsubscribe()`](https://docs.particle.io/reference/firmware/photon/#particle-unsubscribe-) - Removes all subscription handlers previously registered with `Particle.subscribe()`    
[`syncTime()`](https://docs.particle.io/reference/firmware/photon/#particle-synctime-)    

* [Get Public IP](https://docs.particle.io/reference/firmware/photon/#get-public-ip)    
* [Get Device name](https://docs.particle.io/reference/firmware/photon/#get-device-name)    
* [Get Random seed](https://docs.particle.io/reference/firmware/photon/#get-random-seed)    

### <span id="system-calls">System Calls</span>

Built-in instance `System`. [Details...](https://docs.particle.io/reference/firmware/photon/#system-calls)    

[`version()`](https://docs.particle.io/reference/firmware/photon/#version-)    
[`versionNumber()`](https://docs.particle.io/reference/firmware/photon/#versionnumber-)    
[`buttonPushed()`](https://docs.particle.io/reference/firmware/photon/#buttonpushed-)    
[`ticks()`](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[`ticksPerMicrosecond()`](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[`ticksDelay()`](https://docs.particle.io/reference/firmware/photon/#system-cycle-counter)    
[`freeMemory()`](https://docs.particle.io/reference/firmware/photon/#freememory-)    
[`dfu()`](https://docs.particle.io/reference/firmware/photon/#dfu-)    
[`deviceID()`](https://docs.particle.io/reference/firmware/photon/#deviceid-)    
[`enterSafeMode()`](https://docs.particle.io/reference/firmware/photon/#entersafemode-)    
[`sleep()`](https://docs.particle.io/reference/firmware/photon/#sleep-sleep-)    
[`reset()`](https://docs.particle.io/reference/firmware/photon/#reset--2)    
[`on()`](https://docs.particle.io/reference/firmware/photon/#system-events-overview) - register a system event handler    
[`enableUpdates()`](https://docs.particle.io/reference/firmware/photon/#system-enableupdates-)    
[`disableUpdates()`](https://docs.particle.io/reference/firmware/photon/#system-disableupdates-)     
[`updatesEnabled()`](https://docs.particle.io/reference/firmware/photon/#system-updatesenabled-)    
[`updatesPending()`](https://docs.particle.io/reference/firmware/photon/#system-updatespending-)    

### <span id="system-modes">System Modes</span>

System modes. [Details...](https://docs.particle.io/reference/firmware/photon/#system-modes)

[`SYSTEM_MODE()`](https://docs.particle.io/reference/firmware/photon/#system-modes) - default to `AUTOMATIC` mode        

- [`AUTOMATIC`](https://docs.particle.io/reference/firmware/photon/#automatic-mode): Automatically try to connect to Wi-Fi and the Particle Cloud and handle the cloud messages.    
- [`SEMI_AUTOMATIC`](https://docs.particle.io/reference/firmware/photon/#semi-automatic-mode): Manually connect to Wi-Fi and the Particle Cloud, but automatically handle the cloud messages.    
- [`MANUAL`](https://docs.particle.io/reference/firmware/photon/#manual-mode): Manually connect to Wi-Fi and the Particle Cloud and handle the cloud messages.

### <span id="system-thread">System Thread</span>

System thread. [Details...](https://docs.particle.io/reference/firmware/photon/#system-thread)

[`SYSTEM_THREAD()`](https://docs.particle.io/reference/firmware/photon/#system-thread)    
[`SINGLE_THREADED_BLOCK()`](https://docs.particle.io/reference/firmware/photon/#single_threaded_block-)    
[`AUTOMIC_BLOCK()`](https://docs.particle.io/reference/firmware/photon/#atomic_block-)    

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

[`STARTUP()`](https://docs.particle.io/reference/firmware/photon/#startup-)    
[`PRODUCT_ID()`](https://docs.particle.io/reference/firmware/photon/#product_id-)    

### <span id="other-functions">Other Functions</span>

Note that most of the functions in newlib described at [https://sourceware.org/newlib/libc.html](https://sourceware.org/newlib/libc.html) are available for use in addition to the functions outlined above.

### <span id="external-spi-flash">External SPI Flash</span> 

The Duo is soldered with an external non-volatile SPI flash, which memory is up to 2MB and every sector is made up of 4K bytes. But only the first 768KB (192 sectors) are available for user use, the rest memory space are reserved for system use, see the [Firmware Architecture Overview](firmware_architecture_overview.md).

Built-in instance `sFLASH`.      

[`eraseSector()`](#erasesector)      
[`writeBuffer()`](#writebuffer)    
[`readBuffer()`](#readbuffer)    
[`selfTest()`](#selftest)

##### <span id="erasesector">`eraseSector()`</span> 

This method erases a given sector of the external flash. The pass in parameter `uint32_t SectorAddr` can be any of the address as long as it is located in the sector, i.e. the sector you are going to erase is (`SectorAddr >> 3`). Operation to the reserved sectors makes no effect.
 
```      
// Erase the sector 18.
sFLASH.eraseSector(0x12000); 
    
// It will also erase the sector 18.
sFLASH.eraseSector(0x12345);

// Erase the sector 103.
sFLASH.eraseSector(0x67890);     
```

##### <span id="writebuffer">`writeBuffer()`</span>   

This method stores a bulk of data to the external flash. The data is stored from a given address and the address grows automatically after one byte is stored. If the address reaches the end address of the available memory, the rest data will be aborted.

It should pass in three parameters:    

* `const uint8_t *pBuffer` The buffer that contains the data to be stored.
* `uint32_t WriteAddr` The begining address from which to store the data.
* `uint32_t NumByteToWrite` The number of bytes to be stored.

*Note: The memory space you are going to store the data must has been well erased before, or the data you read out afterwards might not the same as you wrote.*

```
uint8_t buf[256] = { 0x55 };
    
// Store first 128 bytes of the buf to external flash from address 0.
sFLASH.writeBuffer( buf, 0, 128 );
```

##### <span id="readbuffer">`readBuffer()`</span>

This method reads specified length of data from a given address of the external flash. The reserved memory space can not be read out using this method.

It should pass in three parameters:   

* `uint8_t *pBuffer` The buffer that to hold the data being read out.
* `uint32_t ReadAddr` The begining address from which to read out the data.
* `uint32_t NumByteToRead` The number of bytes you want to read out.

```
uint8_t buf[256];

// Read 128 bytes from address 0 of the external flash to the buf.    
sFLASH.readBuffer( buf, 0, 128 );
```

##### <span id="selftest">`selfTest()`</span>

Check if the external flash functions well or not. It returns 0 if success, otherwise return -1.

```
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
```

### <span id="bluetooth-low-energy-ble">Bluetooth Low Energy (BLE)</span> 

Built-in instance `ble`.     

General methods:    
[`init()`](#init)    
[`deInit()`](#deinit)    
[`setTimer()`](#settimer)    
[`setTimerHandler()`](#settimerhandler)    
[`addTimer()`](#addtimer)     
[`removeTimer()`](#removetimer)    
[`getTimeMs()`](#gettimems)    
[`debugLogger()`](#debuglogger)    
[`debugError()`](#debugerror)    
[`enablePacketLogger()`](#enablepacketlogger)    
[`setRandomAddrMode()`](#setrandomaddrmode)    
[`setRandomAddr()`](#setrandomaddr)    
[`setPublicBDAddr()`](#setpublicbdaddr)    
[`getLocalBdAddr()`](#getlocalbdaddr)    
[`onConnectedCallback()`](#onconnectedcallback)    
[`onDisconnectedCallback()`](#ondisconnectedcallback)    

BLE Central role methods:    
[`setScanParams()`](#setscanparams)    
[`startScanning()`](#startscanning)    
[`stopScanning()`](#stopscanning)    
[`getAddrOfAdvertisement()`](#getaddrofadvertisement)    
[`connect()`](#connect)    
[`disconnect()`](#disconnect)    
[`discoverPrimaryServices()`](#discoverprimaryservices)    
[`discoverCharacteristics()`](#discovercharacteristics)    
[`discoverCharacteristicDescriptors()`](#discovercharacteristicdescriptors)    
[`readValue()`](#readvalue)    
[`readLongValue()`](#readlongvalue)    
[`readLongValueWithOffset()`](#readlongvaluewithoffset)    
[`writeValueWithoutResponse()`](#writevaluewithoutresponse)    
[`writeValue()`](#writevalue)    
[`writeLongValue()`](#writelongvalue)    
[`writeLongValueWithOffset()`](#writelongvaluewithoffset)    
[`readDescriptorValue()`](#readdescriptorvalue)    
[`readLongDescriptorValue()`](#readlongdescriptorvalue)    
[`readLongDescriptorValueWithOffset()`](#readlongdescriptorvaluewithoffset)    
[`writeDescriptorValue()`](#writedescriptorvalue)    
[`writeLongDescriptorValue()`](#writelongdescriptorvalue)    
[`writeLongDescriptorValueWithOffset()`](#writelongdescriptorvaluewithoffset)    
[`writeClientCharsConfigDescriptor()`](#writeclientcharsconfigdescriptor)    
[`onScanReportCallback()`](#onscanreportcallback)    
[`onServiceDiscoveredCallback()`](#onservicediscoveredcallback)    
[`onCharacteristicDiscoveredCallback()`](#oncharacteristicdiscoveredcallback)    
[`onDescriptorDiscoveredCallback()`](#ondescriptordiscoveredcallback)    
[`onGattCharacteristicReadCallback()`](#ongattcharacteristicreadcallback)    
[`onGattCharacteristicWrittenCallback()`](#ongattcharacteristicwrittencallback)    
[`onGattDescriptorReadCallback()`](#ongattdescriptorreadcallback)    
[`onGattDescriptorWrittenCallback()`](#ongattdescriptorwrittencallback)    
[`onGattWriteClientCharacteristicConfigCallback()`](#ongattwriteclientcharacteristicconfigcallback)    
[`onGattNotifyUpdateCallback()`](#ongattnotifyupdatecallback)    
[`onGattIndicateUpdateCallback()`](#ongattindicateupdatecallback)  

BLE Peripheral role methods:    
[`addService()`](#addservice)    
[`addCharacteristic()`](#addcharacteristic)     
[`addCharacteristicDynamic()`](#addcharacteristicdynamic)    
[`setLocalName()`](#setlocalname)    
[`setConnParams()`](#setconnparams)    
[`setAdvertisementParams()`](#setadvertisementparams)    
[`setAdvertisementData()`](#setadvertisementdata)    
[`setScanResponseData()`](#setscanresponsedata)    
[`startAdvertising()`](#startadvertising)    
[`stopAdvertising()`](#stopadvertising)    
[`attServerCanSendPacket()`](#attservercansendpacket)    
[`sendNotify()`](#sendnotify)    
[`sendIndicate()`](#sendindicate)    
[`onDataReadCallback()`](#ondatareadcallback)    
[`onDataWriteCallback()`](#ondatawritecallback)    

##### <span id="init">`init()`</span> 

Initialize the BLE HCI interface and the controller state. It creates a thread to deal with the HCI commands and events. It **MUST** be called before calling any other BLE methods.

```
// Initialize BLE HCI interface and the controller
ble.init()
```
  

## Support

* [RedBear Discussion](http://discuss.redbear.cc)
* [Particle Community](https://community.particle.io)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.