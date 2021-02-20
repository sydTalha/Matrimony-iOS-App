////
////  ProviderDelegate.swift
////  RajaaRani
////
//
////
//
//import AVFoundation
//import CallKit
//
//class ProviderDelegate: NSObject {
//  // 1.
//  private let callManager:
//  private let provider: CXProvider
//  
//  init(callManager: CallManager) {
//    self.callManager = callManager
//    // 2.
//    provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
//    
//    super.init()
//    // 3.
//    provider.setDelegate(self, queue: nil)
//  }
//  
//  // 4.
//  static var providerConfiguration: CXProviderConfiguration = {
//    let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
//    
//    providerConfiguration.supportsVideo = true
//    providerConfiguration.maximumCallsPerCallGroup = 1
//    providerConfiguration.supportedHandleTypes = [.phoneNumber]
//    
//    return providerConfiguration
//  }()
//}
