//
//  DuoInfoViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 6/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit


class DuoInfoViewController: UIViewController {
    @IBOutlet weak var breathGreen:UIView!
    @IBOutlet weak var blinkingGreen: UIView!
    @IBOutlet weak var breathBlue:UIView!
    @IBOutlet weak var blinkingBlue:UIView!
    @IBOutlet weak var connectToWifiLabel:UILabel!
    @IBOutlet weak var connectToCloudLabel:UILabel!
    @IBOutlet weak var connectingLabel:UILabel!
    @IBOutlet weak var failToConnectLabel:UILabel!
    var alertShow = false
    weak var duoInfo:DeviceInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let nav = self.navigationController as! RBDuoNavigationController
        nav.hideLogo()
        // popup menu
//        let img = UIImage(named: "menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(openMenu))

     //   self.navigationItem.rightBarButtonItem =  rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(title: "< back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(networkChange))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(networkChange))
        self.view.addGestureRecognizer(gesture)
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        connectToWifiLabel.text = Settings.sharedInstance.getLocalizedString("BREATHGREEN_LABEL")
        connectToCloudLabel.text = Settings.sharedInstance.getLocalizedString("BREATHBLUE_LABEL")
        connectingLabel.text = Settings.sharedInstance.getLocalizedString("BLINKINGGREEN_LABEL")
        failToConnectLabel.text = Settings.sharedInstance.getLocalizedString("BLINKINGBLUE_LABEL")
        let ssid = SSID.fetchSSIDInfo()
        self.title = ssid

        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    func networkChange() {
        if !alertShow {
            alertShow = true
            let alert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("PROVISION_FINISHED"), message: Settings.sharedInstance.getLocalizedString("PROVISION_FINISHED_MSG"), preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                         self.navigationController?.popToRootViewController(animated: true)
                    
                        
            
                
            }))
    //        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_CANCEL"), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
    //        }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func startAnimation() {
        animate(breathGreen, speed: 1)
        animate(blinkingBlue, speed:0.12)
        animate(blinkingGreen, speed:0.12)
        animate(breathBlue, speed:1)
        
    }
    
    func animate(_ view:UIView, speed:TimeInterval) {
        view.alpha = 1.0
        
        UIView.animate(withDuration: speed, delay: 0.0, options:[.repeat, .autoreverse], animations: { 
                view.alpha = 0.0
        }) { (finished:Bool) in
            
        }
        
        
    }
    
    
//    // MARK: - popupMenuDelegate
//    func deviceIdDidTap() {
//        let alert = UIAlertController(title: "Device ID", message: "\(self.duoInfo!.deviceId!)", preferredStyle:.Alert)
//        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//        
//    }
//    
//    func versionDidTap() {
//        let alert = UIAlertController(title: "Firmware version", message: "Bootloader: \(self.duoInfo!.bootloadVer)\nSystem Part 1: \(self.duoInfo!.systemPart1)\nSystem Part 2: \(self.duoInfo!.systemPart2)\nUser Part: \(self.duoInfo!.userPart) ", preferredStyle:.Alert)
//        alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//        
//    }
//    
//    // MARK: - Segue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "menuSegue") {
//            let vc = segue.destinationViewController as! PopupMenuViewController
//            vc.modalPresentationStyle = UIModalPresentationStyle.Popover  //UIModalPresentation.Popover;
//            vc.popoverPresentationController!.delegate = self;
//            vc.viewDelegate = self
//            
//            vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//            // vc.popoverPresentationController?.sourceView setSourceView:((GroveConditionCell *)sender).op2Button];
//        }
//    }
//    
//    // MARK: - PopoverPresentationViewControllerDelegate
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.None
//    }
//
//    
//    // MARK: - menu
//    func openMenu() {
//        
//        self.performSegueWithIdentifier("menuSegue", sender: nil)
//
//    }
}
