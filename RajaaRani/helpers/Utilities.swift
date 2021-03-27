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
    static let fetchUserURL = "https://secret-fortress-76633.herokuapp.com/users"
    static let registerURL = "https://secret-fortress-76633.herokuapp.com/register"
    static let verifyURL = "https://secret-fortress-76633.herokuapp.com/auth/verify"
    static let loginURL = "https://secret-fortress-76633.herokuapp.com/login"
    static let phoneCodeURL = "https://secret-fortress-76633.herokuapp.com/phone"
    static let phoneCodeVerifyURL = "https://secret-fortress-76633.herokuapp.com/phone/verify"
    static let selfieVerifyURL = "https://secret-fortress-76633.herokuapp.com/selfie/verify"
    static let fetchPeopleURL = "https://secret-fortress-76633.herokuapp.com/find/main"
    static let swipeLeftURL = "https://secret-fortress-76633.herokuapp.com/swipe/left"
    static let swipeRightURL = "https://secret-fortress-76633.herokuapp.com/swipe/right"
    static let matchedUsersURL = "https://secret-fortress-76633.herokuapp.com/matches"
    static let getTwilioTokenURL = "https://secret-fortress-76633.herokuapp.com/twilio/token/ios"
    static let getChatIDAPI = "https://secret-fortress-76633.herokuapp.com/chats"
    static let getTwilioVideoTokenURL = "https://secret-fortress-76633.herokuapp.com/twilio/video/token"
    static let registerDeviceServerURL = "https://scarlet-millipede-8508.twil.io/register-binding"
    static let notifyCallURL = "https://secret-fortress-76633.herokuapp.com/twilio/call"
    static let notifyEndCallURL = "https://secret-fortress-76633.herokuapp.com/twilio/call/decline"
    
}

struct utils{
    static func displayDialog(title: String, msg: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}


//MARK:- Twilio Reqs
struct TwilioService{
   static func registerDevice(_ identity: String, deviceToken: String) {

      // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
      let session = URLSession.shared

        let url = URL(string: config.registerDeviceServerURL)
      var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
      request.httpMethod = "POST"

      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let params = ["identity": identity,
                    "BindingType" : "apn",
                    "Address" : deviceToken]

      let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
      request.httpBody = jsonData

      let requestBody = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
      print("Request Body: \(requestBody ?? "")")

      let task = session.dataTask(with: request, completionHandler: {
          (responseData, response, error) in

        if let responseData = responseData {
          let responseString = String(data: responseData, encoding: String.Encoding.utf8)

          print("Response Body: \(responseString ?? "")")
          do {
              let responseObject = try JSONSerialization.jsonObject(with: responseData, options: [])
              if let responseDictionary = responseObject as? [String: Any] {
                  if let message = responseDictionary["message"] as? String {
                      print("Message: \(message)")

//                      DispatchQueue.main.async() {
//                          self.messageLabel.text = message
//                          self.messageLabel.isHidden = false
//                      }
                  }
              }
              print("JSON: \(responseObject)")
          } catch let error {
              print("Error: \(error)")
          }
          }
      })

      task.resume()
    }
}


//MARK:- UI Layers
struct Layer{
    static func allButtonBadge(button:UIButton, text:String, fontSize:CGFloat = 17.0) {
        let size: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let point = CGPoint(x: size.width, y: 0)

        let circle = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: point.x-17, y: 15), radius: 3, startAngle: 0, endAngle: .pi*2, clockwise: true)
        circle.path = path.cgPath
        circle.fillColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0).cgColor
        circle.name = "dot"
        button.layer.addSublayer(circle)
    }
    
    static func readButtonBadge(button:UIButton, text:String, fontSize:CGFloat = 17.0) {
        let size: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let point = CGPoint(x: size.width, y: 0)

        let circle = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: point.x-42, y: 15), radius: 3, startAngle: 0, endAngle: .pi*2, clockwise: true)
        circle.path = path.cgPath
        circle.fillColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0).cgColor
        circle.name = "dot"
        button.layer.addSublayer(circle)
    }
    
    static func unreadButtonBadge(button:UIButton, text:String, fontSize:CGFloat = 17.0) {
        let size: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let point = CGPoint(x: size.width, y: 0)

        let circle = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: point.x-53, y: 15), radius: 3, startAngle: 0, endAngle: .pi*2, clockwise: true)
        circle.path = path.cgPath
        circle.fillColor = UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0).cgColor
        circle.name = "dot"
        button.layer.addSublayer(circle)
    }
    
}


// Golden Color: UIColor(red: 233/255, green: 169/255, blue: 54/255, alpha: 1.0).cgColor
