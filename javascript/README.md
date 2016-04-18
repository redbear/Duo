# JavaScript

*Note: Only system firmware version v0.2.3 supports running JS engine for now*

## Features

* Source code: [Espruino for the Duo](https://github.com/redbear/Espruino).
* Digital Pin functions (use MCU pinout, e.g. the onboard LED is on pin 13)
* PWM
* Analog Read/Write
* Watch pin interrupt
* Timer (setInterval / setTime / setTimeout)
* Save script to internal flash (EEPROM)
* SPI
* I2C
* WiFi
* BLE


## How to play

* Please use DFU-UTIL to update system firmware to v0.2.3 and load the binary file to the Duo's user-part.[Guide](https://github.com/redbear/Duo/blob/master/firmware/README.md)

* Download and use the [Espruino Web IDE](https://chrome.google.com/webstore/detail/espruino-web-ide) to play

	https://chrome.google.com/webstore/detail/espruino-web-ide

	![image](espruino_web_ide.png)

* To upload to the RAM space of the Duo

	* Start the Espruino Web IDE
	* Write your JavaScript and upload to the board using the **`Send to Esrpruino`** button
	* Sample JavaScript
	
```			
		/*
 		 *
 		 *    Using JavaScript to blink the LED on the Duo.
 		 *
		 */

		var on = true;

		function toggle() {
  			on = !on;
  			digitalWrite(13, on);
		}

		var interval = setInterval(toggle, 300);
```

* To save the script to the EEPROM of the Duo, you can use the commnad `save()`.


