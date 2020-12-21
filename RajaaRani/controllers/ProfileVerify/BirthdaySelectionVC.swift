//
//  BirthdaySelectionVC.swift
//  RajaaRani
//

//

import UIKit


class BirthdaySelectionVC: UIViewController {

    
    //MARK:- Properties
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK:- Outlets
    
    @IBOutlet weak var bottomCard_view: UIView!
    
    //MARK:- Constraints
    @IBOutlet weak var cardView_heightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToEmailVerify", sender: self)
        
    }
    
    

}

//MARK:- Lifecycle
extension BirthdaySelectionVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}


//MARK:- Interface Setup
extension BirthdaySelectionVC{
    
    func setupInterface(){
        cardView_heightConstraint.constant += (0.2 * screenHeight * 0.01)
        
        bottomCard_view.roundCorners([.topLeft, .topRight], radius: 55)
        bottomCard_view.clipsToBounds = true
        bottomCard_view.setCardView()
        
    }
}

//MARK:- MDatePicker Delegate



//MARK:- Helpers
extension BirthdaySelectionVC{
    
}

