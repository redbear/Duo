//
//  AccessPointTableViewCell.swift
//  DuoApp
//
//  Created by Sunny Cheung on 21/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit

class AccessPointTableViewCell: UITableViewCell {
    @IBOutlet weak var ssidLabel:UILabel!
  //  @IBOutlet weak var macLabel:UILabel!
    @IBOutlet weak var wifiImageView:UIImageView!
    
    func setAP(_ ap:AccessPoint) {
        
        ssidLabel.text = ap.ssid
        var image:UIImage
        var name:String = "open"
        if ap.connectNeedPassword() {
            name = "lock"
        }
        
        
        if (ap.rssi > -50) {
            image = UIImage(named: name + "_signal4")!
        }
        else if ap.rssi > 750 {
            image = UIImage(named: name + "_signal3")!
        }
        else if ap.rssi > -80 {
            image = UIImage(named: name + "_signal2")!
            
        }
        else if ap.rssi > -90 {
           image = UIImage(named: name + "_signal1")!
        }
        else {
            image = UIImage(named: name + "_signal0")!
        }
        wifiImageView.image = image
        
    //    macLabel.text = ap.mac
        
    }
}
