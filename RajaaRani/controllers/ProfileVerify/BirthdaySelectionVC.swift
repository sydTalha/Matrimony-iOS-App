//
//  BirthdaySelectionVC.swift
//  RajaaRani
//

//

import UIKit

class BirthdaySelectionVC: UIViewController {

    
    //MARK:- Properties
    let screenHeight = UIScreen.main.bounds.height
    var user: User?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var bottomCard_view: UIView!
    @IBOutlet weak var emailTitle_lbl: UILabel!
    
    //MARK:- Constraints
    @IBOutlet weak var cardView_heightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Actions
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func continueTapped(_ sender: UIButton) {
       
        performSegue(withIdentifier: "goToEmailVerify", sender: self)
        
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        print(sender.date)
        
        
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let createdDate = dateFormatter.string(from: sender.date)
        
        self.user?.DOB = createdDate
    }
    
    
    
    
}

//MARK:- Lifecycle
extension BirthdaySelectionVC{
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEmailVerify"{
            let destVC = segue.destination as! EmailVerifyVC
            destVC.user = self.user
        }
    }
}


//MARK:- Interface Setup
extension BirthdaySelectionVC{
    
    func setupInterface(){
        
        cardView_heightConstraint.constant += (0.2 * screenHeight * 0.01)
        
        bottomCard_view.roundCorners([.topLeft, .topRight], radius: 55)
        bottomCard_view.clipsToBounds = true
        bottomCard_view.setCardView()
    
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = maxDate
        
        emailTitle_lbl.text = user?.email
        
    }
}


//MARK:- Helpers
extension BirthdaySelectionVC{
    
}

