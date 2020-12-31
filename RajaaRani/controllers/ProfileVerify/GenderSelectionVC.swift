//
//  GenderSelectionVC.swift
//  RajaaRani
//
//

import UIKit

class GenderSelectionVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    
    //MARK:- Outlets
    @IBOutlet weak var maleOpt_view: UIView!
    @IBOutlet weak var femaleOpt_view: UIView!
    
    @IBOutlet weak var emailTitle_lbl: UILabel!
    
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func maleTapped(_ sender: UIButton) {
        selectMaleOption()
        self.user?.gender = "male"
        performSegue(withIdentifier: "goToDob", sender: self)
    }
    
    @IBAction func femaleTapped(_ sender: UIButton) {
        
        selectFemaleOption()
        self.user?.gender = "female"
        performSegue(withIdentifier: "goToDob", sender: self)
    }
    
    
}

//MARK:- Lifecycle
extension GenderSelectionVC{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDob"{
            let destVC = segue.destination as! BirthdaySelectionVC
            destVC.user = self.user
        }
    }
    
}


//MARK:- Interface Setup
extension GenderSelectionVC{
    
    func setupInterface(){
        emailTitle_lbl.text = user?.email
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
