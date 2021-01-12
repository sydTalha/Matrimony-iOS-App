//
//  NicknameVC.swift
//  RajaaRani
//

//

import UIKit

class NicknameVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    //MARK:- Outlets
    
    @IBOutlet weak var bgCardView: UIView!
    @IBOutlet weak var nicknameTxtField: UITextField!
    
    //MARK:- Actions
    
    @IBAction func createProfileTapped(_ sender: UIButton) {
        
        if nicknameTxtField.text?.isEmpty ?? true{
            displayDialog(msg: "Please enter a nickname")
        }
        else{
            if isValidInput(str: nicknameTxtField.text!){
                self.user?.nickname = nicknameTxtField.text!
                performSegue(withIdentifier: "goToSect", sender: self)
            }
            else{
                displayDialog(msg: "Please enter a valid nickname")
            }
        }
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "goToDashboard", sender: self)
    }
    

}

//MARK:- Event Handlers
extension NicknameVC{
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -180 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
}


//MARK:- Lifecycle
extension NicknameVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        fetchUserFromUserDefaults()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSect"{
            let destVC = segue.destination as! SectVC
            destVC.user = self.user
        }
    }
}


//MARK:- Interface Setup
extension NicknameVC{
    func setupInterface(){
        bgCardView.setCardView()
        nicknameTxtField.setLeftPaddingPoints(8)
        nicknameTxtField.setRightPaddingPoints(8)
        
        self.hideKeyboardWhenTappedAround()
        
        
        //Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func fetchUserFromUserDefaults(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "user")
        if decoded != nil{
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? User
            
            if decodedUser != nil{
                self.user = decodedUser
                
            }
        }
    }
}

//MARK:- Helpers
extension NicknameVC{
    func isValidInput(str:String) -> Bool {
        
        guard str.count > 2, str.count < 18 else { return false }

            let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
            return predicateTest.evaluate(with: str)
    }
    
    func displayDialog(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
