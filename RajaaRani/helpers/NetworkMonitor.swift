//
//  NetworkMonitor.swift
//  Shades
//
//  Created by M Arslan Khan on 17/03/2020.
//  Copyright © 2020 Look Left Production. All rights reserved.
//

import Network
import Foundation

final class NetworkMonitor {
    
    // MARK: - Stored Properties
    private static let networkMonitor = NWPathMonitor()
    private static var previousNetworkState = NetworkConnection.unreachable
    
    
    // MARK: - Computed Properties
    /// Is any connection available
    static var isConnectionAvailable: Bool {
        return self.networkMonitor.currentPath.usesInterfaceType(.wifi) || self.networkMonitor.currentPath.usesInterfaceType(.cellular)
    }
    
    /// Type of connection available
    static var currentConnection: NetworkConnection {
        if self.networkMonitor.currentPath.usesInterfaceType(.wifi) {
            return NetworkMonitor.NetworkConnection.wifi
            
        } else if self.networkMonitor.currentPath.usesInterfaceType(.cellular) {
            return NetworkMonitor.NetworkConnection.cellular
            
        } else {
            return NetworkMonitor.NetworkConnection.unreachable
        }
    }
    
    
    // MARK: - Initializers
    private init() { }
    
    
    // MARK: - Helpers
    /// Start monitoring for network changes
    class func start() {
        self.networkMonitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) {
                guard self.previousNetworkState != .wifi else { return }
                self.previousNetworkState = .wifi
                NotificationCenter.default.post(name: .networkStateChanged, object: nil, userInfo: ["state" : NetworkConnection.wifi])
                
            } else if path.usesInterfaceType(.cellular) {
                guard self.previousNetworkState != .cellular else { return }
                self.previousNetworkState = .cellular
                NotificationCenter.default.post(name: .networkStateChanged, object: nil, userInfo: ["state" : NetworkConnection.cellular])
                
            } else {
                guard self.previousNetworkState != .unreachable else { return }
                self.previousNetworkState = .unreachable
                NotificationCenter.default.post(name: .networkStateChanged, object: nil, userInfo: ["state" : NetworkConnection.unreachable])
            }
        }
        self.networkMonitor.start(queue: DispatchQueue.main)
    }
    
    /// Stop monitoring for network changes
    class func stop() {
        self.networkMonitor.cancel()
    }
    
    
    // MARK: - Enclosed Enum
    enum NetworkConnection {
        case wifi
        case cellular
        case unreachable
    }
}


// MARK: - Notification Name Extension
extension Notification.Name {
    
    static let networkStateChanged = Notification.Name(rawValue: "networkStateChanged")
}



/// ----------------------------------------  USAGE  ----------------------------------------
//    NetworkMonitor.start()
//
//    NotificationCenter.default.addObserver(forName: .networkStateChanged, object: nil, queue: nil) { notification in
//        guard let connection = notification.userInfo?["state"] as? NetworkMonitor.NetworkConnection else { return }
//        switch connection {
//            case .wifi: break
//            case .cellular: break
//            case .unreachable: break
//        }
//    }

