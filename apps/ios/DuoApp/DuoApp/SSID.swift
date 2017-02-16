//
//  SSID.swift
//  DuoApp
//
//  Created by Sunny Cheung on 23/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class SSID {
    
    
    class func fetchSSIDInfo() -> String {
               var currentSSID = ""
//
        #if !(arch(i386) || arch(x86_64))
        if let interfaces:CFArray? = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as! [String:AnyObject]
                    //print(interfaceData);
                    currentSSID = interfaceData["SSID"] as! String
                }
            }
        }
        #endif
        return currentSSID
    }
}
