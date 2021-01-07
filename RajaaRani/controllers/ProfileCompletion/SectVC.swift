//
//  SectVC.swift
//  RajaaRani
//
//  Created by Rizwan on 1/5/21.
//

import UIKit

class SectVC: UIViewController {

    
    //MARK:- Properties
    var user: User?
    
    //MARK:- Outlets
    
    @IBOutlet weak var bgCardView: UIView!
    
    @IBOutlet weak var sunniBtn: UIButton!
    
    @IBOutlet weak var shiaBtn: UIButton!
    
    @IBOutlet weak var othersBtn: UIButton!
    
    
    //MARK:- Actions
    
    @IBAction func sunniTapped(_ sender: UIButton) {
        user?.sect = "sunni"
        UIView.transition(with: self.sunniBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.sunniBtn.borderWidth = 2
        }, completion: nil)
        
        UIView.transition(with: self.shiaBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.shiaBtn.borderWidth = 0
        }, completion: nil)
        
        UIView.transition(with: self.othersBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.othersBtn.borderWidth = 0
        }, completion: nil)
    }
    
    @IBAction func shiaTapped(_ sender: UIButton) {
        user?.sect = "shia"
        UIView.transition(with: self.sunniBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.sunniBtn.borderWidth = 0
        }, completion: nil)
        
        UIView.transition(with: self.shiaBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.shiaBtn.borderWidth = 2
        }, completion: nil)
        
        UIView.transition(with: self.othersBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.othersBtn.borderWidth = 0
        }, completion: nil)
    }
    
    @IBAction func othersTapped(_ sender: UIButton) {
        user?.sect = "other"
        UIView.transition(with: self.sunniBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.sunniBtn.borderWidth = 0
        }, completion: nil)
        
        UIView.transition(with: self.shiaBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.shiaBtn.borderWidth = 0
        }, completion: nil)
        
        UIView.transition(with: self.othersBtn,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.othersBtn.borderWidth = 2
        }, completion: nil)
    }
    
    
    @IBAction func continueTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEthnic", sender: self)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}

//MARK:- Event Handlers
extension SectVC{
    
}


//MARK:- Lifecycle
extension SectVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEthnic"{
            let destVC = segue.destination as! EthnicVC
            destVC.user = self.user
        }
    }
}

//MARK:- Interface Setup
extension SectVC{
    func setupInterface(){
        bgCardView.setCardView()
        user?.sect = "sunni"
        
        
    }
}

//MARK:- Helpers
extension SectVC{
    
}
