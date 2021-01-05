//
//  NicknameVC.swift
//  RajaaRani
//

//

import UIKit

class NicknameVC: UIViewController {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var bgCardView: UIView!
    @IBOutlet weak var nicknameTxtField: UITextField!
    
    //MARK:- Actions
    
    @IBAction func createProfileTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSect", sender: self)
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
}

//MARK:- Helpers
extension NicknameVC{
    
}
