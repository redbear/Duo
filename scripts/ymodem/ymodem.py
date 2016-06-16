#!/usr/bin/python
import os
import sys
import serial


def printStdErr(*objs):
#    print("", *objs, file=stderr)
    print("")

def asbyte(v):
    return chr(v & 0xFF)



class LightYModem:
    """
    Receive_Packet
    - first byte SOH/STX (for 128/1024 byte size packets)
    - EOT (end)
    - CA CA abort
    - ABORT1 or ABORT2 is abort

    Then 2 bytes for seq-no (although the sequence number isn't checked)

    Then the packet data

    Then CRC16?

    First packet sent is a filename packet:
    - zero-terminated filename
    - file size (ascii) followed by space?
    """

    soh = 1     # 128 byte blocks
    stx = 2     # 1K blocks
    eot = 4
    ack = 6
    nak = 0x15
    ca =  0x18          # 24
    crc16 = 0x43        # 67
    abort1 = 0x41       # 65
    abort2 = 0x61       # 97

    packet_len = 1024
    expected_packet_len = packet_len+5
    packet_mark = stx

    def __init__(self):
        self.seq = None
        self.ymodem = None

    def flush(self):
        pass
        #self.ymodem.flush()

    def blocking_read(self):
        ch = ''
        while not ch:
            ch = self.ymodem.read(1)
        printStdErr("read %d " % ord(ch))
        return ch

    def _read_response(self):
        ch1 = self.blocking_read()
        ch1 = ord(ch1)
        printStdErr("response %d" % (ch1))

        if ch1==LightYModem.ack and self.seq==0:    # may send also a crc16
            ch2 = self.blocking_read()
        elif ch1==LightYModem.ca:                   # cancel, always sent in pairs
            ch2 = self.blocking_read()
        return ch1

    def write(self, packet):
        for x in range(len(packet)):
            self.ymodem.write(packet[x])

        return len(packet);

    def _send_ymodem_packet(self, data):
        # pad string to 1024 chars
        data = data.ljust(LightYModem.packet_len)
        seqchr = asbyte(self.seq & 0xFF)
        seqchr_neg = asbyte((-self.seq-1) & 0xFF)
        crc16 = '\x00\x00'
        packet = asbyte(LightYModem.packet_mark) + seqchr + seqchr_neg + data + crc16
        if len(packet)!=LightYModem.expected_packet_len:
            raise Exception("packet length is wrong!")

        written = self.write(packet)
        printStdErr("sent packet data, flush..."+str(written))
        self.flush()
        printStdErr("wait response..")
        response = self._read_response()
        if response==LightYModem.ack:
            ("sent packet nr %d " % (self.seq))
            self.seq += 1
        return response

    def _send_close(self):
        self.ymodem.write(asbyte(LightYModem.eot))
        self.flush()
        response = self._read_response()
        if response == LightYModem.ack:
            self.send_filename_header("", 0)
            self.ymodem.close()

    def send_packet(self, file, output):
        response = LightYModem.eot
        data = file.read(LightYModem.packet_len)
        if len(data):
            response = self._send_ymodem_packet(data)
        return response

    def send_filename_header(self, name, size):
        self.seq = 0
        packet = name + asbyte(0) + str(size) + ' '
        return self._send_ymodem_packet(packet)

    def transfer(self, file, ymodem, output):
        self.ymodem = ymodem
        """
        file: the file to transfer via ymodem
        ymodem: the ymodem endpoint (a file-like object supporting write)
        output: a stream for output messages
        """

        file.seek(0, os.SEEK_END)
        size = file.tell()
        file.seek(0, os.SEEK_SET)
        response = self.send_filename_header("binary", size)
        while response==LightYModem.ack:
            response = self.send_packet(file, output)

        file.close()
        if response==LightYModem.eot:
            self._send_close()

        return response



def ymodem(args):
    port = args[1]
    filename = args[2]
    ser = serial.Serial(port, baudrate=28800)
    file = open(filename, 'rb')
    result = LightYModem().transfer(file, ser, sys.stderr)
    file.close()
    print("result: " + str(result))

    try:
        while (True):
            print(ser.read())
    except:
        pass
    print("Done")

if __name__ == '__main__':
    ymodem(sys.argv)

