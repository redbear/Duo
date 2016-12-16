//
//  Settings.swift
//  DuoApp
//
//  Created by Sunny Cheung on 15/7/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

import Foundation

class Settings: NSObject{
    
    static let sharedInstance = Settings();
    
    var bundle:Bundle!
    var currentLanguage:String?
    let availableLanague:Dictionary<String, String> = ["en":"English", "zh-Hans":"简体中文", "zh-Hant":"繁体中文","ja":"日本語"]
    
    override init() {
        super.init()
        let lang = UserDefaults.standard.string(forKey: "LANGUAGE_SETTING")
        if (lang != nil) {
            self.bundle = Bundle.init(path: Bundle.main.path(forResource: lang, ofType: "lproj")!)
            self.currentLanguage = self.availableLanague[lang!]
        }
        else {
            self.bundle = Bundle.init(path:Bundle.main.path(forResource: "Base", ofType: "lproj")!)
            self.currentLanguage = self.availableLanague["Base"]

        }
        
    }
    
    func getLocalizedString(_ key:String) -> String {
        return  NSLocalizedString(key, tableName: nil, bundle: self.bundle, comment: "")
    }
    
    func setSelectedLanguage(_ selectedLanguage:String!) {
        self.currentLanguage = self.availableLanague[selectedLanguage]
        self.bundle = Bundle.init(path: Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")!)
        UserDefaults.standard.set(selectedLanguage, forKey: "LANGUAGE_SETTING")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
    
    
    
}
