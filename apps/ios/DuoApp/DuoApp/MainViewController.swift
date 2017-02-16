//
//  MainViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 16/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//  Handle Provisioning

import UIKit
import CoreBluetooth

class MainViewController: UITableViewController {

    var duos = [CBPeripheral]()
    
    let ble:BLE = BLE()
    var device:AnyObject?
    var cm = ConnectionManager.shareInstance
    var viewIsLoaded = false// avoid duplicated segue calls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Duo"
        let nav = self.navigationController as! RBDuoNavigationController
        nav.hideLogo()
        
        // BLE
        ble.delegate = cm
        
        // refresh
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.lightGray
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(rescan), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(statusChange), name: NSNotification.Name(rawValue: "BLE_STATUS_CHANGED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(duoDiscovered), name: NSNotification.Name(rawValue: "DUO_DISCOVER_PERIPHERAL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bleDisconnected), name: NSNotification.Name(rawValue: "DUO_BLE_DISCONNECTED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bleConnected), name: NSNotification.Name(rawValue: "DUO_BLE_CONNECTED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bleScanComplete), name: NSNotification.Name(rawValue: "DUO_STOP_SCANNING"), object: nil)
      

        
        if (cm.bleEnabled) { // only do with BLE
            self.duos.removeAll()
            rescan()
        }
        
        viewIsLoaded = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NotificationCenter.default.removeObserver(self)

    }

    
//    // MARK: - menu
//    func openMenu() {
//
//    }
    
    func statusChange() {
        if (!cm.bleEnabled) {
            DispatchQueue.main.async(execute: { 
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
    }
    
    func rescan() {
        let uuid = CBUUID.init(string:ble.DuoServiceUUID)
        duos.removeAll()
        self.tableView.reloadData()
        ble.scan([uuid], time: 3)

    }
    
    // MARK: UITableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DuoDeviceCell = tableView.dequeueReusableCell(withIdentifier: "duoDeviceCell") as! DuoDeviceCell
        let peripheral = duos[indexPath.row]
        cell.nameLabel.text = peripheral.name
        cell.deviceIdLabel.text = peripheral.identifier.uuidString
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.89, blue: 0.89,alpha:1.0)
        }

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let peripheral = duos[indexPath.row]
        ble.connect(peripheral)
      //  SVProgressHUD.show()
        
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DuoBLEProvisionSegue" {
            let vc:DuoBLEProvisionTableViewController = segue.destination as! DuoBLEProvisionTableViewController
            vc.duo = ble
        }
    }
    
    
    // Notification Handler
    func duoDiscovered(_ notification:Notification) {
        print("Discovered")
        let peripheral = notification.userInfo!["peripheral"] as! CBPeripheral
        duos += [peripheral]
        tableView.reloadData()
        if (self.refreshControl != nil) {
            self.refreshControl?.endRefreshing()
        }

    }
    
    func bleDisconnected() {
        print("BLE Event")
        if !viewIsLoaded { // let viewdidappear take care
            return
        }
        
        if (cm.bleEnabled) {
            rescan()
        }
        
    }
    
    func bleScanComplete() {
        print("Finish Scanning")
        if (self.refreshControl != nil) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func bleConnected() {
   //     SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: "DuoBLEProvisionSegue", sender: nil)
    }
    
    
    
}
