//
//  AdsManager.swift
//  CollectData
//
//  Created by Ho Van Ngan on 08/03/2024.
//

import Foundation
import AppTrackingTransparency
import AdSupport

class AdManager {
    
    static let instance = AdManager()
    private let KEY_ADVERTISING_ID = "KEY_ADVERTISING_ID"
    
    func getAdvertisingIdentifier(completion: @escaping (String?) -> Void) {
        if UserDefaults.standard.string(forKey: KEY_ADVERTISING_ID) != nil {
            return
        }
        if #available(iOS 14, *) {
            if(ATTrackingManager.trackingAuthorizationStatus == ATTrackingManager.AuthorizationStatus.authorized) {
                let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                UserDefaults.standard.set(advertisingId, forKey: self.KEY_ADVERTISING_ID)
                completion(advertisingId)
            } else {
                completion(nil)
            }
        } else {
            let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            completion(advertisingId)
        }
        
    }
}

