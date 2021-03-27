//
//  ProfileUnderReviewVC.swift
//  RajaaRani
//

//

import UIKit
import JGProgressHUD

class ProfileUnderReviewVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    //MARK:- Outlets
    
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDashboard", sender: self)
        
        
    }
    
    

}

//MARK:- Lifecycle
extension ProfileUnderReviewVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDashboard"{
            let tabVC = segue.destination as! UITabBarController
            let destVC = tabVC.children.first as! HomeVC
            destVC.user = self.user
        }
    }
}

//MARK:- Interface Setup
extension ProfileUnderReviewVC{
    func setupInterface(){
        
    }
}

//MARK:- Helpers
extension ProfileUnderReviewVC{
    
}
