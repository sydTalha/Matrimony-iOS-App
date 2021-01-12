//
//  Utilities.swift
//  RajaaRani
//
//  Created by Rizwan on 12/25/20.
//

import Foundation
import UIKit

//MARK:- API - Config
struct config {
    static let registerURL = "https://secret-fortress-76633.herokuapp.com/register"
    static let verifyURL = "https://secret-fortress-76633.herokuapp.com/auth/verify"
    static let loginURL = "https://secret-fortress-76633.herokuapp.com/login"
    static let phoneCodeURL = "https://secret-fortress-76633.herokuapp.com/phone"
    static let phoneCodeVerifyURL = "https://secret-fortress-76633.herokuapp.com/phone/verify"
    static let selfieVerifyURL = "https://secret-fortress-76633.herokuapp.com/selfie/verify"
    static let fetchPeopleURL = "https://secret-fortress-76633.herokuapp.com/find/main"
    static let swipeLeftURL = "https://secret-fortress-76633.herokuapp.com/swipe/left"
    static let swipeRightURL = "https://secret-fortress-76633.herokuapp.com/swipe/right"
}

struct utils{
    static func displayDialog(title: String, msg: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
