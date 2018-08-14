//
//  DuoWifiProvisioningViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 5/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit
import SparkSetup
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class DuoWifiProvisioningViewController: UITableViewController, StreamDelegate, OTAUploadDelegate, UIPopoverPresentationControllerDelegate, PopupMenuDelegate {
    
    let cm = ConnectionManager.shareInstance
    var inputStream:InputStream?
    var outputStream:OutputStream?
    let duoInfo = DeviceInfo()
    let url = "192.168.0.1"
    let port = 5609
    var buff:String = ""
    var publickey:Data?
    weak var ssidAlertAction: UIAlertAction?
    weak var passAlertAction: UIAlertAction?
    var oddRow = false
    weak var firstConnectTimer:Timer?

    var aps = [AccessPoint]()

    // get Current Version
    let version =  UserDefaults.standard.string(forKey: "FIRMWARE_VERSION")


    // network state
    var fetchingDeviceId = false
    var fetchingFirmwareVersion = false
    var checkingCredential = false
    var scanningNetworks = false
    var configingAP = false
    var connectingAP = false
    var fetchingPublicKey = false
    var updatePart1 = false
    var updatePart2 = false
    var updateFac = false
    var finishedUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let nav = self.navigationController as! RBDuoNavigationController
        nav.showLogo()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.lightGray
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(scanAP), for: .valueChanged)
        self.title = SSID.fetchSSIDInfo()
        SVProgressHUD.setDefaultMaskType(.black)
        
        // popup menu
        let img = UIImage(named: "menu")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openMenu)) 
        self.navigationItem.rightBarButtonItem =  rightBarButtonItem
        
        // OTA update Delegate
        OTAUpload.sharedInstance.delegate = self
        OTAUpload.sharedInstance.setUploadVersion(version)
        
        SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("RBDUO_SCANNING_WIFI_NETWORK"))
        self.fetchingDeviceId = false
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fetchDeviceId), userInfo: nil, repeats: false)
        

    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        initNetworkCommunication()
        
        NotificationCenter.default.addObserver(self, selector: #selector(apConnected), name: NSNotification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
//        let ssid = SSID.fetchSSIDInfo()
//        
//        if (ssid.rangeOfString("^Duo-.*", options: .RegularExpressionSearch)) == nil {
//      
//           self.navigationController?.popToRootViewControllerAnimated(false)
//        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
        
    }
    
    // MARK - network
    func initNetworkCommunication() {
        
        //reset buffer
        self.buff = ""
        
        Stream.getStreamsToHost(withName: self.url, port: self.port, inputStream: &self.inputStream, outputStream: &self.outputStream)

        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        
        self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream?.open()
        self.outputStream?.open()
      

   
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
            case Stream.Event.openCompleted:
                print("Network Open Completed")
                break
            case Stream.Event.hasBytesAvailable:
                print("Network Has Bytes")
                if aStream == self.inputStream {
                    var buffer:[UInt8] = [UInt8](repeating: 0, count: 1024)
                    var len = 0
                    
                    while self.inputStream!.hasBytesAvailable {
                        len = self.inputStream!.read(&buffer, maxLength: buffer.count)
                        print("Length: \(len)")
                        if (len > 0) {
                            var output = NSString(bytes: &buffer, length: len,  encoding: String.Encoding.ascii.rawValue)
                            
                            output = output?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString?
                            if output != nil {
                                //print("Output: \(output!)")
                                //self.processJSON(output! as String!);
                                buff = buff + (output! as String)
                                if self.fetchingDeviceId {
                                    self.firstConnectTimer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(firstConnect), userInfo: buff, repeats: false)
                                }
                            }
                        }
                        
                    }
                }
                break
            case Stream.Event.errorOccurred:
                print("Network Error Occurred")
                inputStream?.close()
                outputStream?.close()
                inputStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                outputStream?.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "NETWORK_ERROR"), object: nil)
                break
            case Stream.Event.endEncountered:
                print("Network End Encountered")
                self.inputStream!.close()
                self.inputStream!.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                self.outputStream!.close()
                self.outputStream!.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                processJSON(buff)
                nextStage()
                break;
            default: break
            
        }
    }
    
  
    
    func processJSON(_ output:String) {
        print("JSON: \(output)")

       // SVProgressHUD.dismiss()
        let data = output.data(using: String.Encoding.utf8)!

        do {
            if self.fetchingDeviceId {
                print("Device Id Data")
                 let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String:AnyObject]
                duoInfo.deviceId = (json["id"] as? String)!
            }
            else if self.fetchingFirmwareVersion {
                print("Firmware Data")
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String:AnyObject]
                duoInfo.releaseVer = (json["release string"] as? String)!
                duoInfo.bootloadVer = (json["bootloader"] as? NSNumber)!.uint16Value
                
                duoInfo.systemPart1 =  (json["system part1"] as? NSNumber)!.uint16Value
                duoInfo.systemPart2 =  (json["system part2"] as? NSNumber)!.uint16Value
                duoInfo.userPart  =  (json["user part"] as? NSNumber)!.uint16Value
            }
            else if self.fetchingPublicKey {
                print("\(output)")

                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String:AnyObject]
            
                publickey =  SparkSetupSecurityManager.decodeData(fromHexString: json["b"] as? String)
                if SparkSetupSecurityManager.setPublicKey(publickey!) {
                    print("Public key stored in keychain successfully")
                }
                
            }
            else if self.scanningNetworks {
                print("Finish Scanning network")
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [ String :AnyObject]
                let scans:AnyObject = json["scans"]!
                let apArray = scans as? [AnyObject]
                aps.removeAll()
                for ap in apArray! {
                    print("\(ap)")
                    print("\(ap["ssid"])")
                    if ap["ssid"] != nil && ap["rssi"] != nil  && ap["sec"] != nil  && ap["ch"] != nil {
                            aps += [AccessPoint(json:(ap))]
                        }
                    
                }
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            else if self.configingAP {
                print("Finish Config AP")
                print("\(output)")
                
            }
            else if self.connectingAP {
                print("Connected AP")
                print("\(output)")
                SVProgressHUD.dismiss()
            }
            else if self.updatePart1 || self.updatePart2 || self.updateFac || self.finishedUpdate {
                nextUploadStage()
            }
        
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }

        
    }
    
    // first time connect there is no end acknowledgement!
    func firstConnect(_ timer:Timer) {
        self.processJSON(timer.userInfo as! String)
        self.nextStage()
    }
    
    func nextStage() {
        if self.fetchingDeviceId {
            self.firstConnectTimer?.invalidate()
            self.fetchingDeviceId = false

            self.fetchFirmwareVersion()
        }
        else if self.fetchingFirmwareVersion {
            self.fetchingFirmwareVersion = false
            checkFirmware()
        }
        else if self.fetchingPublicKey {
            self.fetchingPublicKey = false
            
            scanAP()
        }
        else if self.scanningNetworks {
            self.scanningNetworks = false
            self.refreshControl?.endRefreshing()
        }
        else if self.configingAP {
            self.configingAP = false
            self.connectAP()
        }
        else if self.connectingAP {
            self.connectingAP = false
            self.apConnected()
        }
    }
    
    // OTA Upload
    func nextUploadStage() {
        if version != nil { // Invalid update if version is nil
            do {
                if self.updatePart1 {
                    self.updatePart1 = false
                    try OTAUpload.sharedInstance.uploadPart1(true)
                    
                }
                else if self.updatePart2 {
                    self.updatePart2 = false
                    try OTAUpload.sharedInstance.uploadPart2(true)

                }
                else if self.updateFac {
                    self.updateFac = false
                    try OTAUpload.sharedInstance.uploadFac(true)
                }
                else if self.finishedUpdate {
                    self.finishedUpdate = false
                    print("finish update and reset")
                    // close progress bar
                    SVProgressHUD.dismiss()
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDeviceId() {
        print("Fetching Device ID")
       
        self.fetchingDeviceId = true
        let s = "device-id\n0\n\n"
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
        
        
    }
    
    func fetchFirmwareVersion() {
        print("Fetching Firmware Version")
        initNetworkCommunication()

        self.fetchingFirmwareVersion = true
        let s = "version\n0\n\n"
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
        
    }
    
    func fetchPublicKey() {
        print("Fetching Firmware Version")
        initNetworkCommunication()
        
        self.fetchingPublicKey = true
        let s = "public-key\n0\n\n"
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
        
    }
    
    func scanAP() {
        SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("RBDUO_SCANNING_WIFI_NETWORK"))
        oddRow = false
        buff=""
         print("Scanning AP")
        if (self.fetchingFirmwareVersion || self.fetchingDeviceId) {
            self.refreshControl?.endRefreshing()
            return
        }
        initNetworkCommunication()
       
        self.scanningNetworks = true
        let s = "scan-ap\n0\n\n"
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
    }
    
    func setAPInfo(_ ap:AccessPoint, password:String="") {
        print("Config AP")
        initNetworkCommunication()
        self.configingAP = true
        
        var s1:String!
        var stringRange:NSRange = NSMakeRange(0, min(password.characters.count, 64))
        stringRange = (password as NSString).rangeOfComposedCharacterSequences(for: stringRange)
        let passcodeTruncated = (password as NSString).substring(with: stringRange)
        var hexEncodedEncryptedPasscodeStr:NSString?
        
        if ap.security != 0 { // Encryption
            
            let pubKey = SparkSetupSecurityManager.getPublicKey()
            let plainTextData = passcodeTruncated.data(using: String.Encoding.utf8)
            let cipherTextData = SparkSetupSecurityManager.encrypt(withPublicKey: pubKey?.takeUnretainedValue(), plainText: plainTextData)
            if cipherTextData != nil {
                hexEncodedEncryptedPasscodeStr = SparkSetupSecurityManager.encodeData(toHexString: cipherTextData) as NSString?
                s1 = String(format:"{\"ch\":\(ap.channel),\"pwd\":\"\(hexEncodedEncryptedPasscodeStr!)\",\"idx\":0,\"ssid\":\"\(ap.ssid)\",\"sec\":\(ap.security)}")
            }
            else {
                print("Error")
            }
            
        }
        else {
             s1 = String(format:"{\"ch\":\(ap.channel),\"pwd\":\"\(passcodeTruncated)\",\"idx\":0,\"ssid\":\"\(ap.ssid)\",\"sec\":\(ap.security)}")
        }
        
        print(s1)
        let s = String(format: "configure-ap\n\(s1.lengthOfBytes(using: String.Encoding.utf8))\n\n\(s1)")
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)

    }
    
    func connectAP() {
        print("Connecting AP")
        initNetworkCommunication()
        self.connectingAP = true
        

        let s = String(format:"connect-ap\n9\n\n{\"idx\":0}")

        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
        
    }
    
    func apConnected() {
        if  cm.apConnected {
            self.performSegue(withIdentifier: "FinishWifiProvisionSegue", sender: nil)
        }
        else {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    
    
    func checkFirmware() {
        if  version != nil && version != duoInfo.releaseVer {
            self.newFirmware()
        }
        else {
            self.fetchPublicKey()
        }
    }
    
    func newFirmware() {
    
        let alert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("RBDUO_F_UPDATEFW"), message: Settings.sharedInstance.getLocalizedString("RBDUO_HW_F_NFW"), preferredStyle: UIAlertControllerStyle.alert)
        
        // Update new Firmware
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_HW_UPGRADE"), style: UIAlertActionStyle.default, handler: self.updateHandler))
        
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.cancel, handler: { (action:UIAlertAction) in
            SVProgressHUD.dismiss()
            self.fetchPublicKey()
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aps.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManualAPCell")
            return cell!
        }
        
        // SSID from Duo
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessPointCell") as! AccessPointTableViewCell
        let ap = aps[indexPath.row - 1]
        cell.setAP(ap)
        if !oddRow {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.89, blue: 0.89,alpha:1.0)
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        oddRow = !oddRow
        if (ap.ssid.lengthOfBytes(using: String.Encoding.ascii) == 0) {
            cell.isHidden = true
            oddRow = !oddRow // reverse color
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 58
        }
        let ap = aps[indexPath.row - 1]
        if (ap.ssid.lengthOfBytes(using: String.Encoding.ascii) == 0) {
            return 0.0
        }
        return 58
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            var ssidTextField: UITextField?
            var passwordTextField: UITextField?
            let alert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("ENTER_WIFI_INFORMATION"), message: Settings.sharedInstance.getLocalizedString("ENTER_WIFI_INFO_MSG"), preferredStyle:.alert)
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.addTarget(self, action: #selector(self.ssidTextChange(_:)), for: .editingChanged)
                textField.placeholder = "SSID"
                ssidTextField = textField
            });
            
            
            let ssidAlertAction = UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                
                func secHandler(_ action:UIAlertAction) {
                    if action.title != "None" {
                        var sec = APSecurity.AP_SECURITY_OPEN
                        switch action.title! {
                        case "WEP" : sec = APSecurity.AP_SECURITY_WEP
                            break
                        case "WEP Shared" : sec = APSecurity.AP_SECURITY_WEP_SHARED
                            break
                        case "WPA TKIP" : sec = APSecurity.AP_SECURITY_WPA_TKIP
                            break
                        case "WPA AES" : sec = APSecurity.AP_SECURITY_WPA_AES
                            break
                        case "WPA2 TKIP" : sec = APSecurity.AP_SECURITY_WPA2_TKIP
                            break
                        case "WPA2 AES" : sec = APSecurity.AP_SECURITY_WPA2_AES
                            break
                        default : sec = APSecurity.AP_SECURITY_WPA2_MIXED
                            
                        }
                        
                        let passAlert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("ENTER_WIFI_CREDENTIAL"), message: Settings.sharedInstance.getLocalizedString("ENTER_WIFI_CREDENTIAL_MSG"), preferredStyle:.alert)
                        
                        passAlert.addTextField(configurationHandler: {(textField: UITextField!) in
                            textField.addTarget(self, action: #selector(self.passTextChange(_:)), for: .editingChanged)
                            textField.placeholder = "Enter Password"
                            textField.isSecureTextEntry = true
                            passwordTextField = textField
                        })
                        
                        let passAlertAction = UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                            
                            let ssid = ssidTextField?.text
                            let password =  passwordTextField?.text
                            let ap = AccessPoint(sid:ssid!, sec: sec.rawValue)
                            SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
                            self.setAPInfo(ap, password: password!)
                        })
                        
                        passAlert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                            SVProgressHUD.dismiss()
                        }))
                        
                        passAlertAction.isEnabled = false
                        passAlert.addAction(passAlertAction)
                        self.passAlertAction = passAlertAction

                        self.present(passAlert, animated: true, completion: nil)
                    }
                    else {
                        let ssid = ssidTextField?.text
                        let ap = AccessPoint(sid:ssid!, sec: APSecurity.AP_SECURITY_OPEN.rawValue)
                        self.setAPInfo(ap)
                    }

                }
                
                // let ssid = ssidTextField?.text
                
                let secAlert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("WIFI_ENCRYPTION"), message: nil, preferredStyle:.actionSheet)
                secAlert.addAction(UIAlertAction(title: "None", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WEP", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WEP Shared", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WPA TKIP", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WPA AES", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WPA2 TKIP", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WPA2 AES", style:.default, handler: secHandler))
                secAlert.addAction(UIAlertAction(title: "WPA2 MIXED", style:.default, handler: secHandler))
                self.present(secAlert, animated: false, completion: nil)
                
                
                //                SVProgressHUD.showWithStatus(Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
                //                self.duo.setAPInfo(ap, password: password!)
            })
            
            alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                SVProgressHUD.dismiss()
            }))
            
            ssidAlertAction.isEnabled = false
            alert.addAction(ssidAlertAction)
            self.ssidAlertAction = ssidAlertAction
            
            self.present(alert, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)

            return
        }

        // SSID info from Duo
        let ap = aps[indexPath.row - 1]
        
        if ap.connectNeedPassword() { // need password
            var inputTextField: UITextField?
            let alert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("ENTER_WIFI_CREDENTIAL"), message: "\(ap.ssid)\n" + Settings.sharedInstance.getLocalizedString("ENTER_WIFI_CREDENTIAL_MSG"), preferredStyle:.alert)
            
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.addTarget(self, action: #selector(self.passTextChange(_:)), for: .editingChanged)

                textField.placeholder = "Enter Password"
                textField.isSecureTextEntry = true
                inputTextField = textField
            })
            let passAlertAction = UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                let password = inputTextField?.text
                SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
                self.setAPInfo(ap, password: password!)
            })
            
            alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                SVProgressHUD.dismiss()
            }))
            
            passAlertAction.isEnabled = false
            alert.addAction(passAlertAction)
            self.passAlertAction = passAlertAction
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
            self.setAPInfo(ap)
        }
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    // MARK: - menu
    func openMenu() {
        self.performSegue(withIdentifier: "menuSegue", sender: nil)

    }
    
    
    // Update Part1
    func updateHandler(_ action:UIAlertAction) {
        // upload System PArt1
        initNetworkCommunication()
        
        self.updatePart1 = true
        print("Prepare updating Part 1")
        let len = OTAUpload.sharedInstance.fileSize("duo-system-part1-v" + version! + ".bin")
        let json = "{\"file_length\":\(len),\"chunk_address\":0,\"chunk_size\":128,\"file_store\":0}"
        let s = String(format:"prepare-update\n\(json.lengthOfBytes(using: String.Encoding.utf8))\n\n\(json)")
        print("send Part1: \(s)")
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
  
        
    }

    // MARK: OTAUpdateDelegate
    func progress(_ p: Int) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.showProgress(Float(p))
    }

    
    func uploadPart2() {
        self.updatePart2 = true
        initNetworkCommunication()
        print("Prepare updating Part 2")
        var curr_addr = OTAUpload.sharedInstance.fileSize("duo-system-part1-v" + version! + ".bin")
        let len = OTAUpload.sharedInstance.fileSize("duo-system-part2-v" + version! + ".bin")
        var regionIndex = 0
        
        if (curr_addr % OTAUpload.sharedInstance.OTA_REGION_UNIT_SIZE == 0) {
            regionIndex = curr_addr / OTAUpload.sharedInstance.OTA_REGION_UNIT_SIZE
        }
        else {
            regionIndex = (curr_addr / OTAUpload.sharedInstance.OTA_REGION_UNIT_SIZE) + 1
        }
        curr_addr = regionIndex * OTAUpload.sharedInstance.OTA_REGION_UNIT_SIZE
        
        let json = "{\"file_length\":\(len),\"chunk_address\":\(curr_addr),\"chunk_size\":128,\"file_store\":0}"
        let s = String(format:"prepare-update\n\(json.lengthOfBytes(using: String.Encoding.utf8))\n\n\(json)")
        print("send Part2: \(s)")
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
    }
    
    func uploadFac() {
        self.updateFac = true
        initNetworkCommunication()
        print("Prepare updating Fac")
        let len = OTAUpload.sharedInstance.fileSize("duo-fac-web-server-v" + version! + ".bin")
        let json = "{\"file_length\":\(len),\"chunk_address\":\(OTAUpload.sharedInstance.FAC_REGION_ADDR),\"chunk_size\":128,\"file_store\":1}"
        let s = String(format:"prepare-update\n\(json.lengthOfBytes(using: String.Encoding.utf8))\n\n\(json)")
        print("send Fac: \(s)")
        let data = s.data(using: String.Encoding.utf8)
        
        self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
    }
    
    func finishUploading() {
        
        print("All upload finished")
        self.finishedUpdate = true
        initNetworkCommunication()
        // Should set Reset string
        let s = "finish-update\n0\n\n"
        let data = s.data(using: String.Encoding.utf8)
        
         self.outputStream?.write( (data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count), maxLength: data!.count)
    }
    
    // MARK: - UITextField
    func ssidTextChange(_ sender:UITextField) {
        self.ssidAlertAction?.isEnabled = (sender.text?.characters.count > 0)
    }
    
    func passTextChange(_ sender:UITextField) {
        self.passAlertAction?.isEnabled = (sender.text?.characters.count >= 8)
    }
    
    // MARK: - popupMenuDelegate
    func deviceIdDidTap() {
        if self.duoInfo.deviceId != nil {
            let alert = UIAlertController(title: "Device ID", message: "\(self.duoInfo.deviceId!.lowercased())", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func versionDidTap() {
        let alert = UIAlertController(title: "Firmware version", message: "Released Version: \(self.duoInfo.releaseVer!)\nBootloader: \(self.duoInfo.bootloadVer)\nSystem Part 1: \(self.duoInfo.systemPart1)\nSystem Part 2: \(self.duoInfo.systemPart2)\nUser Part: \(self.duoInfo.userPart) ", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            let vc = segue.destination as! PopupMenuViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.popover  //UIModalPresentation.Popover;
            vc.popoverPresentationController!.delegate = self;
            vc.viewDelegate = self
            
            vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            // vc.popoverPresentationController?.sourceView setSourceView:((GroveConditionCell *)sender).op2Button];
        }
        else if (segue.identifier == "FinishWifiProvisionSegue") {
            let vc = segue.destination as! DuoInfoViewController
            vc.duoInfo = self.duoInfo
        }
    }

    // MARK: - PopoverPresentationViewControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
}
