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

### <span id="class-pin">class `Pin`</span>

`from pyb import Pin`

A pin is the basic object to control I/O pins. It has methods to set the mode of the pin (input, output, etc) and methods to get and set the digital/analog level. 

#### Static Methods

> ##### `Pin.pinMode(pin, mode)`

Initialise the pin mode.

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
	Pin.pinMode(LED, OUTPUT)

> ##### `Pin.digitalWrite(pin, value)`

Set the digital logic level of the pin. The `value` can be anything that converts to a boolean. If it converts to `True`, the pin is set high, otherwise it is set low.

For example:

	// Output high level on the D0
	Pin.digitalWrite(Pin.board.D0, 1);

	// Output low level on the D0
	Pin.digitalWrite(Pin.board.D0, 0);

> ##### `Pin.digitalRead(pin)`

Get the digital logic level of the pin. It returns 0 or 1 depending on the logic level of the pin. The pin should be set as input mode (`INPUT`, `INPUT_PU`, `INPUT_PD`) using `Pin,pinMode()` first.

For example:

	// Read the level on the D1
	BTN = Pin.board.D0
	Pin.pinMode(BTN, INPUT_PU)
	val = Pin.digitalRead(Pin.board.D1)

> ##### `Pin.pwmWrite(pin, value, [frequency=500])`

Output PWM (pulse-width modulated) on the pin. The `value` corresponds to duty cycle: between 0 (always off) and 255 (always on). The default `frequency` of the PWM signal is 500 Hz. Please check the Duo's [pinout](https://github.com/redbear/Duo/blob/master/docs/duo_introduction.md#pinouts) to see which pin is capable of outputing PWM signal.

For example:

	// Output PWM on D0 in 500Hz
	Pin.pwmWrite(Pin.board.D0, 128)

	// Output PWM on D0 in 1KHz
	Pin.pwmWrite(Pin.board.D0, 128, 1000)

> ##### `Pin.analogWrite(pin, value)`

Output analog level on the pin. The `value` ranges from 0 to 4095, whihc maps to 0v to 3.3v. Only pin A2 and A3 are capable of analog output.

For example:

	// Output voltage of 1024/4095 * 3.3V = 0.825V on A2
	Pin.analogWrite(Pin.board.A2, 1024)

> ##### `Pin.analogRead(pin)`

Get the analog level on the pin. The returned value will be between 0 and 4095. Only the pins A0 ~ A7 are capable of analog input.

For example:
	
	// Read the analog value on the A0
	val = Pin.analogRead(Pin.board.A0)

> ##### `Pin.tone(pin, frequency, duration)`

Generates a square wave (50% duty cycle) of the specified frequency and duration on the pin which supports PWM.

For example:

	// Output 1KHz frequency on the D0, last for 3 seconds
	Pin.tone(Pin.board.D0, 1000, 3000)

> ##### `Pin.noTone(pin)`

Stops the generation of a square wave triggered by `tone(pin)` on a specified pin. Has no effect if no tone is being generated.

For example:

	Pin.noTone(Pin.board.D0)

> ##### `Pin.shiftOut(data_pin, clock_pin, bit_order, value)`

Shifts out a byte of data one bit at a time on a specified pin. Starts from either the most (i.e. the leftmost) or least (rightmost) significant bit. Each bit is written in turn to a data pin, after which a clock pin is pulsed (taken high, then low) to indicate that the bit is available.

**NOTE**: if you're interfacing with a device that's clocked by rising edges, you'll need to make sure that the clock pin is low before the call to `Pin.shiftOut()`.

The `bit_order` should be either `Pin.MSBFIRST` or `Pin.LSBFIRST` (Most Significant Bit First, or, Least Significant Bit First). The `value` should be one byte.

For example:

	DATA_PIN = Pin.board.D0
	CLK_PIN = Pin.board.D1

	Pin.shiftOut(DATA_PIN, CLK_PIN, Pin.MSBFIRST, 0x55)

> ##### `Pin.shiftIn(data_pin, clock_pin, bit_order)`

Shifts in a byte of data one bit at a time. Starts from either the most (i.e. the leftmost) or least (rightmost) significant bit. For each bit, the clock pin is pulled high, the next bit is read from the data line, and then the clock pin is taken low.

**NOTE**: if you're interfacing with a device that's clocked by rising edges, you'll need to make sure that the clock pin is low before the call to `Pin.shiftOut()`.

The `bit_order` should be either `Pin.MSBFIRST` or `Pin.LSBFIRST` (Most Significant Bit First, or, Least Significant Bit First). The `value` should be one byte.

For example:

	DATA_PIN = Pin.board.D0
	CLK_PIN = Pin.board.D1

	val = Pin.shiftIn(DATA_PIN, CLK_PIN, Pin.MSBFIRST)

> ##### `Pin.pulseIn(pin, value)`

Reads a pulse (either `Pin.HIGH` or `Pin.LOW`) on a pin. For example, if `value` is `Pin.HIGH`, `pulseIn()` waits for the pin to go HIGH, starts timing, then waits for the pin to go LOW and stops timing. Returns the length of the pulse in microseconds or 0 if no pulse is completed before the 3 second timeout (unsigned long).

For example:

	ms = Pin.pulseIn(Pin.board.D0, Pin.HIGH)

> ##### `Pin.af_list(pin)`

Returns an array of alternate functions available for this pin.

> ##### `Pin.mode(pin)`

Returns the currently configured mode of the pin. The string returned will match one of the allowed constants for the mode argument to the init function.

> ##### `Pin.name(pin)`

Get the pin name.

>##### `Pin.names(pin)`

Returns the cpu and board names for this pin.

>##### `Pin.pin(pin)`

Get the pin number.

>##### `Pin.port(pin)`

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

> ##### `Pin.AN_INPUT`

Value: `4`. Configure the pin for analog input.

> ##### `Pin.AN_OUTPUT`

Value: `5`. Configure the pin for analog output.

> ##### `Pin.MSBFIRST`

**TBD**

> ##### `Pin.LSBFIRST`

**TBD**

> ##### `Pin.HIGH`

**TBD**

> ##### `Pin.LOW`

**TBD**

### <span id="class-extint">Class ExtInt</span>

`from pyb import ExtInt`

To capture the external event on specific pin, the pin should be configured as input first. The input mode can be either `INPUT`, `INPUT_PU` or `INOUT_PD`.

#### Static Methods

> ##### `ExtInt.enable_all_interrupt()`

Enable all of the interrupts.

> ##### `ExtInt.disable_all_interrupt()`

Disable all of the interrupts

> ##### `Pin.attach_interrupt(pin, mode, callback)`

Watch the interrupt on the pin so that when event occured the callback function will be called.

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
	ExtInt.attach_interrupt(Pin.board.D0, ExtInt.IRQ_CHANGE, my_callback)

> ##### `Pin.detach_interrupt(pin)`

Disable the interrupt on the pin so that the callback function will never be called when event occured on the pin.

For example:

	Pin.detach_interrupt(Pin.board.D0)

#### Constants

> ##### `ExtInt.IRQ_RISING`

A rising edge on the pin will cause an interrupt.

> ##### `ExtInt.IRQ_FALLING`

A falling edge on the pin will cause an interrupt.

> ##### `ExtInt.IRQ_CHANGE`

Both a rising and falling edge on the pin will cause an interrupt.


## Support

* [RedBear Discussion](http://discuss.redbear.cc/c/redbear-duo/python-micropython)
* [MicroPython Forum](http://forum.micropython.org/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


