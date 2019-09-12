//
//  ViewController.swift
//  DuoApp
//
//  Created by Sunny Cheung on 15/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import UIKit

import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import SSZipArchive

class ViewCotroller: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {
 

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var progress: UIProgressView!
    
    let ble = BLE()
    var version:String?
    var updateJSON:[String:Any]?
    //var wifiEnabled:Bool = false
    
    //var reachability: Reachability?
    var cm = ConnectionManager.shareInstance
    
    // Networking
    let defaultSessionConfiguration = URLSessionConfiguration.default
    
    var defaultSession:URLSession!
    
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // check Firmware
        activityLabel.text = Settings.sharedInstance.getLocalizedString("RBDUO_CHECK_F")
        activity.hidesWhenStopped = true
        activity.startAnimating()
        progress.progress = 0

        // get Current Version
        version = UserDefaults.standard.string(forKey: "FIRMWARE_VERSION")
        self.defaultSessionConfiguration.timeoutIntervalForRequest = 30
        defaultSession = URLSession(configuration: self.defaultSessionConfiguration)
        // BLE setting
        ble.delegate = ConnectionManager.shareInstance
       
    }
    
    
    override func viewDidAppear(_ _animated: Bool) {
        super.viewDidAppear(_animated)
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(networkEnabled), name: NSNotification.Name(rawValue: "NETWORK_STATUS_CHANGED"), object: nil)

        // init Check
        networkEnabled()
    }
    
    
    override func viewWillDisappear(_ _animated: Bool) {
    
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(_animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func networkEnabled() {
        if (cm.networkEnabled && !cm.apConnected) {  
            checkFirmware()
        }
        else {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Settings.sharedInstance.getLocalizedString("RBDUO_NOINTERNET"), message: Settings.sharedInstance.getLocalizedString("RBDUO_NOINTERNET_MSG"), preferredStyle: UIAlertController.Style.alert)
                

                alert.addAction(UIAlertAction(title: Settings.sharedInstance.getLocalizedString("RBDUO_OK"), style: UIAlertAction.Style.cancel, handler: { (action:UIAlertAction) in
                    
                    self.activityLabel.text = "RedBear Duo"
                    self.activity.stopAnimating()
                    self.performSegue(withIdentifier: "RBAppStartSegue", sender: nil)
                
                
                }))
                self.present(alert, animated:true, completion: nil)
//                        self.updateHandler(nil);
                            }

        }
    }
    
    private func checkFirmware() {
        let urlPath: String = "https://raw.githubusercontent.com/redbear/Duo/master/firmware/latest.json"
        let url:NSURL = NSURL(string: urlPath)!
        
        dataTask = defaultSession.dataTask(with: url as URL) {
            
            data, response, error in
            DispatchQueue.main.async {
                self.activityLabel.text = "RedBear Duo"
                self.activity.stopAnimating()
 
            }
            
            if let error = error {
                print(error.localizedDescription)
                self.performSegue(withIdentifier: "RBAppStartSegue", sender: nil)

            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                                print("ASynchronous\(jsonResult)")
                                self.updateJSON = jsonResult
                                DispatchQueue.main.async {
                                    let version: String = (jsonResult["version"] as? String)!
                                   
                                   if (version != self.version) {
                                        self.newFirmware()
                                   }
                                   else {
                                     self.performSegue(withIdentifier: "RBAppStartSegue", sender: nil)
                                   }
                                }
                        }
                        
                        
                      
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        dataTask?.resume()
        
    }
    

    
    func newFirmware() {

        let urlPath: String = (self.updateJSON?["url"] as? String)!
        let version: String = (self.updateJSON?["version"] as? String)!
        
        let session:URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        var downloadTask: URLSessionDownloadTask?
        
        let url:NSURL = NSURL(string: urlPath)!
        self.activityLabel.text = "Updating App Data..."
        self.progress.isHidden = false
        
        
        // set currurnt version
        UserDefaults.standard.set(version, forKey: "FIRMWARE_VERSION")
        UserDefaults.standard.synchronize()
        
        downloadTask = session.downloadTask(with: url as URL)
        
        downloadTask?.resume()

    }
    
    // MARK: -NSURLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.activityLabel.text = "Firmware Updated"

            self.progress.isHidden = true
        }
        
        let docDir:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let writePath = NSURL(fileURLWithPath:  docDir).appendingPathComponent((downloadTask.originalRequest!.url!.lastPathComponent))
        let fileManager = FileManager.default

        do {
            print("\(writePath?.path)")
            for file in try fileManager.contentsOfDirectory(atPath: NSURL(fileURLWithPath:  docDir).path!) {
                try fileManager.removeItem(atPath: file)
            }
            try fileManager.moveItem(atPath: (location.path), toPath: (writePath!.path))
            SSZipArchive.unzipFile(atPath: writePath!.path, toDestination: NSURL(fileURLWithPath: docDir).path!)
            
            print("DOWNLOAD OK")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "RBAppStartSegue", sender: nil)
                
            }
           
        }
        catch let error as NSError {
            // if fail, set version to nil for future update
            UserDefaults.standard.set(nil, forKey: "FIRMWARE_VERSION")
            UserDefaults.standard.synchronize()
            print(error.localizedDescription)
        }
        

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let precent:Float = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progress.progress = precent
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
   
    private func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            
            // rollback to original version
            UserDefaults.standard.set(self.version, forKey: "FIRMWARE_VERSION")
            UserDefaults.standard.synchronize()
            
            // don't do anything since download firmware fail
            self.performSegue(withIdentifier: "RBAppStartSegue", sender: nil)

        }
        
    }

    
    
}

