//
//  TwilioManager.swift
//  RajaaRani
//

//

import Foundation
import TwilioChatClient
import Alamofire
import SwiftyJSON

struct TwilioManager{
    
    static func fetchTokenFromAPI(username: String, completion: @escaping (String)->()){
        let params = ["username": username]
        AF.request(config.getTwilioTokenURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            
            let result = JSON(response.value)
            print(response)
            if responseCode >= 400 && responseCode <= 499{
                
                completion("")
                //self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio token"), animated: true, completion: nil)
            }
            else{
                
                let token = result.stringValue
                completion(token)
            }
        }
    }
    
    static func fetchVideoTokenFromAPI(username: String, chat_id: String, completion: @escaping (String)->()){
        let params = ["username": username,
                      "room": chat_id]
        AF.request(config.getTwilioVideoTokenURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            
            let result = JSON(response.value)
            print(response)
            if responseCode >= 400 && responseCode <= 499{
                
                completion("")
                //self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio token"), animated: true, completion: nil)
            }
            else{
                
                let token = result.stringValue
                completion(token)
            }
        }
    }
    
    static func initializeTwilioClient(token: String){
        
    }
}
