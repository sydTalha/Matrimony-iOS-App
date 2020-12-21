//
//  GenderSelectionVC.swift
//  RajaaRani
//
//

import UIKit

class GenderSelectionVC: UIViewController {

    //MARK:- Properties
    
    //MARK:- Outlets
    @IBOutlet weak var maleOpt_view: UIView!
    @IBOutlet weak var femaleOpt_view: UIView!
    
    
    //MARK:- Actions
    
    @IBAction func maleTapped(_ sender: UIButton) {
        selectMaleOption()
        performSegue(withIdentifier: "goToDob", sender: self)
    }
    
    @IBAction func femaleTapped(_ sender: UIButton) {
        
        selectFemaleOption()
        
    }
    
    
}

//MARK:- Lifecycle
extension GenderSelectionVC{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        // Do any additional setup after loading the view.
    }
}


//MARK:- Interface Setup
extension GenderSelectionVC{
    
    func setupInterface(){
        
    }
    
    
    func selectMaleOption(){
        UIView.transition(with: self.maleOpt_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.maleOpt_view.borderWidth = 2
        }, completion: nil)
        
        UIView.transition(with: self.femaleOpt_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.femaleOpt_view.borderWidth = 0
        }, completion: nil)
    }
    
    func selectFemaleOption(){
        UIView.transition(with: self.maleOpt_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.maleOpt_view.borderWidth = 0
        }, completion: nil)
        
        UIView.transition(with: self.femaleOpt_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.femaleOpt_view.borderWidth = 2
        }, completion: nil)
    }
    
}


//MARK:- Helpers
extension GenderSelectionVC{
    
}
