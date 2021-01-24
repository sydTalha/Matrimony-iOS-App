//
//  Message.swift
//  RajaaRani
//

//


import Foundation
import MessageKit
import UIKit


struct Message {
    
    var id: String
    var content: String
    var created: TimeInterval
    var senderID: String
    var senderName: String
    var dictionary: [String: Any] {
    
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName":senderName
        ]
    }
}


extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
        let content = dictionary["content"] as? String,
        let created = dictionary["created"] as? TimeInterval,
        let senderID = dictionary["senderID"] as? String,
        let senderName = dictionary["senderName"] as? String
        else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: senderName)
    }
    var messageId: String {
        return id
    }
    var sentDate: Date {
        return Date(timeIntervalSince1970: created)
    }
    var kind: MessageKind {
        return .text(content)
    }
}




struct Member {
  let name: String
  let color: UIColor
}

extension Member {
  var toJSON: Any {
    return [
      "name": name,
      "color": color.hexString
    ]
  }
  
  init?(fromJSON json: Any) {
    guard
      let data = json as? [String: Any],
      let name = data["name"] as? String,
      let hexColor = data["color"] as? String
    else {
      print("Couldn't parse Member")
      return nil
    }
    
    self.name = name
    self.color = UIColor(hex: hexColor)
  }
}
