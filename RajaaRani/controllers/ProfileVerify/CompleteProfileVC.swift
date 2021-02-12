//
//  CompleteProfileVC.swift
//  RajaaRani
//

//

import UIKit



class CompleteProfileVC: UIViewController {

    //MARK:- Properties
    var user: User?
    var from = 0
    
    //MARK:- Outlets
    
    @IBOutlet weak var report_view: UIView!
    
    
    
    //MARK:- Actions
    
    @IBAction func createProfileTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToNickname", sender: self)
    }
    
    @IBAction func laterBtnTapped(_ sender: UIButton) {
        
        if from == 0{
            performSegue(withIdentifier: "goToDashboard", sender: self)
        }
        else if from == 1{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Event Handlers


}

//MARK:- Lifecycle
extension CompleteProfileVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNickname"{
            if from == 1{
                let destVC = segue.destination as! NicknameVC
                destVC.from = 1
            }
        }
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



