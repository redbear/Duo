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
	* [object I2C](#class-i2c)
	* [class UART](#class-uart)
	* [class SPI](#class-spi)
	* [object WiFi](#class-wifi)
	* [class TCPServer](#class-tcpserver)
	* [class TCPClient](#class-tcpclient)
	* [object BLE](#class-ble)
	* [class Servo](#class-servo)
	* [object RGB](#class-rgb)


## <span id="libraries-specific-to-the-board">Libraries specific to the board</span>

**Note: All of the following classes and functions are built within the `pyb` module, so you need `import pyb` before you using these classes and functions.**

<br>
### <span id="class-pin">class `Pin`</span>

A pin is the basic object to control I/O pins. It has methods to set the mode of the pin (input, output, etc) and methods to get and set the digital logic level. 

#### Constructor

> ##### `Pin(pin, mode)`

Create a new Pin object associated with the pin. If additional arguments are given, they are used to initialise the pin. See `Pin.init()`.

For example:

	from pyb import Pin

	// Create a new pin object using board pin name:
	LED = Pin(Pin.board.D0)
	
	// Create a new pin object using CPU pin name and init pin mode:
	BTN = Pin(Pin.cpu.B6, Pin.INPUT)

#### Methods

> ##### `init(mode)`

Initialise the pin.

`mode` can be one of:

* `Pin.INPUT` - configure the pin for input;
* `Pin.OUTPUT` - configure the pin for output;
* `Pin.INPUT_PU` - configure the pin for input with internal pull-up resistor;
* `Pin.INPUT_PD` - configure the pin for input with internal pull-down resistor;
* `Pin.AF_OUTPUT_PP` - configure the pin for alternate function with push-pull drive;
* `Pin.AF_OUTPUT_OD` - configure the pin for alternate function with open-drain drive;
* `Pin.AN_INPUT` - configure the pin for analog input;
* `Pin.AN_OUTPUT` - configure the pin for analog output.

Returns: None.

For example:

	LED = Pin(Pin.board.D0)
	LED.init(Pin.OUTPUT)

> ##### `value([value])`

Get or set the digital logic level of the pin:

* With no argument, return 0 or 1 depending on the logic level of the pin.
* With `value` given, set the logic level of the pin. `value` can be anything that converts to a boolean. If it converts to `True`, the pin is set high, otherwise it is set low.

For example:

	// Output high level on the LED pin
	LED.value(1);

	// Read the level on the Button pin
	val = BTN.value()

> ##### `high()`

Output high level on the pin.

For example:

	// Output high level on the LED pin
	LED.high()

> ##### `low()`

Output low level on the pin.

For example:

	// Output low level on the LED pin
	LED.low()

> ##### `af_list()`

Returns an array of alternate functions available for this pin.

> ##### `mode()`

Returns the currently configured mode of the pin. The string returned will match one of the allowed constants for the mode argument to the init function.

> ##### `name()`

Get the pin name.

>##### `names()`

Returns the cpu and board names for this pin.

>##### `pin()`

Get the pin number.

>##### `port()`

Get the pin port.

#### Constants

> ##### `Pin.INPUT`

Value: `0`. Configure the pin for input.

> ##### `Pin.OUTPUT`

Value: `1`. Configure the pin for output.

> ##### `Pin.INPUT_PU`

Value: `2`. Configure the pin for input with internal pull-up resistor.

> ##### `Pin.INPUT_PD`

Value: `3`. Configure the pin for input with internal pull-down resistor.

> ##### `Pin.AF_OUTPUT_PP`

Value: `4`. Configure the pin for alternate function with a push-pull drive.

> ##### `Pin.AF_OUTPUT_OD`

Value: `5`. Configure the pin for alternate function with open-drain drive.

> ##### `Pin.AN_INPUT`

Value: `6`. Configure the pin for analog input.

> ##### `Pin.AN_OUTPUT`

Value: `7`. Configure the pin for analog output.

<br>
### <span id="class-adc">class `ADC`</span>

Analog to digital conversion. Only A0 ~ A7 are capable of analog input.

#### Constructor

> ##### `ADC(pin)`

Create an ADC object associated with the given pin. This allows you to then read analog value on that pin.

For example:

	from pyb import Pin  // The Pin is used when construct ADC object
	from pyb import ADC

	// Create a new ADC object
	adc = ADC(pyb.Pin.board.A0)

#### Methods

> ##### `read()`

Read the value on the analog pin and return it. The returned value will be between 0 and 4095.

For example:

	// Read the analog pin value
	val = adc.read()

<br>
### <span id="class-dac">Class DAC</span>

The DAC is used to output analog values (a specific voltage) on pin A2 or pin A3. The voltage will be between 0 and 3.3V.

#### Constructor

##### `DAC(pin)`

Create an DAC object associated with the given pin. This allows you to then output analog value to that pin. Only pin A2 and A3 are capable of analog output.

For example:

	from pyb import Pin  // The Pin is used when construct DAC object
	from pyb import DAC

	// Create a new DAC object
	dac = DAC(Pin.board.A2)

#### Methods

##### `write(value)`

Output analog value on specific pin. The `value` ranges from 0 to 4095, which corresponding to 0 to 3.3v on the pin.

For example:

	// sets DAC pin to an output voltage of 1024/4095 * 3.3V = 0.825V.
	dac.write(1024)

<br>
### <span id="class-extint">Class ExtInt</span>

#### Constructor



#### Static Methods



#### Methods



#### Constants



<br>
### <span id="class-timer">Class Timer</span>

#### Constructor



#### Methods



#### Constants



<br>
### <span id="">


## Support

* [RedBear Discussion](http://discuss.redbear.cc/c/redbear-duo/python-micropython)
* [MicroPython Forum](http://forum.micropython.org/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


