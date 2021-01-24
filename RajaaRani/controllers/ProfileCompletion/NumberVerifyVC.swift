//
//  NumberVerifyVC.swift
//  RajaaRani
//

//

import UIKit
import FlagPhoneNumber
import Alamofire
import SwiftyJSON
import OTPFieldView
import JGProgressHUD

class NumberVerifyVC: UIViewController{

    //MARK:- Properties
    var phone: String = ""
    var user: User?
    var isPhoneValid = false
    
    
    //MARK:- Outlets
    @IBOutlet weak var bgCardView: UIView!
    @IBOutlet weak var numberTxtField: FPNTextField!
    @IBOutlet weak var otpView: OTPFieldView!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        
        if isPhoneValid{
            sendPhoneCode()
        }
        else{
            self.present(utils.displayDialog(title: "Invalid Phone No.", msg: "Please enter a valid phone number"), animated: true, completion: nil)
            
        }
        
        
        //performSegue(withIdentifier: "goToSelfie", sender: self)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

//MARK:- Event Handlers
extension NumberVerifyVC{
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -180 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}

//MARK:- Lifecycle
extension NumberVerifyVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelfie"{
            let destVC = segue.destination as! SelfieVC
            destVC.user = self.user
        }
    }
}

//MARK:- Interface Setup
extension NumberVerifyVC{
    func setupInterface(){
        bgCardView.setCardView()
        numberTxtField.setFlag(key: .PK)
        numberTxtField.delegate = self
        
        
        self.hideKeyboardWhenTappedAround()
        
        
        //Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //setupOtpView()
        
        self.otpView.isHidden = true
        self.otpView.isUserInteractionEnabled = false
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

//MARK:- FPNTextField Delegate
extension NumberVerifyVC: FPNTextFieldDelegate{
    func fpnDisplayCountryList() {
        
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid{
            print(textField.getFormattedPhoneNumber(format: .E164)!)
            self.isPhoneValid = true
            self.phone = textField.getFormattedPhoneNumber(format: .E164)!
        }
        else{
            self.isPhoneValid = false
        }
    }
    
    
    
    
}


//MARK:- OTPFieldView Delegate
extension NumberVerifyVC: OTPFieldViewDelegate{
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
        self.continueBtn.isUserInteractionEnabled = false
        self.numberTxtField.isUserInteractionEnabled = false
        verifyOTP(code: otpString, hud: hud)
        
    }
    
    
}


//MARK:- Helpers
extension NumberVerifyVC{
    func sendPhoneCode(){
        let params = ["email": self.user?.email ?? "",
        "phone": self.phone,
        "nickname": self.user?.nickname ?? "",
        "sect": self.user?.sect ?? "",
        "ethnic": self.user?.ethnic ?? "",
        "job": self.user?.job ?? ""] as [String: Any]
        AF.request(config.phoneCodeURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response.response?.statusCode ?? 0)
            
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let msg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    //hud.dismiss()
                    
                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                //let msg = result["message"].stringValue
                print(result)
                DispatchQueue.main.async {
                    self.otpView.isHidden = false
                    self.otpView.isUserInteractionEnabled = true
                    self.setupOtpView()
//                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                
                //hud.dismiss()
                
            }
        }
    }
    
    func verifyOTP(code: String, hud: JGProgressHUD){
        hud.show(in: self.view)
        let params = ["email": self.user?.email ?? "",
                      "phone": self.phone,
        "code": code] as [String: Any]
        
        AF.request(config.phoneCodeVerifyURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value ?? "")
                let msg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                
            }
            else if responseCode == 200{
                //phone verified
                DispatchQueue.main.async {
                    hud.dismiss()
                    self.user?.phone = self.phone
                    self.performSegue(withIdentifier: "goToSelfie", sender: self)
                }
                
            }
            else{
                DispatchQueue.main.async {
                    hud.dismiss()
                    self.present(utils.displayDialog(title: "Alert", msg: "Something went wrong, please try again"), animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
}
