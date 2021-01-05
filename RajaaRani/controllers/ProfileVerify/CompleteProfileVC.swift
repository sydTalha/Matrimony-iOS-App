//
//  CompleteProfileVC.swift
//  RajaaRani
//

//

import UIKit


class CompleteProfileVC: UIViewController {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var report_view: UIView!
    
    
    
    //MARK:- Actions
    
    @IBAction func createProfileTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func laterBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToDashboard", sender: self)
    }
    
    //MARK:- Event Handlers


}

//MARK:- Lifecycle
extension CompleteProfileVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}

//MARK:- Interface Setup
extension CompleteProfileVC{
    func setupInterface(){
        report_view.layer.cornerRadius = report_view.frame.size.width/2
        report_view.clipsToBounds = true
    }
}

//MARK:- Helpers
extension CompleteProfileVC{
    
}



