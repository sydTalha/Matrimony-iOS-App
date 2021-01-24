//
//  SocketIOManager.swift
//  RajaaRani
//
//192.168.100.115
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "http://192.168.100.115:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient?
    
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    
    func establishConnection() {
        socket?.connect()
    }
     
     
    func closeConnection() {
        socket?.disconnect()
    }
    
    
    func connectToServerWithNickname(nickname: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void) {
        socket?.emit("connectUser", nickname)
        
        listenForOtherMessages()
    }
    
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket?.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        socket?.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: Any]()
            messageDictionary["nickname"] = dataArray[0] as? String
            messageDictionary["message"] = dataArray[1] as? String
            messageDictionary["date"] = dataArray[2] as? String
            

            completionHandler(messageDictionary)
        }
    }
    
    
    private func listenForOtherMessages() {
        socket?.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
     
        socket?.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
    }
}
