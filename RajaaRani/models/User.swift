//
//  User.swift
//  RajaaRani
//
//  Created by Rizwan on 12/25/20.
//

import Foundation
import UIKit

class User: NSObject, NSCoding{
    
    var email: String = ""
    var DOB: String = ""
    var gender: String = ""
    var nickname: String = ""
    var sect: String = ""
    var ethnic: String = ""
    var job: String = ""
    
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey: "email")
        coder.encode(DOB, forKey: "DOB")
        coder.encode(gender, forKey: "gender")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(sect, forKey: "sect")
        coder.encode(sect, forKey: "ethnic")
        coder.encode(sect, forKey: "job")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let DOB = aDecoder.decodeObject(forKey: "DOB") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        let sect = aDecoder.decodeObject(forKey: "sect") as! String
        let ethnic = aDecoder.decodeObject(forKey: "ethnic") as! String
        let job = aDecoder.decodeObject(forKey: "job") as! String
        self.init(email: email, DOB: DOB, gender: gender, nickname: nickname, sect: sect, ethnic: ethnic, job: job)
    }
    
    
    init(email: String, DOB: String, gender: String, nickname: String, sect: String, ethnic: String, job: String) {
        self.email = email
        self.DOB = DOB
        self.gender = gender
        self.nickname = nickname
        self.sect = sect
        self.ethnic = ethnic
        self.job = job
    }

}
