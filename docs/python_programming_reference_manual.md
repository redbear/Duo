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

### [Libraries specific to the board](libraries-specific-to-the-board)

* **`pyb`** – functions related to the board

	* [class Pin](#class-pin)
	* [class ADC](#class-adc)
	* [class DAC](#class-dac)
	* [class ExtInt](#class-extint)
	* [class Timer](#class-timer)
	* [class I2C](#class-i2c)
	* [class UART](#class-uart)
	* [class SPI](#class-spi)
	* [class WiFi](#class-wifi)
	* [class TCPServer](#class-tcpserver)
	* [class TCPClient](#class-tcpclient)
	* [class BLE](#class-ble)
	* [class Servo](#class-servo)
	* [class RGB](#class-rgb)


## <span id="libraries-specific-to-the-board">Libraries specific to the board</span>

### <span id="class-pin">class `Pin`</span>

A pin is the basic object to control I/O pins. It has methods to set the mode of the pin (input, output, etc) and methods to get and set the digital logic level.

#### Constructors

##### `pyb.Pin(id, ...)`

Create a new Pin object associated with the id. If additional arguments are given, they are used to initialise the pin. See `Pin.init()`.

For example:

	// Create a new pin using board pin name:
	LED = pyb.Pin(pyb.Pin.board.D0)
	
	// Create a new pin using CPU pin name:
	LED = pyb.Pin(pyb.Pin.cpu.B7)

#### Methods

##### `Pin.init(mode, pull=Pin.PULL_NONE, af=-1)`

Initialise the pin.

`mode` can be one of:

* `Pin.IN` - configure the pin for input;
* `Pin.OUT` - configure the pin for output
* `Pin.AF_PP` - configure the pin for alternate function, pull-pull;
* `Pin.AF_OD` - configure the pin for alternate function, open-drain;
* `Pin.ANALOG` - configure the pin for analog.

`pull` can be one of:

* `Pin.PULL_NONE` - no pull up or down resistors;
* `Pin.PULL_UP` - enable the pull-up resistor;
* `Pin.PULL_DOWN` - enable the pull-down resistor.

when mode is `Pin.AF_PP` or `Pin.AF_OD`, then af can be the index or name of one of the alternate functions associated with a pin.

Returns: None.

For example:

	LED = pyb.Pin(pyb.Pin.board.D0)
	LED.init(pyb.Pin.OUT)

##### 

#### Contants

### <span id="class-adc">class `ADC`</span>


## Support

* [RedBear Discussion](http://discuss.redbear.cc/c/redbear-duo/python-micropython)
* [MicroPython Forum](http://forum.micropython.org/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


