//
//  LikedVC.swift
//  RajaaRani
//

//

import UIKit
import SAConfettiView


class LikedVC: UIViewController {

    //MARK:- Properties
    var email: String = ""
    var confettiView: SAConfettiView?
    //MARK:- Outlets
    
    @IBOutlet weak var matched_lbl: UILabel!
    
    @IBOutlet weak var currentUserMatch_img: UIImageView!
    
    
    @IBOutlet weak var otherUserMatch_img: UIImageView!
    
    @IBOutlet weak var confetti_view: UIView!
    
    
    
    //MARK:- Actions
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if let tabBarController = self.presentingViewController as? UITabBarController {
            self.dismiss(animated: true) {
                tabBarController.selectedIndex = 2
            }
        }
        
    }
    
    @IBAction func keepSwipingTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}

//MARK:- Lifecycle
extension LikedVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.confettiView?.stopConfetti()
            
        }
        
        
    }
}

//MARK:- Interface Setup
extension LikedVC{
    func setupInterface(){
        matched_lbl.text = email
        
        currentUserMatch_img.layer.cornerRadius = currentUserMatch_img.frame.size.width/2
        currentUserMatch_img.clipsToBounds = true
        otherUserMatch_img.layer.cornerRadius = otherUserMatch_img.frame.size.width/2
        otherUserMatch_img.clipsToBounds = true
        
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.confetti_view.addSubview(confettiView!)
        confettiView?.type = .Confetti
        
        
        confettiView!.intensity = 0.75
        
        confettiView!.startConfetti()
        
    }
}

//MARK:- Helpers
extension LikedVC{
    
}
