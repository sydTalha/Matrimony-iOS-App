//
//  SelfieVC.swift
//  RajaaRani
//

//

import UIKit

class SelfieVC: UIViewController {

    //MARK:- Properties
    
    
    //MARK:- Outlets
    @IBOutlet weak var bgCardView: UIView!
    
    @IBOutlet weak var optView_1: UIView!
    
    @IBOutlet weak var optView_2: UIView!
    
    //MARK:- Actions
    
    @IBAction func takeSelfieTapped(_ sender: UIButton) {
        
            
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}


//MARK:- Lifecycle
extension SelfieVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
}

//MARK:- Interface Setup
extension SelfieVC{
    func setupInterface(){
        self.bgCardView.setCardView()
        
        optView_1.layer.cornerRadius = optView_1.frame.size.width/2
        optView_1.clipsToBounds = true
        optView_1.setSmallShadow()
        optView_2.layer.cornerRadius = optView_2.frame.size.width/2
        optView_2.clipsToBounds = true
        optView_2.setSmallShadow()
    }
}

//MARK:- Helpers
extension SelfieVC{
    
}
