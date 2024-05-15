//
//  CostCenterSDK.swift
//  CostCenterSDK
//
//  Created by Ho Van Ngan on 07/03/2024.
//

import Foundation
import FirebaseCore
import AppTrackingTransparency
import AdSupport
import AdServices
import FirebaseInstallations
import FirebaseCoreInternal

public class CostCenterSDK : NSObject{
    @objc public static let instance = CostCenterSDK()
    @objc public var appInfo = AppInfo()
    var isShowingLog =  false
    private let KEY_INSTALLATION_ID = "KEY_INSTALLATION_ID"
    private let KEY_FIRST_TIME_OPEN_APP = "KEY_FIRST_TIME_OPEN_APP"
    
    @objc public func initialize(app: AnyClass, logger: Bool = false){
        isShowingLog = logger
        appInfo.bundleId = Bundle(for: app.self).bundleIdentifier
        appInfo.vendorId = UIDevice.current.identifierForVendor?.uuidString
        if #available(iOS 14.3, *){
            do {
                appInfo.attributionToken = try AAAttribution.attributionToken()
            } catch {
                
            }
        }
        if (FirebaseApp.app() != nil) {
            Installations.installations().installationID { (installationID, error) in
                if let error = error {
                    CostCenterLogger(message: "Error getting Firebase Installation ID: \(error.localizedDescription)")
                } else if let installationID = installationID {
                    CostCenterLogger(message:"Firebase Installation ID: \(installationID)")
                    let data = Data(base64URLEncoded: installationID)!
                    var hex32String = ""
                    for byte in data {
                        hex32String += String(format: "%02x", byte)
                    }
                    self.appInfo.firebaseAppInstanceId = hex32String
                    if !self.isFirstTimeOpenApp() {
                        UserDefaults.standard.set(hex32String, forKey: self.KEY_INSTALLATION_ID)
                        ApiManager.instance.callAppOpen(appInfo: self.appInfo)
                    }
                }
            }
        } else {
            if !self.isFirstTimeOpenApp() {
                ApiManager.instance.callAppOpen(appInfo: self.appInfo)
            }
        }
        AdManager.instance.getAdvertisingIdentifier { advertisingId in
            if(advertisingId != nil) {
                if let installationId = UserDefaults.standard.string(forKey: self.KEY_INSTALLATION_ID) {
                    self.appInfo.firebaseAppInstanceId = installationId
                }
                self.appInfo.consent = true
                self.appInfo.advertisingId = advertisingId
                ApiManager.instance.callAppOpen(appInfo: self.appInfo)
            } else {
                CostCenterLogger(message: "AdvertisingId unavailable")
            }
            
        }
        CostCenterLogger(message: "CostCenterSDK initialized")
        
    }
    
    func saveFirstTimeOpenApp() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: KEY_FIRST_TIME_OPEN_APP)
        defaults.synchronize()
    }
    
    private func isFirstTimeOpenApp() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: KEY_FIRST_TIME_OPEN_APP)
    }
    
}

func CostCenterLogger(message: String) {
    if CostCenterSDK.instance.isShowingLog {
        NSLog("\(message)")
    }
}
