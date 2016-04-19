# JavaScript #

*Note: Only system firmware version v0.2.3 supports running JS engine for now*

View source code: [Espruino for the Duo](https://github.com/redbear/Espruino).


## How to play ##

* Please use DFU-UTIL to update system firmware to v0.2.3 and load the binary file to the Duo's user-part.Here is the [Guide](https://github.com/redbear/Duo/blob/master/firmware/README.md).

* Download and use the [Espruino Web IDE](https://chrome.google.com/webstore/detail/espruino-web-ide) to play.

	![image](espruino_web_ide.png)

* To upload to the RAM space of the Duo

	* Start the Espruino Web IDE
	* Write your JavaScript and upload to the board using the **`Send to Esrpruino`** button

	    *Sample JavaScript: Using JavaScript to blink the LED on the Duo.*     
		
            var on = true;

		    function toggle() {
  			  on = !on;
  			  digitalWrite(LED4, on); // LED4 is the blue LED near to the reset button.
		    }

		    var interval = setInterval(toggle, 300);


* To save the script to the EEPROM of the Duo, you can use the commnad `save()`.

## Console Interfaces ##

The default console is mapped to Duo's on-board USB, and UART1, which enables you to interact with WebIDE using RBLink. 

After power on, Duo's BLE is activated and begin advertising as "Duo JS Interpreter". If you connect your smart device to Duo, then the condole is moved to Bluetooth. There is a UART service containing two characteristics, one for sending JS command and one for echoing the JS interpreter status.

If you have stored WiFi credentials before, after power on, the Duo will try connecting to the stored AP for 3 times. If connection created, then Duo will start the "Telnet" serve. In fact, it is simply a TCP server listening on part 23, since the Telnet protocol is not implemented for now. You can connect a TCP client to the "Telnet" server and then the console is moved to "Telnet" client, which also allows you to send JS command and echo the JS interpreter status for you. However, if the Duo hasn't stored any credentials, after power on the WiFi is turn off by default. If the Duo can not connect to AP within the 3 times retries, it will turn off the WiFi as well.


## Reference

The bellowing functions, classes and libraries are mostly implemented and some need to be tested.

* [Global functions](http://www.espruino.com/Reference#_global)
* [Array](http://www.espruino.com/Reference#t_Array)
* [ArrayBuffer](http://www.espruino.com/Reference#ArrayBuffer)
* [ArrayBuffer View](http://www.espruino.com/Reference#ArrayBufferView)
* [Boolean](http://www.espruino.com/Reference#Boolean)
* [console](http://www.espruino.com/Reference#Boolean)
* [Crypto](http://www.espruino.com/Reference#crypto)
* [Date](http://www.espruino.com/Reference#Date)
* [Espruino built-in](http://www.espruino.com/Reference#E)
* [Error](http://www.espruino.com/Reference#Error)
* [Flash](http://www.espruino.com/Reference#Flash)
* [Float32Array](http://www.espruino.com/Reference#Float32Array)
* [Float64Array](http://www.espruino.com/Reference#Float64Array)
* [Function](http://www.espruino.com/Reference#Function)
* [HASH](http://www.espruino.com/Reference#HASH)
* [hashlib](http://www.espruino.com/Reference#hashlib)
* [http](http://www.espruino.com/Reference#http)
* [httpCRq](http://www.espruino.com/Reference#httpCRq)
* [httpCRs](http://www.espruino.com/Reference#httpCRs)
* [httpSRq](http://www.espruino.com/Reference#httpSRq)
* [httpSRs](http://www.espruino.com/Reference#httpSRs)
* [httpSrv](http://www.espruino.com/Reference#httpSrv)
* [I2C](http://www.espruino.com/Reference#I2C)
* [Int8Array](http://www.espruino.com/Reference#Int8Array)
* [Int16Array](http://www.espruino.com/Reference#Int16Array)
* [Int32Array](http://www.espruino.com/Reference#Int32Array)
* [InternalError](http://www.espruino.com/Reference#InternalError)
* [JSON](http://www.espruino.com/Reference#JSON)
* [Math](http://www.espruino.com/Reference#Math)
* [Modules](http://www.espruino.com/Reference#Modules)
* [net](http://www.espruino.com/Reference#net)
* [NetworkJS](http://www.espruino.com/Reference#NetworkJS)
* [Number](http://www.espruino.com/Reference#Number)
* [Object](http://www.espruino.com/Reference#Object)
* [OneWire](http://www.espruino.com/Reference#OneWire) - Not tested yet
* [Pin](http://www.espruino.com/Reference#Pin)
* [process](http://www.espruino.com/Reference#process)
* [ReferenceError](http://www.espruino.com/Reference#ReferenceError)
* [Serial](http://www.espruino.com/Reference#Serial)
* [Server](http://www.espruino.com/Reference#Server)
* [Socket](http://www.espruino.com/Reference#Socket)
* [SPI](http://www.espruino.com/Reference#SPI)
* [String](http://www.espruino.com/Reference#String)
* [SyntaxError](http://www.espruino.com/Reference#SyntaxError)
* [Telnet](http://www.espruino.com/Reference#Telnet)
* [TypeError](http://www.espruino.com/Reference#TypeError)
* [Uint8Array](http://www.espruino.com/Reference#Uint8Array)
* [Uint16Array](http://www.espruino.com/Reference#Uint16Array)
* [Uint32Array](http://www.espruino.com/Reference#Uint32Array)
* [Uint8ClampedArray](http://www.espruino.com/Reference#Uint8ClampedArray)
* [url](http://www.espruino.com/Reference#url)
* [Waveform](http://www.espruino.com/Reference#Waveform)


## Duo specified functions, classes and libraries##

### WiFi Class ###

The WiFi class for Duo is different from which is printed on the Espruino Reference site.

- **WiFi.on()** - static method    
Turn on WiFi but do not connect to AP. It should be called as least once before you calling other WiFi relatived methods. Error will be caught if you are trying to call other methods while WiFi is off.

- **WiFi.off()** - static method      
Turn off WiFi. It will close all of the sockets and disconnect from AP if them are presented.

- **WiFi.connect()** - static method      
Connect the Duo to AP. It will turn on WiFi first if WiFi is off and then try connecting to the APs which credentials have been stored before. If connection is failed, Duo will turn off WiFi. Error will be caught if no credentials are stored in Duo.

- **WiFi.disconnect()** - static method      
Disconnect the Duo from Ap. It will close all of the sockets if they are presented.

- **WiFi.isReady(JsVar \*jsCallback)** - static method    
Check if the Duo has connected to an Ap, which means that the Duo has obtained IP address from AP. The callback function is optional. If the callback is presented, it will be called with a JS boolean varialbe passing in, which indicates the result of the method.

- **WiFi.details(JsVar \*jsCallback)** - static method    
Fetch the details when the Duo is connecting to an AP, including SSID, gateway IP, Duo IP etc. Error will be caught if Duo is not in connection with AP. The callback is optional. If the callback is presented, it will be called with a JS object passing in, which including the details.

- **WiFi.setCredential( {...} )** - static method    
Store a WiFi credential which to be used when Duo tries connecting to AP. Duo is capable of storing up to 5 credentials. If you are going to store a new credential while 5 credentials is tored, the oldest one will be replaced. If the SSID of the credential you are going to set is the same with certain stored credential's, only the password and security will be replaced. Error will be caught if WiFi is off. Thus, you need to turn on WiFi first. The parameter is a JS object, which including the credential info. For instance:    

        WiFi.setCredential( {"ssid:":"YOUR_AP_SSID", "password":"YOUR_AP_PASSWORD", "sec":"WPA2", "cipher":"AES"} )  
The security value of `"sec"` key is limited to one of the bellowing string:   
 
        "UNSEC" //Open 
        "WEP"   
        "WPA"   
        "WPA2"  
The cipher value of `"cipher"` key is limited to one of the belowing string:

        "AES"
        "TKIP"
        "AES_TKIP"
If the `"password"` is not present, then the security is treated as open.    
If the `"sec"` is not present, then the security is treated as open.   
If the `"cipher"` is not present, then the cipher is default to unset.   

- **WiFi.getCredentials(JsVar \*jsCallback)** - static method      
Fetch the all stored credentials details, including SSID and security. Error will be caught if no credentials stored. The callback is optional. If the callback is presented, it will be called with a JS object passing in, which including the credentials' details.  

- **WiFi.clearCredentials()** - static method    
Clear all of the stored credentials.

- **WiFi.resolve(JsVar \*jsHostName)** - static method
Resolve the host name being passed in. The host name should be JS string.

- **WiFi.ping(JsVar \*jsDestIP, JsVar \*jsnTries)** -static method    
Ping to the specified host. Error will be caught if Duo is not in connection with AP. For instance, try pinging to `192.168.1.1` with 5 times attempts: 

        WiFi.ping("192.168.1.1", 5);

- **WiFi.scan(JsVar \*jsCallback)** - static method    
Scan the nearby AP. It will print each AP's SSID, security and RSSI. Error will be caught if WiFi is off. The callback is optional. If the callback is presented, it will be called with a JS object passing in, which including the scanned AP details.  


### BLE Class ###

The BLE class for Duo is different from which is printed on the Espruino Reference site.  

- **RBLE.sleep()** - static method    
Make Duo stop advertising.

- **RBLE.wake()** - static method
Make Duo start advertising again.


