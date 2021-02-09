//
//  User.swift
//  RajaaRani
//
//  Created by Rizwan on 12/25/20.
//

import Foundation
import UIKit

class User: NSObject, NSCoding{
    
    var _id: String = ""
    var email: String = ""
    var DOB: String = ""
    var gender: String = ""
    var city: String = ""
    var country: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var nickname: String = ""
    var sect: String = ""
    var ethnic: String = ""
    var job: String = ""
    var phone: String = ""
    var isCompleted: Bool = false
    var chatids: [String] = [String]()
    
    func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: "_id")
        coder.encode(email, forKey: "email")
        coder.encode(DOB, forKey: "DOB")
        coder.encode(gender, forKey: "gender")
        coder.encode(city, forKey: "city")
        coder.encode(country, forKey: "country")
        coder.encode(lat, forKey: "lat")
        coder.encode(lon, forKey: "lon")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(sect, forKey: "sect")
        coder.encode(ethnic, forKey: "ethnic")
        coder.encode(job, forKey: "job")
        coder.encode(phone, forKey: "phone")
        coder.encode(isCompleted, forKey: "isCompleted")
        coder.encode(chatids, forKey: "chatids")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObject(forKey: "_id") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let DOB = aDecoder.decodeObject(forKey: "DOB") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let country = aDecoder.decodeObject(forKey: "country") as! String
        let lat = aDecoder.decodeDouble(forKey: "lat") 
        let lon = aDecoder.decodeDouble(forKey: "lon") 
        let nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        let sect = aDecoder.decodeObject(forKey: "sect") as! String
        let ethnic = aDecoder.decodeObject(forKey: "ethnic") as! String
        let job = aDecoder.decodeObject(forKey: "job") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        let isCompleted = aDecoder.decodeBool(forKey: "isCompleted")
        let chatids = aDecoder.decodeObject(forKey: "chatids") as! [String]
        self.init(_id: _id, email: email, DOB: DOB, gender: gender, nickname: nickname, city: city, country: country, lat: lat, lon: lon, sect: sect, ethnic: ethnic, job: job, phone: phone, isCompleted: isCompleted, chatids: chatids)
    }
    
    
    init(_id: String, email: String, DOB: String, gender: String, nickname: String, city: String, country: String, lat: Double, lon: Double, sect: String, ethnic: String, job: String, phone: String, isCompleted: Bool, chatids: [String]) {
        self._id = _id
        self.email = email
        self.DOB = DOB
        self.gender = gender
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
        self.nickname = nickname
        self.sect = sect
        self.ethnic = ethnic
        self.job = job
        self.phone = phone
        self.isCompleted = isCompleted
        self.chatids = chatids
    }

}
