//
//  RBDuoNavigationController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 18/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit


class RBDuoNavigationController: UINavigationController {
    
    var imageView:UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationBar
        let image = UIImage(named: "redbearlogo")
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10,y: 2, width: 44, height: 39);
        
        navBar.addSubview(imageView)
      
        
    }
    
    func hideLogo() {
        imageView.isHidden = true
    }
    
    func showLogo() {
        imageView.isHidden = false
    }

}
