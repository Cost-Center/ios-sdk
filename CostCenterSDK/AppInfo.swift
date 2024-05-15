//
//  AppInfo.swift
//  CostCenterSDK
//
//  Created by Ho Van Ngan on 19/03/2024.
//

import Foundation

@objc public class AppInfo: NSObject {
    @objc public var firebaseAppInstanceId: String?
    @objc public var bundleId: String?
    @objc public let platform: String?
    @objc public var attributionToken: String?
    @objc public var vendorId: String?
    @objc public var advertisingId: String?
    @objc public var consent: Bool = false
    
    @objc public init(firebaseAppInstanceId: String? = "null", bundleId: String? = "null", platform: String? = "iOS",
                      attributionToken: String? = "null", vendorId: String? = "null", advertisingId: String? = "null", consent: Bool = false) {
        self.firebaseAppInstanceId = firebaseAppInstanceId
        self.bundleId = bundleId
        self.platform = platform
        self.attributionToken = attributionToken
        self.vendorId = vendorId
        self.advertisingId = advertisingId
        self.consent = consent
    }
}
