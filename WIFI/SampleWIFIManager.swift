//
//  WifiConnectionManager.swift
//
//  Created by Jay Bergonia on 24/9/2018.
//  Copyright © 2018 XiApps. All rights reserved.
//

import Foundation
import NetworkExtension
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

public class WifiConnectionManager: NSObject {
    
    static let sharedinstance: WifiConnectionManager = {WifiConnectionManager()}()
    var reachability = Reachability()!
    var isConnectedToWifi: Bool = false
    var gotDisconnected: Bool  = false
    
    let REMOTE_URL: String = "https://www.apple.com/"
    
    override init() {
        super.init()
        self.checkForConnectionUpdates()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("*** Reachable via WiFi - WifiConnectionManager")
            //self.isConnectedToWifi = true
            self.pingHost(self.REMOTE_URL)
        case .cellular:
            print("*** Reachable via Cellular WifiConnectionManager")
            //self.isConnectedToWifi = false
            self.pingHost(self.REMOTE_URL)
        case .none:
            print("*** Network not reachable WifiConnectionManager")
            //self.isConnectedToWifi = false
            self.pingHost(self.REMOTE_URL)
            self.gotDisconnected = true
        }
    }

    private func checkForConnectionUpdates()  {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    static func gotDisconnectedToNetwork() -> Bool {
        return WifiConnectionManager.sharedinstance.gotDisconnected
    }
    
    static func isConnectedToNetwork() -> Bool {
        return WifiConnectionManager.sharedinstance.isConnectedToWifi
    }
    
    public func isInternetConnectionAvailable() -> Bool {
        self.pingHost(self.REMOTE_URL)
        return WifiConnectionManager.sharedinstance.isConnectedToWifi
    }
    
    static func getSSID() -> String {
        var wifiName = "no_wifi".localized
        if let interface = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interface) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interface, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                if let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString), let interfaceData = unsafeInterfaceData as? [String : AnyObject] {
                    // connected wifi
                    //print("BSSID: \(interfaceData["BSSID"]), SSID: \(interfaceData["SSID"]), SSIDDATA: \(interfaceData["SSIDDATA"])")
                    if ((interfaceData["SSID"]) != nil) {
                        wifiName = interfaceData["SSID"] as! String
                        return wifiName
                    } else {
                        //SSID is nil
                        return wifiName
                    }
                }
            }
        }
        return wifiName
    }
    
    func pingHost(_ fullURL: String) {
        print("*** pingHost \(fullURL) WifiConnectionManager")
        if let url = URL(string: fullURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            
            URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) in
                    guard error == nil else {
                        print("*** pingHostError:", error ?? "")
                        DispatchQueue.main.async {
                            self.isConnectedToWifi = false
                        }
                        return
                    }
                    
                    guard (response as? HTTPURLResponse)?
                        .statusCode == 200 else {
                            print("*** pingHostOffline")
                            DispatchQueue.main.async {
                                self.isConnectedToWifi = false
                            }
                            return
                    }
                    
                    print("*** pingHostOnline")
                    DispatchQueue.main.async {
                        self.isConnectedToWifi = true
                    }
                }
                .resume()
        }
        else {
            self.isConnectedToWifi = false
        }
    }
    
    // MARK: TokenGenerator
    static func randomTokenGenerator(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyz0123456789" //ABCDEFGHIJKLMNOPQRSTUVWXYZ
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    // MARK: AppDelegate Shared Functions
    
    // Starts monitoring the network availability status
    func startMonitoring() {
        self.checkForConnectionUpdates()
    }
    
    // Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

