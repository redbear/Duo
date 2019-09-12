//
//  ConnectionManager.swift
//  DuoApp
//
//  Created by Sunny Cheung on 24/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol ConnectionDelegate {
    func reachabilityChanged()
}

class ConnectionManager: NSObject, BLEDelegate {
    
    static var shareInstance = ConnectionManager()
    
    var bleEnabled = false
    var wifiEnabled = false
    var networkEnabled = false
    var apConnected = false // when connect to AP with Wifi

    var reachability: Reachability!
    
    override init() {
        super.init()
        registerForConnectionChecking()
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }

    
    func registerForConnectionChecking() {
     
            let reachability = Reachability()
            self.reachability = reachability
            if (reachability == nil) {
                print("ConnectionManager: Unable to create Reachability")
                self.noWifi()
                return
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
            
            do {
                try reachability!.startNotifier()
            } catch {
                print("could not start reachabiliy notifier")
                self.noWifi()
            }

        
    }
    
    @objc func reachabilityChanged(_ notification:Notification) {
        print("Network Changed")
        let reachability = notification.object as! Reachability
        
        if reachability.isReachable {
            self.networkEnabled = true
                      if reachability.isReachableViaWiFi {
                // check firmware if Wifi enabled
                print("Wifi Reachable")
                self.wifiEnabled = true
              
                let ssid = SSID.fetchSSIDInfo()
                if (ssid.range(of: "^Duo-.*", options: .regularExpression)) != nil {
                    print("Connect correct AP")
                    apConnected = true
              
                }
            }
            else {
                let wifistatus = WiFiStatus()
                if wifistatus.isWiFiEnabled() {
                    print("WiFi Enabled")
                    self.wifiEnabled = true
           
                }
                else {
                    noWifi()
                 
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
        }
        else {
            self.networkEnabled = false
            if reachability.isReachableViaWiFi {
                self.wifiEnabled = true
                print("Network not reachable but WiFi is enabled")
                let ssid = SSID.fetchSSIDInfo()
                if (ssid.range(of: "^Duo-.*", options: .regularExpression)) != nil {
                    print("Connect correct AP")
                    apConnected = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
                }

            }
            else {
                let wifistatus = WiFiStatus()
                if wifistatus.isWiFiEnabled() {
                    print("WiFi Enabled")
                    self.wifiEnabled = true
                }
                else {
                    noWifi()
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
        }
    }
    
    fileprivate func noWifi() {
        apConnected = false
        wifiEnabled = false
    }
    
    // MARK: BLEDelegate
    func bleDidConnect() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_BLE_CONNECTED"), object: nil)
    }
    
    func bleDidDisconenct() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_BLE_DISCONNECTED"), object: nil)
    }
    
    func bleDidDiscovertPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_DISCOVER_PERIPHERAL"), object: nil, userInfo: ["peripheral":peripheral])
        print("Discovered")
    }
    
    func bleDidUpdateState(_ state:CBCentralManagerState) {

        switch (state) {
        case .poweredOff:
            print("CBCentralManagerStatePoweredOff");
            bleEnabled = false
            bleDidDisconenct()
            break;
        case .poweredOn:
            print("CBCentralManagerStatePoweredOn");
           
            bleEnabled = true
            break;
        case .resetting:
            print("CBCentralManagerStateResetting");
            bleEnabled = false
            bleDidDisconenct()
            break;
        case .unauthorized:
            print("CBCentralManagerStateUnauthorized");
            bleEnabled = false
            bleDidDisconenct()
            break;
        case .unknown:
            print("CBCentralManagerStateUnknown");
            bleEnabled = false
            bleDidDisconenct()
            break;
        case .unsupported:
            print("CBCentralManagerStateUnsupported");
            bleEnabled = false
            bleDidDisconenct()
            
            break;
            
        @unknown default:
            print("CBCentralManagerState Unknown")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "BLE_STATUS_CHANGED"), object: nil)
    }
    
    func bleDidReceiveData(_ data: Data?) {
        
        
    }
    
    func duoFoundAP(_ ap: Data) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_FOUNDAP"), object: nil, userInfo: ["data":ap])
    }
    
    func duoStartScanning() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_SCANNING_AP"), object: nil)
    }
    
    func duoConnecting() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_AP_CONNECTING"), object: nil)
    }
    
    func duoCompleteScan() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_AP_SCANNING_COMPLETE"), object: nil)
        
    }
    
    func duoGetDeviceInfo(_ deviceIdData:Data) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_DEVICEINFO"), object: nil, userInfo: ["data":deviceIdData])
    }
    
    func duoConnectComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_AP_CONNECT_COMPLETE"), object: nil)
    }
    
    func duoConnectAPFail() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_AP_CONNECT_FAIL"), object: nil)
    }
    
    func bleDidStopScanning() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_STOP_SCANNING"), object: nil)
    }
    
    func duoCompleteConfig() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_AP_COMPLETE_CONFIG"), object: nil)
    }
    
    func finishProvisioning(_ deviceIdData:Data) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DUO_FINISH_PROVISIONING"), object: nil, userInfo: ["data":deviceIdData])
    }
    
  
    
    
}
