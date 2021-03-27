//
//  LikedVC.swift
//  RajaaRani
//

//

import UIKit



class LikedVC: UIViewController {

    //MARK:- Properties
    var email: String = ""
    
    //MARK:- Outlets
    
    @IBOutlet weak var currentUser_img: UIImageView!
    
    @IBOutlet weak var otherUser_img: UIImageView!
    
    
    //MARK:- Actions
    
    
    @IBAction func sendMsgTapped(_ sender: UIButton) {
        if let tabBarController = self.presentingViewController as? UITabBarController {
            self.dismiss(animated: true) {
                tabBarController.selectedIndex = 2
            }
        }
        
    }
    
    @IBAction func keepSwipingTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
//    @IBAction func continueTapped(_ sender: UIButton) {
//        if let tabBarController = self.presentingViewController as? UITabBarController {
//            self.dismiss(animated: true) {
//                tabBarController.selectedIndex = 2
//            }
//        }
//
//    }
//
//    @IBAction func keepSwipingTapped(_ sender: UIButton) {
//
//        self.dismiss(animated: true, completion: nil)
//
//    }
    

}

//MARK:- Lifecycle
extension LikedVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        
    }
}

//MARK:- Interface Setup
extension LikedVC{
    func setupInterface(){
        currentUser_img.layer.cornerRadius = currentUser_img.frame.size.width/2
        currentUser_img.clipsToBounds = true
        
        otherUser_img.layer.cornerRadius = otherUser_img.frame.size.width/2
        otherUser_img.clipsToBounds = true
        
//        matched_lbl.text = email
//
//        currentUserMatch_img.layer.cornerRadius = currentUserMatch_img.frame.size.width/2
//        currentUserMatch_img.clipsToBounds = true
//        otherUserMatch_img.layer.cornerRadius = otherUserMatch_img.frame.size.width/2
//        otherUserMatch_img.clipsToBounds = true
//
//
//        confettiView = SAConfettiView(frame: self.view.bounds)
//        self.confetti_view.addSubview(confettiView!)
//        confettiView?.type = .Confetti
//
//
//        confettiView!.intensity = 0.75
//
//        confettiView!.startConfetti()
        
    }
}

//MARK:- Helpers
extension LikedVC{
    
}
