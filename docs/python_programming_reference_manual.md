# Duo: Python Programming Reference Manual
---

The RedBear Duo is pre-installed the Particle firmware, which enables user develop their applications based on built-in functions and classes. The Python interpreter for Duo is migrated from [MicroPython](http://www.micropython.org/) –– "a lean and efficient implementation of the Python 3 programming language that includes a small subset of the Python standard library and is optimised to run on microcontrollers and in constrained environments." Actually, the Python interpreter is a user application based on the Particle firmware. 

For more information about the Duo and Particle firmware, please refer to:

[https://github.com/redbear/Duo](https://github.com/redbear/Duo)


## Index

### [Python standard libraries and micro-libraries](http://docs.micropython.org/en/latest/pyboard/library/index.html#python-standard-libraries-and-micro-libraries)

* [Builtin Functions](http://docs.micropython.org/en/latest/pyboard/library/builtins.html)
* [**`array`**](http://docs.micropython.org/en/latest/pyboard/library/array.html) – arrays of numeric data
* [**`cmath`**](http://docs.micropython.org/en/latest/pyboard/library/cmath.html) – mathematical functions for complex numbers
* [**`gc`**](http://docs.micropython.org/en/latest/pyboard/library/gc.html) – control the garbage collector
* [**`math`**](http://docs.micropython.org/en/latest/pyboard/library/math.html) – mathematical functions
* [**`select`**](http://docs.micropython.org/en/latest/pyboard/library/select.html) – wait for events on a set of streams
* [**`sys`**](http://docs.micropython.org/en/latest/pyboard/library/sys.html) – system specific functions
* [**`ubinascii`**](http://docs.micropython.org/en/latest/pyboard/library/ubinascii.html) – binary/ASCII conversions
* [**`ucollections`**](http://docs.micropython.org/en/latest/pyboard/library/ucollections.html) – collection and container types
* [**`uhashlib`**](http://docs.micropython.org/en/latest/pyboard/library/uhashlib.html) – hashing algorithm
* [**`uheapq`**](http://docs.micropython.org/en/latest/pyboard/library/uheapq.html) – heap queue algorithm
* [**`uio`**](http://docs.micropython.org/en/latest/pyboard/library/uio.html) – input/output streams
* [**`ujson`**](http://docs.micropython.org/en/latest/pyboard/library/ujson.html) – JSON encoding and decoding
* [**`uos`**](http://docs.micropython.org/en/latest/pyboard/library/uos.html) – basic “operating system” services
* [**`ure`**](http://docs.micropython.org/en/latest/pyboard/library/ure.html) – regular expressions
* [**`usocket`**](http://docs.micropython.org/en/latest/pyboard/library/usocket.html) – socket module
* [**`ustruct`**](http://docs.micropython.org/en/latest/pyboard/library/ustruct.html) – pack and unpack primitive data types
* [**`utime`**](http://docs.micropython.org/en/latest/pyboard/library/utime.html) – time related functions
* [**`uzlib`**](http://docs.micropython.org/en/latest/pyboard/library/uzlib.html) – zlib decompression

### [Libraries specific to the board](#libraries-specific-to-the-board)

* **`pyb`** – functions related to the board

	* [Pin](#pin)
	* [ExtInt](#extint)
	* [I2C](#i2c)
	* [SPI](#spi)
	* [UART](#uart)
	* [WiFi](#wifi)
	* [TCPServer](#tcpserver)
	* [TCPClient](#tcpclient)
	* [BLE](#ble)
	* [Servo](#servo)
	* [RGB](#rgb)


## <span id="libraries-specific-to-the-board">Libraries specific to the board</span>

**Note: All of the following classes and functions are built within the `pyb` module, so you need `import pyb` before you using these classes and functions.**

### <span id="pin">Pin</span>

`from pyb import Pin`

A pin is the basic object to control I/O pins. It has methods to set the mode of the pin (input, output, etc) and methods to get and set the digital/analog level. 


#### `Pin.pinMode(pin, mode)`

Initialises the pin mode.

The `pin` can be either the board pin or the CPU pin, i.e. the `Pin.board.D0` is the same as `Pin.cpu.B7`.

The `mode` can be one of:

* `Pin.INPUT` - configure the pin for input;
* `Pin.OUTPUT` - configure the pin for output;
* `Pin.INPUT_PU` - configure the pin for input with internal pull-up resistor;
* `Pin.INPUT_PD` - configure the pin for input with internal pull-down resistor;
* `Pin.AN_INPUT` - configure the pin for analog input;
* `Pin.AN_OUTPUT` - configure the pin for analog output.

Returns: None.

For example:

	LED = Pin.board.D0
	Pin.pinMode(LED, Pin.OUTPUT)

#### `Pin.digitalWrite(pin, value)`

Sets the digital logic level of the pin. The `value` can be`Pin.HIGH` or `Pin.LOW` or anything that converts to a boolean. If it converts to `True`, the pin is set high, otherwise it is set low.

For example:

	// Output high level on the D0
	Pin.digitalWrite(Pin.board.D0, Pin.HIGH);

	// Output low level on the D0
	Pin.digitalWrite(Pin.board.D0, Pin.LOW);

#### `Pin.digitalRead(pin)`

Gets the digital logic level of the pin. It returns `Pin.HIGH` or `Pin.LOW` depending on the logic level of the pin. The pin should be set as input mode (`INPUT`, `INPUT_PU`, `INPUT_PD`) using `Pin,pinMode()` first.

For example:

	// Read the level on the D1
	BTN = Pin.board.D0
	Pin.pinMode(BTN, Pin.INPUT_PU)
	val = Pin.digitalRead(Pin.board.D1)

#### `Pin.pwmWrite(pin, value, [frequency=500])`

Outputs PWM (pulse-width modulated) on the pin. The `value` corresponds to duty cycle: between 0 (always off) and 255 (always on). The default `frequency` of the PWM signal is 500 Hz. Please check the Duo's [pinout](https://github.com/redbear/Duo/blob/master/docs/duo_introduction.md#pinouts) to see which pin is capable of outputing PWM signal.

For example:

	// Output PWM on D0 in 500Hz
	Pin.pwmWrite(Pin.board.D0, 128)

	// Output PWM on D0 in 1KHz
	Pin.pwmWrite(Pin.board.D0, 128, 1000)

#### `Pin.analogWrite(pin, value)`

Outputs analog level on the pin. The `value` ranges from 0 to 4095, whihc maps to 0v to 3.3v. Only pin A2 and A3 are capable of analog output.

For example:

	// Output voltage of 1024/4095 * 3.3V = 0.825V on A2
	Pin.analogWrite(Pin.board.A2, 1024)

#### `Pin.analogRead(pin)`

Gets the analog level on the pin. The returned value will be between 0 and 4095. Only the pins A0 ~ A7 are capable of analog input.

For example:
	
	// Read the analog value on the A0
	val = Pin.analogRead(Pin.board.A0)

#### `Pin.tone(pin, frequency, duration)`

Generates a square wave (50% duty cycle) of the specified frequency and duration on the pin which supports PWM.

For example:

	// Output 1KHz frequency on the D0, last for 3 seconds
	Pin.tone(Pin.board.D0, 1000, 3000)

#### `Pin.noTone(pin)`

Stops the generation of a square wave triggered by `tone(pin)` on a specified pin. Has no effect if no tone is being generated.

For example:

	Pin.noTone(Pin.board.D0)

#### `Pin.shiftOut(data_pin, clock_pin, bit_order, value)`

Shifts out a byte of data one bit at a time on a specified pin. Starts from either the most (i.e. the leftmost) or least (rightmost) significant bit. Each bit is written in turn to a data pin, after which a clock pin is pulsed (taken high, then low) to indicate that the bit is available.

**NOTE**: if you're interfacing with a device that's clocked by rising edges, you'll need to make sure that the clock pin is low before the call to `Pin.shiftOut()`.

The `bit_order` should be either `Pin.MSBFIRST` or `Pin.LSBFIRST` (Most Significant Bit First, or, Least Significant Bit First). The `value` should be one byte.

For example:

	DATA_PIN = Pin.board.D0
	CLK_PIN = Pin.board.D1

	Pin.shiftOut(DATA_PIN, CLK_PIN, Pin.MSBFIRST, 0x55)

#### `Pin.shiftIn(data_pin, clock_pin, bit_order)`

Shifts in a byte of data one bit at a time. Starts from either the most (i.e. the leftmost) or least (rightmost) significant bit. For each bit, the clock pin is pulled high, the next bit is read from the data line, and then the clock pin is taken low.

**NOTE**: if you're interfacing with a device that's clocked by rising edges, you'll need to make sure that the clock pin is low before the call to `Pin.shiftOut()`.

The `bit_order` should be either `Pin.MSBFIRST` or `Pin.LSBFIRST` (Most Significant Bit First, or, Least Significant Bit First). The `value` should be one byte.

For example:

	DATA_PIN = Pin.board.D0
	CLK_PIN = Pin.board.D1

	val = Pin.shiftIn(DATA_PIN, CLK_PIN, Pin.MSBFIRST)

#### `Pin.pulseIn(pin, value)`

Reads a pulse (either `Pin.HIGH` or `Pin.LOW`) on a pin. For example, if `value` is `Pin.HIGH`, `pulseIn()` waits for the pin to go HIGH, starts timing, then waits for the pin to go LOW and stops timing. Returns the length of the pulse in microseconds or 0 if no pulse is completed before the 3 second timeout (unsigned long).

For example:

	ms = Pin.pulseIn(Pin.board.D0, Pin.HIGH)

#### `Pin.afList(pin)`

Returns an array of alternate functions available for this pin.

#### `Pin.mode(pin)`

Returns the currently configured mode of the pin. The string returned will match one of the allowed constants for the mode argument to the init function.

#### `Pin.name(pin)`

Gets the pin name.

#### `Pin.names(pin)`

Returns the cpu and board names for this pin.

#### `Pin.pin(pin)`

Gets the pin number.

#### `Pin.port(pin)`

Gets the pin port.


### <span id="extint">ExtInt</span>

`from pyb import ExtInt`

To capture the external event on specific pin, the pin should be configured as input first. The input mode can be either `INPUT`, `INPUT_PU` or `INOUT_PD`.

#### `ExtInt.enableAllInterrupt()`

Enables all of the interrupts.

#### `ExtInt.disableAllInterrupt()`

Disables all of the interrupts

#### `Pin.attachInterrupt(pin, mode, callback)`

Watches the interrupt on the pin so that when event occured the callback function will be called.

The `mode` can be one of:

* `ExtInt.IRQ_RISING` - callback when a rising edge occured on the pin;
* `ExtInt.IRQ_FALLING` - callback when a falling edge occured on the pin;
* `ExtInt.IRQ_CHANGE` - callback when a rising or falling edge occured on the pin.

For example:

	from pyb import Pin
	from pyb import ExtInt

	def my_callback():
		print("Level changed.")

	// Initialize the pin as input pull-up
	Pin(Pin.board.D0, INPUT_PU)

	// Watch the interrupt
	ExtInt.attachInterrupt(Pin.board.D0, ExtInt.IRQ_CHANGE, my_callback)

#### `Pin.detachInterrupt(pin)`

Disables the interrupt on the pin so that the callback function will never be called when event occured on the pin.

For example:

	Pin.detachInterrupt(Pin.board.D0)


### <span id="i2c">I2C</span>

`from pyb import I2C`

I2C is a two-wire protocol for communicating between devices. At the physical level it consists of 2 wires: SCL and SDA, the clock and data lines respectively. Regarding the Duo, the SDA is mapped to D0 and SCL is mapped to D1. Currently the Duo only supports I2C master role.

#### `I2C.init([speed=CLOCK_SPEED_100KHZ])`

Initializes the I2C as master role. The `speed` can either be `CLOCK_SPEED_100KHZ` or `CLOCK_SPEED_400KHZ`.

#### `I2C.deInit()`

Deinitializes the I2C module so that the associated pins can be used for other functions.

#### `I2C.recvChar(address)`

Returns a character that is read from slave device, the addresss of which is specified by `address`.

For example:

	// Read one byte from slave 0x55
	ch = I2C.recvChar(0x55)

#### `I2C.recv(buffer, address, quantity)`

Reads a quantity of data from slave device. The `buffer` is to hold the read out data. The `address` is the slave device address.

For eaxmple:

	// Read 5 bytes from slave 0x55 and store it in a list
	buf = []
	I2C.recv(list, 0x55, 5)

#### `I2C.sendChar(char, address)`

Sends one byte to slave device, the address of which is specified by `address`.

For example:

	// Send one byte 0x10 to slave 0x55
	I2C.sendChar(0x10, 0x55)

#### `I2C.send(buffer, address)`

Sends a quantity of data to slave device. The `buffer` holds the data to be sent. The `address` is the slave device address, which will receive the data.

For example:

	// Send a string to slave  0x55
	I2C.send("hello world!", 0x55)

	// Send a list to slave 0x55
	buf = [1, 2. 3, 4, 5]
	I2C.send(list, 0x55)

#### `I2C.isEnable()`

Returns `True` if the I2C module is enabled, otherwise returns `False`.


### <span id="spi">SPI</span>

`from pyb import SPI`

SPI is a serial protocol that is driven by a master. At the physical level there are 4 lines: SCK, MOSI, MISO, NSS. There are two SPI interfaces available on the Duo. The `SPI(1)` is mapped to A2 ~ A5 and the `SPI(2)` is mapped to D2 ~ D5. See the Duo [pin mapping](https://github.com/redbear/Duo/blob/master/docs/duo_introduction.md#pinouts).

#### `SPI.SPI(alt_interface)`

Constructs a SPI object associated with a SPI interface. The `alt_interface` can either be `1` or `2`. If `alt_interface = 1`, the constructed SPI object is associated with the SPI interface which is mapped to A2 ~ A5. Otherwise, the constructed SPI object is associated with the SPI interface which is mapped to D2 ~ D5.

For example:

	// Constructs SPI object associated with A2 ~ A5
	spi = SPI(1)

	// Constructs SPI object associated with D2 ~ D5
	spi1 = SPI(2)

#### `SPI.init()`

Initializes the SPI interface.

For example:

	spi = SPI(1)
	spi.init()

#### `SPI.deInit()`

Deinitializes the SPI interface so that the associated pins can be used for other functions.

#### `SPI.setBitOrder(bit_order)`

Sets the order of the bits shifted out of and into the SPI bus. The `bit_order` can either be `SPI.LSBFIRST` (least-significant bit first) or `SPI.MSBFIRST` (most-significant bit first).

#### `SPI.setClockSpeed(value, scale)`

Sets the SPI clock speed. The clock speed in Hz is equal to `value` * `scale`.

For example:

	// Sets the SPI clock speed to 15 MHz
	spi = SPI(1)
	spi.setClockSpeed(15, 1000000)

#### `SPI.setClockDivider(divider)`

Sets the SPI clock divider relative to the selected clock reference. The available dividers are 2, 4, 8, 16, 32, 64, 128 or 256. The default setting is `SPI.SPI_CLOCK_DIV4`, which sets the SPI clock to one-quarter the frequency of the system clock. The `divider` can be one of:

* `SPI.SPI_CLOCK_DIV2`
* `SPI.SPI_CLOCK_DIV4`
* `SPI.SPI_CLOCK_DIV8`
* `SPI.SPI_CLOCK_DIV16`
* `SPI.SPI_CLOCK_DIV32`
* `SPI.SPI_CLOCK_DIV64`
* `SPI.SPI_CLOCK_DIV128`
* `SPI.SPI_CLOCK_DIV256`

#### `SPI.setDataMode(mode)`

Sets the SPI data mode: that is, clock polarity and phase. See the [Wikipedia article on SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus) for details. The `mode` can be one of:

* `SPI.MODE0`
* `SPI.MODE1`
* `SPI.MODE2`
* `SPI.MODE3`

#### `SPI.recvChar()`

Receives a character from SPI slave device.

For example:

	spi = SPI(1)
	spi.init()
	ch = spi.recvChar()

#### `SPI.recv(buffer, quantity)`

Receives a quantity of data from SPI slave device.

For example:

	buf = []

	spi = SPI(1)
	spi.init()
	spi.recv(buf, 20) // Receives 20 bytes from SPI slave device

#### `SPI.sendChar(char)`

Sends a character to SPI slave device. 

For example:

	spi = SPI(1)
	spi.init()
	spi.sendChar(0x55) // Sends 0x55 to SPI slave device

#### `SPI.send(buffer)`

Sends a quantity of data to SPI slave device.

For example:

	buf = [1, 2, 3, 4, 5]

	spi = SPI(1)
	spi.init()
	spi.send("Hello world!")
	spi.send(buf)

#### `SPI.isEnable()`

Returns `True` if the SPI interface is enabled, otherwise returns `False`.


### <span id="uart">UART</span>

`from pyb import UART`

UART implements the standard UART duplex serial communications protocol. At the physical level it consists of 2 lines: RX and TX. The unit of communication is a character (not to be confused with a string character) which can be 8 or 9 bits wide. There are two UART interfaces available on the Duo. The `UART(1)` is mapped to TX and RX pin, while the `UART(2)` is mapped to A0 and A1. See the Duo [pin mapping](https://github.com/redbear/Duo/blob/master/docs/duo_introduction.md#pinouts).

#### `UART.UART(alt_interface)`

Constructs a UART object associated with an UART interface. The `alt_interface` can either be `1` or `2`. If `alt_interface = 1`, the constructed UART object is associated with TX and RX pins. Otherwise, the constructed UART object is associated with A0 and A1 pins.

For example:

	// Constructs an UART object associated with TX and RX pins
	uart = UART(1)

	// Constructs an UART object associated with A0 and A1 pins
	uart1 = UART(2)

#### `UART.init(baudrate)`

Initializes the UART interface and sets the baudrate. The `baudrate` can either be `UART.BAUDRATE_9600` or `UART.BAUDRATE_115200`.

For example:

	uart = UART(1)
	uart.init(UART.BAUDRATE_9600)

#### `UART.deInit()`

Deinitializes the UART interface so that the associated pins can be used for other functions.

#### `UART.writeChar(char)`

Sends one byte to peer UART device.

For example:

	uart = UART(1)
	uart.init(UART.BAUDRATE_9600)
	uart.writeChar(0x55) // Sends 0x55 to peer device

#### `UART.write(buffer)`

Sends a quantity of data to peer device.

For example:

	buf = [1, 2, 3, 4, 5]

	uart = UART(1)
	uart.init(UART.BAUDRATE_9600)
	UART.write("Hello world!")
	UART.write(buf)

#### `UART.flush()`

Waits for the transmission of outgoing serial data to complete.

**NOTE**: That this function does nothing at present, in particular it doesn't wait for the data to be sent, since this causes the application to wait indefinitely when there is no serial monitor connected.

#### `UART.any()`

Returns the number of bytes that is available in internal serial RX buffer.

#### `UART.readChar()`

Reads one byte from internal serial RX buffer.

For example:

	uart = UART(1)
	uart.init(UART.BAUDRATE_9600)
	if( uart.any() != 0 ):
		ch = uart.readChar()

#### `UART.read(buffer, quantity)`

Reads a quantity of data from internal serial RX buffer.

For example:

	buf = []
	len = 0

	uart = UART(1)
	uart.init(UART.BAUDRATE_9600)
	len = uart.any()
	uart.read(buf, len)

#### `UART.peek()`

Reads one byte from internal serial RX buffer, but without removing this byte from the internal serial buffer.

#### `UART.isEnable()`

Returns `True` if the UART interface is enabled, otherwise returns `False`.


### <span id="wifi">WiFi</span>

`from pyb import WiFi`

WiFi is a technology that allows electronic devices to connect to a wireless LAN (WLAN) network, mainly using the 2.4 gigahertz (12 cm) UHF and 5 gigahertz (6 cm) SHF ISM radio bands. A WLAN is usually password protected, but may be open, which allows any device within its range to access the resources of the WLAN network.

#### `WiFi.on()`

Turns on WiFi. All of the WiFi relevant functions should be valid only if the WiFi is turned on.

#### `WiFi.off()`

Turns off WiFi. If WiFi is turned off, then the Duo will disconnect from AP if connected and all created sockets will be dropped.

#### `WiFi.connect()`

Connects the Duo to AP (Access Point). The Duo is capable of storing 5 WiFi credentials. When this function is called, the Duo will try to connect to the APs those have been configured one by one. If the `WiFi.on()` isn't been called before, this function will call it automatically before trying connecting to APs. During connecting to AP, the on-board RGB will be blinking green.

#### `WiFi.disconnect()`

Disconnects from AP. It will drop all of the created sockets.

#### `WiFi.connecting()`

Returns `True` if the Duo is trying to connect to AP, otherwise returns `False`.

#### `WiFi.ready()`

Returns `True` if the Duo has successfully connected to AP, otherwise returns `False`.

#### `WiFi.listen()`

Makes the Duo enter listening mode for configuring WiFi credentials using serial terminal or iOS/Android App. See this [guide](https://github.com/redbear/Duo/blob/master/docs/out_of_box_experience.md#configure-wifi-credential). When the Duo in listening mode, the on-board RGB will be blinking blue.

#### `WiFi.setCredentials(ssid, password, security, cipher)`

Configures WiFi credentials. The `ssid` and `password` should be string. If the AP is open, then the `password` and `cipher` shoul be omitted.

The `security` should be one of:

* `WiFi.WLAN_SEC_UNSEC`
* `WiFi.WLAN_SEC_WEP`
* `WiFi.WLAN_SEC_WPA`
* `WiFi.WLAN_SEC_WPA2`
* `WiFi.WLAN_SEC_NOT_SET`

The `cipher` should be one of:

* `WiFi.WLAN_CIPHER_NOT_SET`
* `WiFi.WLAN_CIPHER_AES`
* `WiFi.WLAN_CIPHER_TKIP`
* `WiFi.WLAN_CIPHER_AES_TKIP`

The Duo is capable of storing 5 WiFi credentials. If more than 5 credentials are configured, then the earliest one will be overrided. Before configuring WiFi credentials using this function, `WiFi.on()` should be called to make sure WiFi is on, or the function does nothing.

For example:

	// Turns on WiFi
	WiFi.on()

	// Configures a WPA2-AES AP
	WiFi.setCredentials("ssid", "password", WiFi.WLAN_SEC_WPA2, WiFi.WLAN_CIPHER_AES)

	// Configures an open AP
	WiFi.setCredentials("ssid", WiFi.WLAN_SEC_UNSEC)

#### `WiFi.getCredentials(buffer, num)`

Fetches `num` of WiFi credentials that are configured in the Duo. It returns the actual number of WiFi credentials that have been fetched. The fetched WiFi credentials are filled into the `buffer`.

For example:

	credentials = []

	// Fetches 5 configured WiFi credentials if possible
	WiFi.getCredentials(credentials, 5)

#### `WiFi.clearCredentials()`

Clears all of the configured WiFi credentials in the Duo.

#### `WiFi.hasCredentials()`

Returns `True` if there is valid WiFi credentials in the Duo, otherwise returns `False`.

#### `WiFi.macAddress()`

Returns the MAC address of the Duo.

#### `WiFi.SSID()`

Returns the SSID of the AP which the Duo is connecting to.

#### `WiFi.BSSID()`

Returns the MAC address of the AP which the Duo is connecting to.

#### `WiFi.RSSI()`

Returns the WiFi signal strength of the AP which the Duo is connecting to.

#### `WiFi.localIP()`

Returns the IP address which is leased to Duo by AP.

#### `WiFi.gatewayIP()`

Returns the IP address of the AP which the Duo is connecting to.

#### `WiFi.subnetMask()`

Returns the sub-network IP mask.

#### `WiFi.dncpServerIP()`

Returns the IP address of the DHCP server in the network.

#### `WiFi.dnsServerIP()`

Returns the IP address of the DNS server in the network.

#### `WiFi.setStaticIP(ip_address, netmask, gateway, dns)`

Sets a static IP address for the Duo. The `ip_address` is the IP address for Duo. The `netmask`, `gateway` and `dns` are all in IP address string format. The `WiFi.useStaticIP()` must be called for the static IP address to take effect.

For example:

	ip = "192.168.1.100"
	netmask = "255.255.255.0"
	gateway = "192.168.1.1"
	dns = "192.168.1.1"

	WiFi.setStaticIP(ip, netmask, gateway, dns)

#### `WiFi.useStaticIP()`

Uses the static IP address which is set via `WiFi.setStaticIP()`.

#### `WiFi.useDynamicIP()`

Uses dynamic IP address which is leased by DHCP server.

#### `WiFi.ping(ip_address, retry)`

Pings to the host. This is usually used to test the connection with another host, the IP address of which is specified by `ip_address`. It retries `retry` times if ping failed.

For example:

	WiFi.connect()

	// Pings to the host 192.168.1.1 with 3 retries if failed
	WiFi.ping("192.168.1.1", 3)

#### `WiFi.resolve(host, ip_address)`

Resolves the IP address of the given host name. The resolved IP address is filled into the `ip_address`.

For example:

	ip_address = []

	WiFi.connect()
	WiFi.resolve("www.google.com", ip_address)

#### `WiFi.scan(num)`

Makes the Duo scan the WiFi networks within its rangement. The `num` specifies the maximum number of WiFi networks should be returned.


### <span id="tcpserver">TCPServer</span>

`from pyb import WiFi`  
`from pyb import TCPServer`

A TCP server in the network can listening on a port and create TCP connection with TCP clients. The data is exchanged using the TCP/IP protocol.

#### `TCPServer.TCPServer(port)`

Constructs a TCP server that listens for incoming connections on the specified port.

For example:

    // Create a TCP server listening on port 5050
	tcp_server = TCPServer(5050)

#### `TCPServer.delete()`

Deletes a constructed TCP server and frees the allocated memory.

#### `TCPServer.begin()`

Starts TCP server and listening for incoming connections.  Only if the Duo has joined the network, then you can successfully start a TCP server for TCP/IP communication.

For example:

    // Create a TCP server listening on port 5050
	tcp_server = TCPServer(5050)

	tcp_server.begin()

#### `TCPServer.stop()`

Stops listening for incoming connections. All the accepted connections will be dropped.

#### `TCPServer.accept()`

Returns a client ID if the Duo accepts a TCP client, otherwise returns `-1`. The client ID ranges from 0 ~ 9, i.e a TCP server is limited to accept 10 clients at most.

For example:

	tcp_server = TCPServer(5050)

	tcp_server.begin()
	client_id = tcp_server.accept()

#### `TCPServer.write(client_id, buf)`

Writes data to specified client that connected to a server.

For example:

	tcp_server = TCPServer(5050)
	buf = [1, 2, 3, 4, 5]

	tcp_server.begin()
	client_id = tcp_server.accept()
	tcp_server.write(client_id, "Hello world!")
	tcp_server.write(client_id, buf)

#### `TCPServer.available(client_id)`

Returns the number of bytes available for reading (that is, the amount of data that has been received from the client by the server it is connected to).

#### `TCPServer.read(client_id, buffer, quantity)`

Reads the next byte received from the client that the server is connected to.

For example:

	buf = []
	tcp_server = TCPServer(5050)

	tcp_server.begin()
	client_id = tcp_server.accept()
	tcp_server.read(client_id, buf, 20)


### <span id="tcpclient">TCPClient</span>

`from pyb import WiFi`
`from pyb import TCPClient`

A TCP client in the network can connect to a TCP server. The data is exchanged using the TCP/IP protocol.

#### `TCPClient.TCPClient()`

Constructs a TCP client.

#### `TCPClient.delete()`

Deletes a constructed TCP client and frees the allocated memory.

#### `TCPClient.connectByIP(ip_address, port)`

Connects to a TCP server by specified IP address and port.

For example:

	tcp_client = TCPClient()
	ip = "192.168.1.100"
	port = 5050

	tcp_client.connectByIP(ip, port)

#### `TCPClient.connectByHostName(url, port)`

Connects to a TCP server by specified domain name and port.

For example:

	tcp_client = TCPClient()
	url = "www.google.com"
	port = 80

	tcp_client.connectByHostName(url, port)

#### `TCPClient.connected()`

Returns `True` if the client is connected with TCP server, otherwise returns `False`.

#### `TCPClient.stop()`

Disconnects from the connected server.

#### `TCPClient.write(buffer)`

Writes a quantity of data to TCP server that the client is connected to.

For example:

	tcp_client = TCPClient()
	ip = "192.168.1.100"
	port = 5050
	buf = [1, 2, 3, 4, 5]

	tcp_client.connectByIP(ip, port)
	tcp_client.write("Hello world!")
	tcp_client.write(buf)

#### `TCPClient.available()`

Returns the number of bytes available for reading (that is, the amount of data that has been received from the server that the client is connected to).

#### `TCPClient.read(buf, quantity)`

Reads a quantity of data received from TCP server that the client is connected to.

For example:

	tcp_client = TCPClient()
	ip = "192.168.1.100"
	port = 5050
	buf = []

	tcp_client.connectByIP(ip, port)
	tcp_client.read(buf, 20)

#### `TCPClient.peek()`

Returns the next byte received from TCP server.

#### `TCPClient.flush()`

Discard any bytes that have been received from the server but not yet read.

#### `TCPClient.status()`

Returns the current state of the client.


### <span id="ble">BLE</span>

`from pyb import BLE`

The Duo supports BLE (Bluetooth Low Energy) functionality. It is a wireless personal area network technology designed and marketed by the Bluetooth SIG (Special Interest Group) aimed at novel applications in the healthcare, fitness, beacons, security, and home entertainment industries.Compared to Classic Bluetooth, Bluetooth Smart is intended to provide considerably reduced power consumption and cost while maintaining a similar communication range.

In the MicroPython, the Duo acts as a BLE peripheral, which implements a UART service for exchanging data with BLE central devices.

#### `BLE.begin()`

Starts advertising to make the Duo discoverable to BLE central devices.

#### `BLE.stop()`

Stops advertising to make the Duo non-discoverable to central devices.

#### `BLE.connected()`

Returns `True` if the Duo is connected with BLE central device.

#### `BLE.write(buffer)`

Writes a quantity of data to BLE central device. The length of data should limited to 20 bytes at a time.

For example:

	buf = [1, 2, 3, 4, 5]

	if( BLE.connected() ):
		BLE.write("Hello world!")
		BLE.write(buf)

#### `BLE.available()`

Returns the number of bytes received from BLE central device.

#### `BLE.read(buffer, quantity)`

Reads a quantity of date from the internal BLE RX buffer.

For example:

	buf = []
	len = 0;

	if( BLE.connected() ):
		len = BLE.available()
		BLE.read(buf, len)

### <span id="servo">Servo</span>

`from pyb import Pin`  
`from pyb import Servo`

Servo objects control standard hobby servo motors with 3-wires (ground, power, signal). Only if the pin supports PWM then it can drive servo. See the Duo [pin mapping](https://github.com/redbear/Duo/blob/master/docs/duo_introduction.md#pinouts).

#### `Servo.Servo(pin)`

Constructs a servo object associated with the pin. You can control the Servo only after the `Servo.attach()` being called.

For example:

	s1 = Servo(Pin.board.D0)

#### `Servo.attach()`

Attaches the servo to the associated pin so that you can control it.

For example:

	s1 = Servo(Pin.board.D0)
	s1.attach()

#### `Servo.detach()`

Detaches the servo from the associated pin so that it can not be controlled.

#### `Servo.attached()`

Returns `True` if the servo is attached to the associated pin, otherwise returns `False`.

#### `Servo.write(angle)`

Writes a value to the servo, controlling the shaft accordingly. On a standard servo, this will set the angle of the shaft (in degrees), moving the shaft to that orientation. On a continuous rotation servo, this will set the speed of the servo (with 0 being full-speed in one direction, 180 being full speed in the other, and a value near 90 being no movement).

For example:

	s1 = Servo(Pin.board.D0)
	s1.attach()
	s1.write(90)

#### `Servo.writeMicroseconds(us)`

Writes a value in microseconds (uS) to the servo, controlling the shaft accordingly. On a standard servo, this will set the angle of the shaft. On standard servos a parameter value of 1000 is fully counter-clockwise, 2000 is fully clockwise, and 1500 is in the middle.

Note that some manufactures do not follow this standard very closely so that servos often respond to values between 700 and 2300. Feel free to increase these endpoints until the servo no longer continues to increase its range. Note however that attempting to drive a servo past its endpoints (often indicated by a growling sound) is a high-current state, and should be avoided.

Continuous-rotation servos will respond to the writeMicrosecond function in an analogous manner to the write function.

#### `Servo.read()`

Reads the current angle of the servo (the value passed to the last call to write()). Returns an integer from 0 to 180 degrees.

#### `Servo.setTrim(trim)`

Sets a trim value that allows minute timing adjustments to correctly calibrate 90 as the stationary point.

For example:

	s1 = Servo(Pin.board.D0)
	s1.attach()

	// shortens the pulses sent to the servo
	s1.setTrim(-3);
	
	// a larger trim value
	s1.setTrim(30);
	
	// removes any previously configured trim
	s1.setTrim(0);


### <span id="rgb">RGB</span>

`from pyb import RGB`

There is an on-board RGB on the Duo. In general, the on-board RGB is controlled by the the system firmware automatically. But with the use of the RGB methods, you can also control it manually.

#### `RGB.control(enable)`

If the `enable` is `True`, then user takes control of the RGB LED, otherwise give control back to the system.

For example:

	// take control of the RGB LED
	RGB.control(1)

	// resume normal operation
	RGB.control(0)

#### `RGB.controlled()`

Returns `True` when the RGB LED is under user control, or `False` when it is not.

#### `RGB.color(red, green, blue)`

Sets the color of the RGB with three values, 0 to 255 (0 is off, 255 is maximum brightness for that color). User must take control of the RGB LED before calling this method.

For example:

	RGB.control(1)

	// Set the RGB LED to red 
	RGB.color(255, 0, 0); 

	// Sets the RGB LED to cyan 
	RGB.color(0, 255, 255); 

	// Sets the RGB LED to white 
	RGB.color(255, 255, 255);

#### `RGB.brightness(value)`

Scales the brightness value of all three RGB colors with one value, 0 to 255 (0 is 0%, 255 is 100%). This setting persists after RGB.control() is set to false, and will govern the overall brightness of the RGB LED under normal system operation. User must take control of the RGB LED before calling this method.

For example:

	RGB.control(1)

	// Scale the RGB LED brightness to 25% 
	RGB.brightness(64); 

	// Scale the RGB LED brightness to 50% 
	RGB.brightness(128); 

	// Scale the RGB LED brightness to 100% 
	RGB.brightness(255);


## Support

* [RedBear Discussion](http://discuss.redbear.cc/c/redbear-duo/python-micropython)
* [MicroPython Forum](http://forum.micropython.org/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


