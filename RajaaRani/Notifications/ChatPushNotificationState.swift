//
//  ChatPushNotificationState.swift
//  RajaaRani
//

//

import Foundation
import TwilioChatClient

class ChatPushNotificationState {
    var updatedPushToken: Data?
    var receivedNotification: [AnyHashable : Any]?
    var chatClient: TwilioChatClient?
    
    
    
    // MARK:- Shared Instance
    static let shared = ChatPushNotificationState()
}
