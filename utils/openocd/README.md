# OpenOCD

Uploading user part firmware using the RBLink with OpenOCD:

$ openocd -f redbearduo.cfg -c "program blink.bin verify reset exit 0x80c0000"
