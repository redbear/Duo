//
//  OTAUpload.swift
//  DuoApp
//
//  Created by Sunny Cheung on 6/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import Foundation

protocol OTAUploadDelegate {
    func progress(_ p:Int)
    func uploadPart2()
    func uploadFac()
    func finishUploading()
}

enum OTAUploadError:Error {
    case versionIsInvalid
}

class OTAUpload:NSObject, StreamDelegate{
    var inputStream:InputStream?
    var outputStream:OutputStream?
    let url = "192.168.0.1"
    let OTAport = 50007
    static let sharedInstance = OTAUpload()
    var blockIdx:UInt32!
    var version:String?
    let MAX_OTA_REGION_ADDR = 0x80000
    let FAC_REGION_ADDR = 0x140000
    let MAX_FAC_REGION_ADDR = 0x1800
    let MAX_FILE_LENGTH = 512 * 1024
    let OTA_REGION_UNIT_SIZE = 0x1000
    let OTA_REGION_UNIT_CNT = (0x80000/0x1000)
    let MAX_CHUNK_SIZE = 1024
    let CHUNK_SIZE:UInt32 = 128
    let docDir:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    // data that will be upload
    var data:NSData?
    var sendBytes:UInt32!
    var fileLen:UInt32!
    var delegate:OTAUploadDelegate?
    
    var uploadingPart1 = false
    var uploadingPart2 = false
    var uploadingFac = false
    
    override init() {
        super.init()
        blockIdx = 0
        sendBytes = 0
    }
    
    // MARK - network
    func initNetworkCommunication() {
        
        
        Stream.getStreamsToHost(withName: url, port: OTAport, inputStream: &self.inputStream, outputStream: &self.outputStream)
        
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        
        self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        self.outputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
        self.inputStream?.open()
        self.outputStream?.open()
        
        
    }
    
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
            case Stream.Event.openCompleted:
                print("Network OTA Open Completed")
                break
            case Stream.Event.hasBytesAvailable:
                print("Network OTA Has Bytes")
                if aStream == self.inputStream {
                    var buffer:[UInt8] = [UInt8](repeating: 0, count: 1024)
                    var len = 0
                    
                    while self.inputStream!.hasBytesAvailable {
                        len = self.inputStream!.read(&buffer, maxLength: buffer.count)
                        print("Length: \(len)")
                        if (len > 0) {
                            var output = NSString(bytes: &buffer, length: buffer.count,  encoding: String.Encoding.ascii.rawValue)
                            output = self.subString(output) as NSString?
                            print("receive \(output!)")
                            if output != nil {
                                //                                print("Output: \(output!)")
                                
                                if output == "chunk saved" {
                                    print("chunk saved")
                                    print("fileLen: \(self.fileLen) Byte Sent: \(self.sendBytes)")
                                   
                                    if (self.sendBytes < self.fileLen) {
                                        upload()
                                    }

                                }
                                else if output  == "file saved" {
                                    print("upload done and file saved")
                                    if (uploadingPart1) {
                                        self.uploadingPart1 = false
                                        self.delegate?.uploadPart2()
                                        
                                    }
                                    else if (uploadingPart2) {
                                        self.uploadingPart2 = false
                                        self.delegate?.uploadFac()
                                    }
                                    else if uploadingFac {
                                        self.uploadingFac = false
                                        self.delegate?.finishUploading()
                                    }
                                }
                                else if output == "not init" {
                                    print("not init")
                                }
                            }
                        }
                        
                    }
                }
                break
            case Stream.Event.errorOccurred:
                print("Network Error Occurred")
                self.inputStream?.close()
                self.outputStream?.close()
                self.inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
                self.outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
                break
            case Stream.Event.endEncountered:
                print("Network OTA End Encountered")
                self.inputStream!.close()
                self.inputStream!.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
                self.outputStream!.close()
                self.outputStream!.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
               
                break;
            default: break
            
        }
    }

    func uploadPart1(_ firstPacket:Bool) throws{
        initNetworkCommunication()
        uploadingPart1 = true
        if firstPacket {
            blockIdx = 0;
            sendBytes = 0;
            fileLen = 0;
            data = nil
        }
        if self.version == nil {
            throw OTAUploadError.versionIsInvalid
        }
        let readPath = URL(fileURLWithPath:  docDir).appendingPathComponent("duo-system-part1-v" + version! + ".bin")
        data = NSData.init(contentsOf: readPath)
        fileLen = UInt32(data!.length)
        upload()
    }
    
    func uploadPart2(_ firstPacket:Bool) throws {
        initNetworkCommunication()
        uploadingPart2 = true
        if firstPacket {
            blockIdx = 0;
            sendBytes = 0;
            fileLen = 0;
            data = nil
        }
        if self.version == nil {
            throw OTAUploadError.versionIsInvalid
        }
        let readPath = URL(fileURLWithPath:  docDir).appendingPathComponent("duo-system-part2-v" + version! + ".bin")
        data = NSData.init(contentsOf: readPath)
        fileLen = UInt32(data!.length)
        upload()
    }
    
    func uploadFac(_ firstPacket:Bool) throws {
        initNetworkCommunication()
        uploadingFac = true
        if firstPacket {
            blockIdx = 0;
            sendBytes = 0;
            fileLen = 0;
            data = nil
        }
        if self.version == nil {
            throw OTAUploadError.versionIsInvalid
        }
        let readPath = URL(fileURLWithPath:  docDir).appendingPathComponent("duo-fac-web-server-v" + version! + ".bin")
        data = NSData.init(contentsOf: readPath)
        fileLen = UInt32(data!.length)
        upload()

        
    }
    
    fileprivate func upload() {
        self.delegate?.progress(Int(sendBytes/fileLen))

        let byteLeft = fileLen - sendBytes
        var chunkLen = CHUNK_SIZE
        
        if (byteLeft < CHUNK_SIZE) {
            chunkLen = byteLeft
        }
        
        let blockData = data?.subdata(with: NSRange.init(location: Int(sendBytes), length: Int(chunkLen)))
        
        self.outputStream?.write( (blockData! as NSData).bytes.bindMemory(to: UInt8.self, capacity: blockData!.count), maxLength: blockData!.count)
        sendBytes = sendBytes + chunkLen
        print("Byte Sent: \(sendBytes)")
    }
    
    func setUploadVersion(_ version:String?) {
        self.version = version
    }
    
    func fileSize(_ fileName:String?) -> Int{
        if fileName != nil {
            let readPath = URL(fileURLWithPath:  docDir).appendingPathComponent(fileName!)
           
            return (NSData.init(contentsOf: readPath)?.length)!
        }
        return 0
    }
    
    fileprivate func subString(_ output:NSString!) -> String {
        
        // find the length for the string (not including 0)
        let str = output as String
        var len = 0
        for i in str.utf8 {
            if  i  != 0 {
                len = len + 1
            }
            else {
                break
            }
        }
        
        return output.substring(to: len) as String
    }
}
