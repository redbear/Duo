//
//  PopupMenuViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 30/8/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit

protocol PopupMenuDelegate {
    func versionDidTap()
    func deviceIdDidTap()
}


class PopupMenuViewController: UIViewController {
    
    var viewDelegate:PopupMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func deviceIdAction(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            self.viewDelegate?.deviceIdDidTap()
        }
        
    }
    
    @IBAction func versionAction(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            self.viewDelegate?.versionDidTap()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
