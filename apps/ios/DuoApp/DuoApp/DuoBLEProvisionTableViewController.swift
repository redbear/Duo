//
//  DuoWifiProvisionTableViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 20/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit
import CoreBluetooth
import RWDropdownMenu
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


class DuoBLEProvisionTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, PopupMenuDelegate {
    
    var duo:BLE!
    var deviceInfo:DeviceInfo?
    var aps = [AccessPoint]()
    var oddRow = false
    weak var ssidAlertAction: UIAlertAction?
    weak var passAlertAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController as! RBDuoNavigationController
        nav.hideLogo()
        self.title = duo.activePeripheral?.name
        SVProgressHUD.setDefaultMaskType(.black)

        // refresh control
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.lightGray
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(scanAP), for: .valueChanged)

        // popup menu
        let img = UIImage(named: "menu")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openMenu))
        self.navigationItem.rightBarButtonItem =  rightBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(statusChange), name: NSNotification.Name(rawValue: "BLE_STATUS_CHANGED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onGetDeviceId), name: NSNotification.Name(rawValue: "DUO_DEVICEINFO"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addAP), name: NSNotification.Name(rawValue: "DUO_FOUNDAP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startScan), name: NSNotification.Name(rawValue: "DUO_SCANNING_AP"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(completeScan), name: NSNotification.Name(rawValue: "DUO_AP_SCANNING_COMPLETE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(completeConfig), name: NSNotification.Name(rawValue: "DUO_AP_COMPLETE_CONFIG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(apConnecting), name: NSNotification.Name(rawValue: "DUO_AP_CONNECTING"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(apConnected), name: NSNotification.Name(rawValue: "DUO_AP_CONNECT_COMPLETE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(apConnectFail), name: NSNotification.Name(rawValue: "DUO_AP_CONNECT_FAIL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(duoDisconnected), name: NSNotification.Name(rawValue: "DUO_DISCONNECTED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishProvisioning), name: NSNotification.Name(rawValue: "DUO_FINISH_PROVISIONING"), object: nil)
       
        SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("RBDUO_SCANNING_WIFI_NETWORK"))
        self.perform(#selector(getDeviceId), with: nil, afterDelay: 1)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        duo.disconnect()
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }
    
    func statusChange() {
        if (!ConnectionManager.shareInstance.bleEnabled) {
            DispatchQueue.main.async(execute: { 
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func scanAP() {
        oddRow = false
        duo.duoAPScan()
    }
    
    func getDeviceId() {
        duo.getDeviceId()
    }
    
    // MARK: -notification
    
    func duoDisconnected() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func onGetDeviceId(_ notification:Notification) {
        print("\(notification.userInfo)")
        deviceInfo = DeviceInfo.init(data:notification.userInfo!["data"] as! Data)
        duo.duoAPScan()

    }
    
    func addAP(_ notification:Notification) {
        
        let ap:AccessPoint = AccessPoint.init(data:notification.userInfo!["data"] as! Data)
        aps += [ap]
    }
    
    func startScan() {
        
        aps.removeAll()
        SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("RBDUO_SCANNING_WIFI_NETWORK"))
    }
    
    func completeScan() {
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        self.refreshControl?.endRefreshing()
    }
    
    func completeConfig() {
        duo.apConnect()
    }
    
    
    func apConnecting() {
        
    }
    
    func apConnected() {
        SVProgressHUD.dismiss()
    }
    
    func finishProvisioning(_ notification:Notification) {
        let duoIpInfo = DuoIpInfo(data:notification.userInfo!["data"] as! Data)
        
        let alert = UIAlertController(title: "Duo", message: duoIpInfo.printString(), preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                self.navigationController?.popToRootViewController(animated: true)
            
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func apConnectFail() {
        SVProgressHUD.showError(withStatus: Settings.sharedInstance.getLocalizedString("CANNOT_CONNECT_AP"))
        self.navigationController?.popToRootViewController(animated: true)
        
    }
  
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aps.count + 1
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManualAPCell")
            return cell!
        }
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
                        
                        let passAlertAction = UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                            
                            let ssid = ssidTextField?.text
                            let password =  passwordTextField?.text
                            let ap = AccessPoint(sid:ssid!, sec: sec.rawValue)
                            SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
                            self.duo.setAPInfo(ap, password: password!)
                        })
                        
                        passAlert.addTextField(configurationHandler: {(textField: UITextField!) in
                             textField.addTarget(self, action: #selector(self.passTextChange(_:)), for: .editingChanged)
                             textField.placeholder = "Enter Password"
                            textField.isSecureTextEntry = true
                            passwordTextField = textField
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
                        self.duo.setAPInfo(ap)
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
            ssidAlertAction.isEnabled = false
            alert.addAction(ssidAlertAction)
            self.ssidAlertAction = ssidAlertAction
            
            alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                SVProgressHUD.dismiss()
            }))

            self.present(alert, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: false)

            return
        }
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
            
            let passAlertAction  = UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                let password = inputTextField?.text
                SVProgressHUD.show(withStatus: Settings.sharedInstance.getLocalizedString("AP_CONNECTING") + "\(ap.ssid)...")
                self.duo.setAPInfo(ap, password: password!)
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
            duo.setAPInfo(ap)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - menu
    func openMenu() {
        
        self.performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    // MARK: - UITextField
    func ssidTextChange(_ sender:UITextField) {
   
        self.ssidAlertAction?.isEnabled = (sender.text?.characters.count > 0)

    }
    
    func passTextChange(_ sender:UITextField) {
         self.passAlertAction?.isEnabled = (sender.text?.characters.count >= 8)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "menuSegue") {
            let vc = segue.destination as! PopupMenuViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.popover  //UIModalPresentation.Popover;
            vc.popoverPresentationController!.delegate = self;
            vc.viewDelegate = self
        
            vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
           // vc.popoverPresentationController?.sourceView setSourceView:((GroveConditionCell *)sender).op2Button];
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - popupMenuDelegate
    func deviceIdDidTap() {
        let alert = UIAlertController(title: "Device ID", message: "\(self.deviceInfo!.deviceId!.lowercased())", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func versionDidTap() {
        let alert = UIAlertController(title: "Firmware version", message: "Released Version: \(self.deviceInfo!.releaseVer!)\nBootloader: \(self.deviceInfo!.bootloadVer)\nSystem Part 1: \(self.deviceInfo!.systemPart1)\nSystem Part 2: \(self.deviceInfo!.systemPart2)\nUser Part: \(self.deviceInfo!.userPart) ", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
  }
