//
//  MenuTableViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 29/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        let nav = self.navigationController as! RBDuoNavigationController
        nav.showLogo()

        NotificationCenter.default.addObserver(self, selector: #selector(checkStatus), name: NSNotification.Name(rawValue: "BLE_STATUS_CHANGED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkStatus), name: NSNotification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)
        
        checkStatus()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func checkStatus() {
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiProvisionCell")
            let imageView = cell?.viewWithTag(777) as? UIImageView
            let labelView = cell?.viewWithTag(888) as? UILabel
            let btn = cell?.viewWithTag(999) as? UIButton

            if (!ConnectionManager.shareInstance.wifiEnabled) {
                imageView?.image = UIImage(named: "WiFi-inactive-1")
                labelView?.text = Settings.sharedInstance.getLocalizedString("RBDUO_WIFI_DISABLED")
                labelView?.textColor = UIColor.gray
                btn?.backgroundColor = UIColor.gray
                btn?.isEnabled = false
            }
            else {
                imageView?.image = UIImage(named: "WiFi-active-1")
                labelView?.text = Settings.sharedInstance.getLocalizedString("RBDUO_WIFI_PROVISION")
                labelView?.textColor = UIColor(red: 186.0/255, green: 48.0/255, blue: 55.0/255, alpha: 1.0)
                btn?.backgroundColor = UIColor(red: 186.0/255, green: 48.0/255, blue: 55.0/255, alpha: 1.0)
                btn?.isEnabled = true
            }
            
            return cell!
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLEProvisionCell")
        
        let imageView = cell?.viewWithTag(777) as? UIImageView
        let labelView = cell?.viewWithTag(888) as? UILabel
        let btn = cell?.viewWithTag(999) as? UIButton

        
        if (!ConnectionManager.shareInstance.bleEnabled) {
            imageView?.image = UIImage(named: "BLE-inactive")
            labelView?.text = Settings.sharedInstance.getLocalizedString("RBDUO_BLE_DISABLED")

            labelView?.textColor = UIColor.gray
            btn?.backgroundColor = UIColor.gray
            btn?.isEnabled = false
        }
        else {
            imageView?.image = UIImage(named: "BLE-active")
            labelView?.text = Settings.sharedInstance.getLocalizedString("RBDUO_BLE_PROVISION")

            labelView?.textColor = UIColor(red: 186.0/255, green: 48.0/255, blue: 55.0/255, alpha: 1.0)
            btn?.backgroundColor = UIColor(red: 186.0/255, green: 48.0/255, blue: 55.0/255, alpha: 1.0)
            btn?.isEnabled = true
        }
        

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //let currentHeight =  self.view.bounds.size.height
        
        return 250
        
    }
    
    
}
