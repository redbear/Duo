# Duo: Devices Provisioning Guide
---

This guide provides instructions for you to provision your Duo to Particle cloud.

To do this if you:

* cleared the DCT or you forgot to backup it before
* don't trust RedBear and you want to do the provisioning yourself
* have problems to connect to Particle cloud

Note: you can send your device ID to us privately for provisioning if you are not sure how to do.

 
## Prerequisites

* [DFU-UTIL](dfu.md)
* [DCT](../firmware/dct) with Particle cert. (public key inside)
* [Device Provisioning Helper](https://github.com/redbear/device-provisioning-helper) tool (requires Node.js to run)
* [Particle account](https://build.particle.io/), [your access token](https://build.particle.io/build#settings)


## How it works

Each Duo have an unique ID, it is a secret data and already provisioned in Particle cloud. The DCT includes Particle cert. (pulic key) and is preloaded by factory and the keys (public and private) for your Duo are empty at the moment.

Once you try the out-of-box test follow the getting started guide, during the handshaking process, your keys will be generated and the public key of your Duo will be encrypted by Particle's public key and then it will be sent to the cloud for storing.

That means, all communication between your Duo and Particle is safe (encryted). Finally, did you backup the DCT (i.e. keys) as told in the getting started guide?

If you clear the DCT, then you will be unable to connect to the Cloud anymore, this time, you need to provision your Duo again.


## Upload DCT.bin

* To load the DCT:

	$ dfu-util -d 2b04:d058 -a 0 -s 0x08004000 -D duo-dct.bin


## Get Access Token

* Log into your Particle account, from the 'Settings' icon, copy the 'Access Token'.

![image](images/Token.png)


## Edit main.js

* Change YOUR_ACCESS_TOKEN (your own one!) and YOUR_PRODUCT_ID (88 is the Duo product ID assigned by Particle):

		var YOUR_ACCESS_TOKEN = "63796d690652ffffffffffffff66fd5d3d53bce8";
		var YOUR_PRODUCT_ID = 88;


## Provisioning

Run the command as the following and you will get the similar output:

	$ node main.js 2fff27fffc473530fff23637
	using generic public key
	attempting to add a new public key for device 2fff27fffc473530fff23637
	Success - Device Provisioned!

After that, your Duo should be able to connect to the Particle Cloud again.


## What's Next

[Getting Started with Particle Build (WebIDE)](getting_started_with_particle_build.md)


## References

* [Duo Introduction](duo_introduction.md)
* [dfu-util Installation Guide](dfu-util_installation_guide.md)
* [RedBear Discussion Forum](http://discuss.redbear.cc/)


## Resources

* [Device Provisioning Helper Script](https://github.com/redbear/device-provisioning-helper)
* [Nodejs](https://nodejs.org/en/download/)


## License

Copyright (c) 2016 Red Bear

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.





