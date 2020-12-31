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
    
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey: "email")
        coder.encode(DOB, forKey: "DOB")
        coder.encode(gender, forKey: "gender")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let DOB = aDecoder.decodeObject(forKey: "DOB") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.init(email: email, DOB: DOB, gender: gender)
    }
    
    
    init(email: String, DOB: String, gender: String) {
        self.email = email
        self.DOB = DOB
        self.gender = gender
    }

}
