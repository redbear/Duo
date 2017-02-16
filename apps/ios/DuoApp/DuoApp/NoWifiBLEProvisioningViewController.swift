//
//  NoWifiBLEProvisioningViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 5/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit


class NoWifiBLEProvisioningViewController: UIViewController {

    let cm = ConnectionManager.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // popup menu
        let img = UIImage(named: "menu")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openMenu))
        self.navigationItem.rightBarButtonItem =  rightBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(bleStatusChanged), name: NSNotification.Name(rawValue: "BLE_STATUS_CHANGED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wifiStatusChanged), name: NSNotification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -Notification 
    func bleStatusChanged() {
        if cm.bleEnabled {
           
            self.navigationController?.popToRootViewController(animated: false)
          
        }
    }
    
    func wifiStatusChanged() {
        if cm.wifiEnabled {
            

            self.navigationController?.popToRootViewController(animated: false)
        
        }
        
        
    }
    
    // MARK: - menu
    func openMenu() {
               
    }
}
