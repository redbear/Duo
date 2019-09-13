

import Foundation
import CoreBluetooth

protocol BLEDelegate {
    func bleDidUpdateState(_ state:CBCentralManagerState)
    func bleDidConnect()
    func bleDidDisconenct()
    func bleDidReceiveData(_ data: Data?)
    func bleDidDiscovertPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber)
     func duoGetDeviceInfo(_ deviceIdData:Data)
 
    func bleDidStopScanning()

    // ap
    func duoStartScanning()
    func duoCompleteScan()
    func duoCompleteConfig()
    func duoConnectAPFail()
    func duoFoundAP(_ ap:Data)
    func duoConnectComplete()
    func duoConnecting()
    func finishProvisioning(_ data: Data)

}


class BLE: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let DuoServiceUUID = "3EC61400-89CD-49C3-A0D9-7A85669E901E"
    let CommandUUID = "3EC61401-89CD-49C3-A0D9-7A85669E901E"
    let StateUUID = "3EC61402-89CD-49C3-A0D9-7A85669E901E"
    
    
    let BLE_PROVISION_COMMAND_SCAN:UInt8  = 0xa0
    let BLE_PROVISION_COMMAND_CONFIG_AP:UInt8 = 0xa1
    let BLE_PROVISION_COMMAND_CONNECT_AP:UInt8 = 0xa2
    let BLE_PROVISION_COMMAND_NOTIFY_AP:UInt8 = 0xa3
    let BLE_PROVISION_COMMAND_GET_SYS_INFO:UInt8 = 0xa4
    let BLE_PROVISION_COMMAND_NOTIFY_IP_CONFIG:UInt8 = 0xa5
    
    
    let DUO_STATE_SCANNING:UInt8  = 0xb1
    let DUO_STATE_SCAN_COMPLETE:UInt8  = 0xb2
    let DUO_STATE_CONFIG_AP:UInt8 = 0xb3
    let DUO_STATE_CONNECTING:UInt8  = 0xb4
    let DUO_STATE_CONNECT_COMPLETE:UInt8 = 0xb5
    let DUO_STATE_CONNECT_ERROR:UInt8 = 0xb6
    
    var firstScan:Bool = true
    var getServiceId:Bool = false
    var isScanning:Bool = false
    var firstPacket:Bool = true
    var isAPConnected:Bool = false
    
    var delegate: BLEDelegate?
    
    fileprivate      var centralManager:   CBCentralManager!
    var activePeripheral: CBPeripheral?
    fileprivate      var commandCharacteristics:CBCharacteristic?
    fileprivate      var stateCharacteristics:CBCharacteristic?
    fileprivate      var dataSet = [UInt8]()
    fileprivate(set) var peripherals     = [CBPeripheral]()
    fileprivate      var RSSICompletionHandler: ((NSNumber?, NSError?) -> ())?
    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: Public method
    func isConnect() -> Bool {
        if (activePeripheral?.state == .connected) {
            return true
        }
        return false
    }
    
    func scan(_ services:[CBUUID], time:TimeInterval) {
        
        if time > 0 {
            Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
        }
        self.scan(services)
    }
    
    func scan(_ services:[CBUUID]?) {
        print("Start Scanning")
        if !isScanning {
            isScanning = true
            centralManager?.scanForPeripherals(withServices: services, options: nil)
        }
    }
    @objc func stopScan() {
        print("Stop Scanning")
        centralManager?.stopScan()
        isScanning = false
        delegate?.bleDidStopScanning()
    }
    
    func connect(_ peripheral:CBPeripheral) {
        centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey : true])
    }
    
    func disconnect() {
        centralManager?.cancelPeripheralConnection(activePeripheral!)
    }
    
    func getDeviceId() {
        print("Get Device Id")
        dataSet.removeAll()
        getServiceId = true
        let buff = [0x2, BLE_PROVISION_COMMAND_GET_SYS_INFO] as [UInt8]
        let data = Data.init(bytes: UnsafePointer<UInt8>(buff), count: 2)
         print("\(data)")
        sendData(data)
        
    }
    
    func duoAPScan() {
        firstScan = true
        getServiceId = false
        let buff = [0x2, BLE_PROVISION_COMMAND_SCAN] as [UInt8]
        let data = Data.init(bytes: UnsafePointer<UInt8>(buff), count: 2)
       
        sendData(data)
    }
    
    func setAPInfo(_ ap:AccessPoint, password:String="") {
        print("Set AP Info")
        var buff = [UInt8]()
        
        let passLen = password.count
        let len:UInt8 = 9 + UInt8(passLen) + UInt8(ap.ssid.count)
        
        buff += [len, BLE_PROVISION_COMMAND_CONFIG_AP, ap.channel]
        
        /// security
        buff += [UInt8(ap.security & 0xff), UInt8((ap.security & 0xff00) >> 8), UInt8((ap.security & 0xff0000) >> 16), UInt8((ap.security >> 24) & 0xff)]
        
       // ssid length
        buff += [UInt8(ap.ssid.count)]
        // ssid
        buff += ap.ssid.utf8
        
        // password
        buff += [UInt8(password.count)]
        buff += password.utf8
        
        let data = Data.init(bytes: UnsafePointer<UInt8>(buff),count: buff.count)
        
        sendData(data)
    }
    
    func apConnect() {
        let buff = [0x2, BLE_PROVISION_COMMAND_CONNECT_AP] as [UInt8]
        let data = Data.init(bytes: UnsafePointer<UInt8>(buff), count: 2)
        sendData(data)
    }
    
    func sendData(_ data:Data) {
        if commandCharacteristics != nil {
            activePeripheral?.writeValue(data, for: commandCharacteristics!, type: .withoutResponse)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let cbCentralManagerState = CBCentralManagerState(rawValue: central.state.rawValue)
        delegate?.bleDidUpdateState(cbCentralManagerState!)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.bleDidDiscovertPeripheral(peripheral, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        activePeripheral = peripheral
        activePeripheral?.delegate = self
        activePeripheral?.discoverServices(nil)
        delegate?.bleDidConnect()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bleDidDisconenct()
    }
    
    // MARK: CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Service found")
        if error == nil {
            for s in peripheral.services! {
                activePeripheral?.discoverCharacteristics(nil, for: s)
            }
        }
        else {
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("\(String(describing: error))")
//        if characteristic.isNotifying {
//            activePeripheral!.readValueForCharacteristic(characteristic)
//        }
        print("update notifcation")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        
        if error != nil {
            return
        }
        
        let data = characteristic.value
        print("\(String(describing: data))")
        let resultBytes:[UInt8] = Array(UnsafeBufferPointer(start: (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), count: data!.count))

        
        if characteristic.uuid.uuidString.uppercased() == CommandUUID {
            
            if resultBytes[0] > 20 && firstPacket {
                    firstPacket = false
                    dataSet.removeAll()
                    dataSet += resultBytes
            }
            else {
                
                
                dataSet += resultBytes
               
                if (dataSet.count == Int(dataSet[0])) { // completed data
                    firstPacket = true // should be last packet, next one will be first
                    
                    let completedData = Data.init(bytes: UnsafePointer<UInt8>(dataSet), count: dataSet.count)
                    if  getServiceId {
                        getServiceId = false
                        delegate?.duoGetDeviceInfo(completedData)
                    }
                    else if isScanning {
                        delegate?.duoFoundAP(completedData)
                    }
                    else if isAPConnected {
                        delegate?.finishProvisioning(completedData)
                    }
                }
            }
        
        }
        else if characteristic.uuid.uuidString.uppercased() == StateUUID {

                if delegate == nil {
                    return
                }
                    
                switch UInt8(resultBytes[0]) {
                    case DUO_STATE_SCANNING:
                        print("DUO_STATE_SCANNING")
                        isScanning = true
                        firstPacket = true
                        delegate?.duoStartScanning()
                        break
                    case DUO_STATE_SCAN_COMPLETE:
                        print("DUO_STATE_SCAN_COMPLETE")
                        isScanning = false
                        delegate?.duoCompleteScan()
                        break
                    case DUO_STATE_CONFIG_AP:
                        print("DUO_STATE_CONFIG_AP")
                        delegate?.duoCompleteConfig()
                        break
                    case DUO_STATE_CONNECTING:
                        print("DUO_STATE_CONNECTING")
                        delegate?.duoConnecting()
                        break
                    case DUO_STATE_CONNECT_COMPLETE:
                        print("DUO_STATE_CONNECT_COMPLETE")
                        isAPConnected = true
                        delegate?.duoConnectComplete()
                        break
                    case DUO_STATE_CONNECT_ERROR:
                        isAPConnected = false
                        print("DUO_STATE_CONNECT_ERROR")
                        delegate?.duoConnectAPFail()
                        break
                    default: print("UNKNOW STATE")
                }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error == nil {
            
            for c in service.characteristics! {
                
                print("Discover Charateristic \(c.uuid.uuidString)")
                if (c.uuid.uuidString.uppercased() == CommandUUID) {
                   
                   commandCharacteristics = c
                   activePeripheral!.setNotifyValue(true, for: commandCharacteristics!)

                  // self.performSelector(#selector(getDeviceId), withObject: nil, afterDelay: 1)
                }
                else if c.uuid.uuidString.uppercased() == StateUUID {
                    stateCharacteristics = c
                    activePeripheral!.setNotifyValue(true, for: stateCharacteristics!)
                }
            }
            
        }
    }
    
}
