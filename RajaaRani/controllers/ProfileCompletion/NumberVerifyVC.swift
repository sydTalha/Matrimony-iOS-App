//
//  NumberVerifyVC.swift
//  RajaaRani
//

//

import UIKit
import FlagPhoneNumber

class NumberVerifyVC: UIViewController{

    //MARK:- Properties
    
    
    //MARK:- Outlets
    @IBOutlet weak var bgCardView: UIView!
    @IBOutlet weak var numberTxtField: FPNTextField!
    
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSelfie", sender: self)
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
            
        }
    }
    
    
    
}

//MARK:- Helpers
extension NumberVerifyVC{
    
}
