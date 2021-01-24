//
//  ProfileUnderReviewVC.swift
//  RajaaRani
//

//

import UIKit
import Quickblox
import QuickbloxWebRTC
import JGProgressHUD

class ProfileUnderReviewVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    //MARK:- Outlets
    
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        
        //sign up in quickblox
        signupQuickBlox()
        
        
    }
    
    

}

//MARK:- Lifecycle
extension ProfileUnderReviewVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    
    }
}

//MARK:- Interface Setup
extension ProfileUnderReviewVC{
    func setupInterface(){
        
    }
}

//MARK:- Helpers
extension ProfileUnderReviewVC{
    func signupQuickBlox(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        print(user?._id, user?.email)
        let userQB = QBUUser()
        if let id = UInt.parse(from: self.user?._id ?? "") {
            userQB.id = id
            userQB.login = self.user?.email ?? ""
            userQB.fullName = self.user?.nickname ?? ""
            userQB.password = self.user?._id ?? ""
            print("here")
            
            QBRequest.signUp(userQB) { (response, userQBResponse) in
                //success
                
                if response.isSuccess{
                    hud.dismiss()
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                }
                else{
                    print(response.error)
                }
                
            } errorBlock: { (errorCode) in
                hud.dismiss()
                print("signup error: \(errorCode)")
            }

        }
        
    }
}
