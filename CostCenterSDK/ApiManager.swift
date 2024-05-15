//
//  ApiManager.swift
//  CollectData
//
//  Created by Ho Van Ngan on 09/03/2024.
//

import Foundation

class ApiManager {
    static let instance = ApiManager()
    func callAppOpen(appInfo: AppInfo) {
        let parameters: [URLQueryItem] = [
            URLQueryItem(name: "firebase_app_instance_id", value: appInfo.firebaseAppInstanceId ?? ""),
            URLQueryItem(name: "bundle_id", value: appInfo.bundleId ?? ""),
            URLQueryItem(name: "platform", value: appInfo.platform),
            URLQueryItem(name: "vendor_id", value:  appInfo.vendorId ?? ""),
            URLQueryItem(name: "attribution_token", value: appInfo.attributionToken ?? ""),
            URLQueryItem(name: "advertising_id", value: appInfo.advertisingId ?? ""),
            URLQueryItem(name: "consent", value: "\(appInfo.consent)"),
        ]
        
        CostCenterLogger(message: "callAppOpen with parameters = \(parameters)")
        var components = URLComponents(string: "https://attribution.costcenter.net/appopen")!
        components.queryItems = parameters
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                CostCenterLogger(message: "Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                CostCenterLogger(message: "Invalid response")
                return
            }
            if !(200...299).contains(httpResponse.statusCode) {
                CostCenterLogger(message: "HTTP Response Error: \(httpResponse.statusCode)")
                return
            } else {
                if(!appInfo.consent){
                    CostCenterSDK.instance.saveFirstTimeOpenApp()
                }
            }
            CostCenterLogger(message: "statusCode = \(httpResponse.statusCode)")
        }
        task.resume()
    }
}
