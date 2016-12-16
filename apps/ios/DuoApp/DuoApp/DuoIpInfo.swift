//
//  DuoIpInfo.swift
//  DuoApp
//
//  Created by Sunny Cheung on 4/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import Foundation

class DuoIpInfo: NSObject {
    
    var duoIPVersion:UInt8
    var duoIp:String
    var ipVersion:UInt8
    var apIp:String
    var mac:String
    var ssidLen:UInt8
    var ssid:String
    
    
    init(data:Data) {
        
        let resultBytes:[UInt8] = Array(UnsafeBufferPointer(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))
        
        duoIPVersion = resultBytes[2]
        duoIp = String(format: "%d.%d.%d.%d", resultBytes[6],resultBytes[5],resultBytes[4], resultBytes[3])
        ipVersion = resultBytes[7]
        apIp = String(format: "%d.%d.%d.%d", resultBytes[11],resultBytes[10],resultBytes[9], resultBytes[8])
        mac = String(format: "%02X:%02X:%2X:%02X:%02X:%02X", resultBytes[12],resultBytes[13],resultBytes[14], resultBytes[15],resultBytes[16],resultBytes[17])
        ssidLen = resultBytes[18]
        ssid = ""
        for i in 19 ..< 19+ssidLen {
            ssid.append(Character(UnicodeScalar(resultBytes[Int(i)])))
        }
        super.init()
        
        
    }
    
    func printString() -> String{
        
        var ipv:String = ""
        var gipv:String = ""
      
        if duoIPVersion == 4 {
            ipv = "duoIPv4"
        }
        else if duoIPVersion == 6 {
            ipv = "duoIPv6"
        }
        
        if ipVersion == 4 {
            gipv = "gatewayIPv4"
        }
        else if ipVersion == 6 {
            gipv = "gatewayIPv6"
        }
        
        
        
        return "\(ipv) : \(duoIp)\n\(gipv) : \(apIp)\ngatewayMAC : \(mac)\n"
        
    }
}
