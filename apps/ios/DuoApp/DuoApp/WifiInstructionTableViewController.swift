//
//  WifiInstructionTableViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 22/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension


class WifiInstructionTableViewController: UITableViewController {
    
    let cm = ConnectionManager.shareInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let nav = self.navigationController as! RBDuoNavigationController
        nav.hideLogo()

        self.title = "RedBear"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        super.viewDidAppear(animated)
       // self.navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(apConnected), name: NSNotification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wakeupFromBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        if cm.apConnected {
            print("Connected to AP")
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(wifiProvision), userInfo: nil, repeats: false)

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    
    // MARK: -tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            case 0: return 290
            case 1: return 144
            case 2: return 139
            default: return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId:String
        switch indexPath.row {
            case 0: cellId = "step1Cell"
                break
            case 1: cellId = "step2Cell"
                break
            case 2: cellId = "step3Cell"
                break
            default: cellId = "step1Cell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cellId == "step1Cell" {
            let button = cell?.viewWithTag(123) as! UIButton
            button.addTarget(self, action: #selector(wifiSetting), for: UIControlEvents.touchDown)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: Notification Handler
    func apConnected() {
        if  cm.apConnected {
            let notification = UILocalNotification()
            notification.alertBody = "Connected to RedBear Duo"
            notification.fireDate = Date(timeIntervalSinceNow: 1)
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
//        else if !cm.wifiEnabled { // wifi turn off
//            dispatch_async(dispatch_get_main_queue()) {
//                self.navigationController?.popViewControllerAnimated(false)
//            }
//        }
    }
    
    // Timer Launch event
    func wifiProvision() {
        self.performSegue(withIdentifier: "WifiProvisioningSegue", sender: nil)
    }
    
    func wifiSetting() {
        print("Wifi Setting")
        let url = URL(string: "prefs:root=WIFI")!
        UIApplication.shared.openURL(url)
        
    }
    
    func wakeupFromBackground(_ notifcation:Notification?) {
        print("wake up")
        // dont perform segue if already in wifi provisioning
        if cm.apConnected {
            print("Connected to AP")
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(wifiProvision), userInfo: nil, repeats: false)
            
        }

    }
}
