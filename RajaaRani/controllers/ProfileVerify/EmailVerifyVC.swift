//
//  PhoneVerifyVC.swift
//  RajaaRani
//
//

import UIKit
import OTPFieldView

class EmailVerifyVC: UIViewController {

    //MARK:- Properties
    
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var otpView: OTPFieldView!
    
    
    
    //MARK:- Actions

    @IBAction func codeResendTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToDashboard", sender: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}

//MARK:- Interface Setup
extension EmailVerifyVC{
    func setupInterface(){
        setupOtpView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
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
            print("OTPString: \(otpString)")
        }
}


//MARK:- Helpers
extension EmailVerifyVC{
    
    //hiding keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
}
