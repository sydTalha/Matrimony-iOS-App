//
//  PhoneVerifyVC.swift
//  RajaaRani
//
//

import UIKit
import OTPFieldView
import JGProgressHUD
import SwiftyJSON
import Alamofire

class EmailVerifyVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var otpView: OTPFieldView!
    
    @IBOutlet weak var emailTitle_lbl: UILabel!
    
    
    //MARK:- Actions

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func codeResendTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToCompleteProfile", sender: self)
    }
    
    

}

//MARK:- Event Handlers
extension EmailVerifyVC{
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
}




//MARK:- Lifecycle
extension EmailVerifyVC{
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.sendRegisterRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}

//MARK:- Interface Setup
extension EmailVerifyVC{
    func setupInterface(){
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        setupOtpView()
        
        emailTitle_lbl.text = user?.email
    }
    
    
    func setupOtpView(){
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = UIColor.gray
        self.otpView.filledBorderColor = UIColor(red: 98/255, green: 13/255, blue: 135/255, alpha: 1.0)
        self.otpView.cursorColor = UIColor(red: 98/255, green: 13/255, blue: 135/255, alpha: 1.0)
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.otpInputType = .numeric
        self.otpView.initializeUI()
        
    }
    
}

//MARK:- OTPView Delegate
extension EmailVerifyVC: OTPFieldViewDelegate{
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
        
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
        
    func enteredOTP(otp otpString: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        verifyOTP(otpCode: otpString, hud: hud)
        
    }
    
    
}


//MARK:- Helpers
extension EmailVerifyVC{
    
    func sendRegisterRequest(){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        let params = ["email": self.user?.email ?? "",
                      "DOB": self.user?.DOB ?? "",
                      "gender": self.user?.gender ?? ""] as [String : Any]
        
        AF.request(config.registerURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response.response?.statusCode ?? 0)
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let errorMsg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                print(result)
                hud.dismiss()
                
            }
        }
        
    }
    
    func verifyOTP(otpCode: String, hud: JGProgressHUD){
        let params = ["email": self.user?.email ?? "",
                      "code": otpCode] as [String : Any]
        
        AF.request(config.verifyURL, method: .get, parameters: params).responseJSON { (response) in
            print(response.result)
            
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let errorMsg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                print(result)
                
                //save user prefs
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                
                userDefaults.set(encodedData, forKey: "user")
                
                userDefaults.synchronize()
                
                
                self.performSegue(withIdentifier: "goToDashboard", sender: self)
                hud.dismiss()
                
            }
            
        }
    }
    
    
}
