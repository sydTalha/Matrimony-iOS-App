//
//  ProfileUnderReviewVC.swift
//  RajaaRani
//

//

import UIKit

class ProfileUnderReviewVC: UIViewController {

    //MARK:- Properties
    
    
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
}

//MARK:- Interface Setup
extension ProfileUnderReviewVC{
    func setupInterface(){
        
    }
}

//MARK:- Helpers
extension ProfileUnderReviewVC{
    
}
