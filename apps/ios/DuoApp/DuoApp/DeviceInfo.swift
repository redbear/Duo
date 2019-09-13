//
//  DeviceInfo.swift
//  DuoApp
//
//  Created by Sunny Cheung on 21/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit

class DeviceInfo: NSObject {
    var deviceId:String?
    var bootloadVer:UInt16 = 0
    var systemPart1:UInt16 = 0
    var systemPart2:UInt16 = 0
    var userPart:UInt16 = 0
    var releaseVer:String?
    
    override init() {
        super.init()
    }
    
    init(data: Data) {
        let resultBytes:[UInt8] = Array(UnsafeBufferPointer(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))
        
        deviceId = String(format: "%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", resultBytes[2], resultBytes[3],
            resultBytes[4],resultBytes[5],resultBytes[6],resultBytes[7],resultBytes[8],resultBytes[9],resultBytes[10],
            resultBytes[11],resultBytes[12],resultBytes[13])
        bootloadVer = UInt16(resultBytes[15]) * 256 + UInt16(resultBytes[14])
        systemPart1 = UInt16(resultBytes[17]) * 256 + UInt16(resultBytes[16])
        systemPart2 = UInt16(resultBytes[19]) * 256 + UInt16(resultBytes[18])
        userPart = UInt16(resultBytes[21]) * 256 + UInt16(resultBytes[20])
        releaseVer = ""
        for i in 23 ..< 23+resultBytes[22] {
            releaseVer!.append(Character(UnicodeScalar(resultBytes[Int(i)])))
        }
        super.init()
        print("Device Id: \(String(describing: deviceId)) bootloader: \(bootloadVer) systemPart1: \(systemPart1) systempart2: \(systemPart2) userPart: \(userPart) version: \(String(describing: releaseVer))")
        
    }
    
}
