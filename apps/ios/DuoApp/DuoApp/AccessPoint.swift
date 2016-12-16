//
//  AccessPoint.swift
//  DuoApp
//
//  Created by Sunny Cheung on 17/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import Foundation

enum APState: UInt8 {
    case AP_STATE_CONNECT
    case AP_STATE_NOTCONNECT
}

enum APSecurity:Int {
    case AP_SECURITY_OPEN
    case AP_SECURITY_WEP
    case AP_SECURITY_WEP_SHARED
    case AP_SECURITY_WPA_TKIP
    case AP_SECURITY_WPA_AES
    case AP_SECURITY_WPA2_AES
    case AP_SECURITY_WPA2_TKIP
    case AP_SECURITY_WPA2_MIXED
    
    var flag:Int {
        switch self {
        case .AP_SECURITY_OPEN: return 0
        case .AP_SECURITY_WEP: return 0x0001                                  //"WEP"
        case .AP_SECURITY_WEP_SHARED: return (0x0001 | 0x00008000)
        case .AP_SECURITY_WPA_TKIP: return(0x00200000 | 0x0002)               //"WPA TKIP"
        case .AP_SECURITY_WPA_AES: return (0x00200000 | 0x0004)               //"WPA AES"
        case .AP_SECURITY_WPA2_AES: return  (0x00400000 | 0x0004)               //"WPA2 AES"
        case .AP_SECURITY_WPA2_TKIP: return (0x00400000 | 0x0002);             //"WPA2 TKIP"
        case .AP_SECURITY_WPA2_MIXED: return (0x00400000 | 0x0004 | 0x0002);
        }
        
    }
}


enum DataFlg: UInt8{
    case DATAFLG_LAST = 0xC0
    case DATAFLG_CONTINUOUS
}

enum DuoState: UInt8 {
    case DUOSTATE_CONFIGURED = 0xD0
    case DUOSTATE_NOT_SCANNED
}

class AccessPoint: NSObject {
    
    var ssid:String
    var rssi:Int16
    var mac:String
    var security:Int
    var channel:UInt8
//    var ip:String
//    var duoIp:String
//    var state:APState
    
    
    init(data:Data) {
     
        let resultBytes:[UInt8] = Array(UnsafeBufferPointer(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))

      
        
        mac = String(format: "%02X:%02X:%2X:%02X:%02X:%02X", resultBytes[6],resultBytes[7],resultBytes[8], resultBytes[9],resultBytes[10],resultBytes[11])
        rssi = Int16(bitPattern: UInt16(Int(resultBytes[4]) * 256 + Int(resultBytes[3])))
        channel = resultBytes[5]
        security = Int(resultBytes[15]) << 24 | Int(resultBytes[14]) << 16 | Int(resultBytes[13]) << 8 | Int(resultBytes[12])
        
        
        let ssid_len = Int(resultBytes[16])

        ssid = ""
        for i in 17 ..< 17+ssid_len {
            ssid.append(Character(UnicodeScalar(resultBytes[Int(i)])))
        }
        
        super.init()
        let s = self.getSecurityFromValue(security)
        print("SSID : \(ssid) sec : \(s) RSSI:\(rssi)")
    }
    
    init(sid:String, sec:Int) {
        ssid = sid
        channel = 1
        mac = ""
        rssi = 0
        security = sec
        super.init()
    }
    
    func connectNeedPassword() -> Bool {
        if security == 0 {
            return false
        }
        return true
    }
    
    init(json:AnyObject) {
        mac = ""
        
        ssid = (json["ssid"] as? String)!
        rssi = ((json["rssi"] as? NSNumber)?.int16Value)!
        security = ((json["sec"] as? NSNumber)?.intValue)!
        channel = ((json["ch"] as? NSNumber)?.uint8Value)!
        super.init()
    }
    
    func getSecurityFromValue(_ s:Int) -> String {
        
        
        let AP_SECURITY_OPEN =  0
        let AP_SECURITY_WEP = 0x0001                                  //"WEP"
        let AP_SECURITY_WEP_SHARED =  (0x0001 | 0x00008000)
        let AP_SECURITY_WPA_TKIP = (0x00200000 | 0x0002)               //"WPA TKIP"
        let AP_SECURITY_WPA_AES = (0x00200000 | 0x0004)               //"WPA AES"
        let AP_SECURITY_WPA2_AES =      (0x00400000 | 0x0004)               //"WPA2 AES"
        let AP_SECURITY_WPA2_TKIP = (0x00400000 | 0x0002);             //"WPA2 TKIP"
        let AP_SECURITY_WPA2_MIXED = (0x00400000 | 0x0004 | 0x0002);

        switch (s) {
            case AP_SECURITY_OPEN:
                return "Open"
            case AP_SECURITY_WEP, AP_SECURITY_WEP_SHARED:
                return "WEP"
            case AP_SECURITY_WPA_TKIP:
                return "WPA TKIP"
            case AP_SECURITY_WPA_AES:
                    return "WPA AES"
            case AP_SECURITY_WPA2_TKIP:
                    return "WPA2 TKIP"
            case AP_SECURITY_WPA2_AES:
                    return "WPA2 AES"
            case AP_SECURITY_WPA2_MIXED:
                return "WPA2 Mixed"
            default: return "Unknown"
            
        }
    }
}
