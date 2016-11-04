# Duo: WiFi / BLE / USBSerial Setup Protocol in Listening Mode
---

If the Duo is running Particle firmware (by default out-of-box), it has several [device modes](https://docs.particle.io/guide/getting-started/modes/photon/). One of the device modes is [Listening Mode](https://docs.particle.io/guide/getting-started/modes/photon/#listening-mode), in which the Duo will act as SoftAP and BLE peripheral, both broadcasting the name in the format "Duo-xxxx", where "xxxx" varies from different Duos. During in the Listening mode, you can follow the protocol defined here to send command to fetch informations and configure the Duo.

One of the following conditions will force the Duo enter Listening Mode:

1. By holding the SETUP button for three seconds, until the RGB LED begins blinking blue.

2. If no WiFi credentials stored and the Duo wants to connect to AP. To clear WiFi credentials:

    * Hold the SETUP button for about ten seconds, until the RGB LED blinks **blue** rapidly.
    * Hold the SETUP button and tapping RESET, then continuing to hold SETUP until the on-board RGB turns **white**.
    * Call the [`WiFi.clearCredentials()`](https://docs.particle.io/reference/firmware/photon/#clearcredentials-) in user application.

3. Request by calling the [`WiFi.listen()`](https://docs.particle.io/reference/firmware/photon/#listen-) in user application.

**Note :** When the Duo is in the Listening Mode, if [multithreading](https://docs.particle.io/reference/firmware/photon/#system-thread) is not used, neither the system event loop running backstage nor user application will continue, untill the Listening Mode exits. If multithreading is used, the system event loop running backstage will be blocked untill the Listening Mode exits, while the user application executes normally.

To exit Listening Mode, one of the following conditions must be satisfied:

1. WiFi credentials is configured if using USB serial.

2. "connect-ap" command is received if using WiFi or BLE

3. "finish-update" command is recieved is using WiFi (Duo only)

4. `WiFi.listen(false)` is called in user application only if multithreading is used


## <span id="wifi-softap">WiFi SoftAP</span>

As described above, when the Duo is in the Listening Mode, it will broadcast as an open SoftAP, wich SSID is "Duo-xxxx" and IP address is 192.168.0.1. At meantime, the Duo starts a TCP server listening on port 5609 and a HTTP server listening on port 80. Then you can connect your mobile phone, laptop or host PC to this SoftAP and start a TCP client or use web brower to communicate with Duo by following the protocol defined here. 

##### TCP/5609 :

Request string :

`command_name\n(parameter_length)\n\n[parameter]`

- The parameter length is essential, while the parameter is optional.
- If parameter is required, it must be of JSON format.
  
Response:

- A JSON string contains the response data.

**Note :** one request / response pair per socket connection.

##### HTTP/80 :

Request :

`http://192.168.0.8/command_name`

- Commands with no data are sent as a GET.
- Commands that require data (e.g. configure-ap) are sent as POST, with the data in the request body

Response :

- Response is sent as the response body and in the JSON format.

### Supported Commands

#### Fetch firmware versions

  - Command name : `version`
  - Response string (e.g.) : `{"release string":"0.2.4","bootloader":4,"system part1":7,"system part2":7,"user part":7}`

#### Fetch device ID

  - Command name : `device-id`
  - Response string (e.g.) : `{"id":"112233445566778899001122","c":"1"}`
  
Description:

**id** : is the unique ID for the device.

**c** : is the claimed flag. "1" if the device has previously been claimed. "0" if the device has never been claimed before. The device is flagged as claimed after a claim ID has been set (see the `set` command below) and
the device has successfully connected to the cloud.  

#### Scan nearby Access Points

  - Command name : `scan-ap`
  - Response string (e.g.) : `{"scans":[{"ssid":"ssid-name","rssi":-30,"sec":value,"ch":value,"mdr":value},{result 1},{...},{result n}]}`

Description:

**sec** : describes the security configuration of the scanned AP. It's an enum with one of the following values:

	enum Security {
	    SECURITY_OPEN           = 0;          /**< Unsecured                               */
	    SECURITY_WEP_PSK        = 1;     	  /**< WEP Security with open authentication   */
	    SECURITY_WEP_SHARED     = 0x8001;     /**< WEP Security with shared authentication */
	    SECURITY_WPA_TKIP_PSK   = 0x00200002; /**< WPA Security with TKIP                  */
	    SECURITY_WPA_AES_PSK    = 0x00200004; /**< WPA Security with AES                   */
	    SECURITY_WPA2_AES_PSK   = 0x00400004; /**< WPA2 Security with AES                  */
	    SECURITY_WPA2_TKIP_PSK  = 0x00400002; /**< WPA2 Security with TKIP                 */
	    SECURITY_WPA2_MIXED_PSK = 0x00400006; /**< WPA2 Security with AES & TKIP           */
	}

**mdr** : is maximum data rate for the SSID in kbits/s.

#### Configure WiFi credential

  - Command name : `configure-ap`
  - Parameter : `{"idx":index,"ssid":"my-ssid","pwd":"hex-encoded pwd","sec":value,"ch":value}`
  - Response string (e.g.) : `{"r":0}`

Description:

**idx** : The value of it in the parameter doesn't matter.
  
**ch** : The value of it in the parameter doesn't matter.

**pwd** : 256-bytes ascii hex-encoded string which carries the WiFi password (no greater than 64 characters). If the password is empty, the pwd attribute can be omitted. The plain password is then RSA encrypted with PKCS#1 padding scheme using the device's public key. The encrypted 128-bytes are then ascii hex-encoded, with the most significant nibble (4-bits) first, followed by the lest significant nibble. For example, the encryted 128-bytes `A10322983F...` in Hexadecimal would be encoded as 256 characters `"A10322983F..."`.

**sec** : describes the security configuration of the specified AP. It's an enum with one of the following values:

	enum Security {
	    SECURITY_OPEN           = 0;          /**< Unsecured                               */
	    SECURITY_WEP_PSK        = 1;     	  /**< WEP Security with open authentication   */
	    SECURITY_WEP_SHARED     = 0x8001;     /**< WEP Security with shared authentication */
	    SECURITY_WPA_TKIP_PSK   = 0x00200002; /**< WPA Security with TKIP                  */
	    SECURITY_WPA_AES_PSK    = 0x00200004; /**< WPA Security with AES                   */
	    SECURITY_WPA2_AES_PSK   = 0x00400004; /**< WPA2 Security with AES                  */
	    SECURITY_WPA2_TKIP_PSK  = 0x00400002; /**< WPA2 Security with TKIP                 */
	    SECURITY_WPA2_MIXED_PSK = 0x00400006; /**< WPA2 Security with AES & TKIP           */
	}


## <span id="ble-peripheral">BLE Peripheral</span>




## <span id="usb-serial">USB Serial</span>




## <span id="references">References</span>

* [Duo Introduction](duo_introduction.md)
* [Arduino/C/C++ Programming Reference Manual](programming_reference_manual.md)
* [Firmware Architecture Overview](firmware_architecture_overview.md)
* [How It Works](how_it_works.md)
* [Windows Driver Installation Guide](windows_driver_installation_guide.md)
* [RedBear Discussion Forum](http://discuss.redbear.cc/)


## <span id="resources">Resources</span>

* [Modified Particle firmware Source Code](https://github.com/redbear/firmware)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
