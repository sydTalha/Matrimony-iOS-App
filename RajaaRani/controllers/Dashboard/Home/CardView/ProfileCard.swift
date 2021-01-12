//
//  ProfileCard.swift
//  RajaaRani
//
//  Created by Rizwan on 12/24/20.
//

import UIKit

class ProfileCard: UIView {

    //MARK:- Properties
    var cardExpanded = false
    public var user: User?
    //MARK:- Outlets
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var botCard_view: UIView!
    
    @IBOutlet weak var cardContentMain_view: UIView!
    @IBOutlet weak var cardContent_view: UIView!
    @IBOutlet weak var topCard_view: UIView!
    
    @IBOutlet weak var profile_imgView: UIImageView!
    
    @IBOutlet weak var name_lbl: UILabel!
    
    @IBOutlet weak var desc_lbl: UILabel!
    
    @IBOutlet weak var profileDetail_view: ProfileDetailView!
    
    //MARK:- Constraints
    
    @IBOutlet weak var botCard_heightConstraint: NSLayoutConstraint!
    
    //MARK:- Actions
    
    
    //MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ProfileCardView", owner: self, options: nil)
        addSubview(content_view)
        content_view.frame = self.bounds
        content_view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.setupInterface()
        
    }
    
}

//MARK:- Event Handlers
extension ProfileCard{
    @objc func topViewTapped(_ sender: UITapGestureRecognizer? = nil){
        if cardExpanded{
            self.botCard_heightConstraint.constant -= 150
            self.cardExpanded = false
            UIView.animate(withDuration: 0.4) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func bottomViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        if !cardExpanded{
            self.botCard_heightConstraint.constant += 150
            self.cardExpanded = true
            UIView.animate(withDuration: 0.4) {
                self.layoutIfNeeded()
            }
        }
        
    }
}


//MARK:- Global Notifications
extension ProfileCard{
    func notificationReceived(notification: Notification) {
        
        
        if let user1 = notification.userInfo?["userCard"] as? User{
            self.user = user1
            
            if user1.isCompleted{
                //tap gestures
                let tapBot = UITapGestureRecognizer(target: self, action: #selector(self.bottomViewTapped(_:)))
                botCard_view.addGestureRecognizer(tapBot)

                let tapTop = UITapGestureRecognizer(target: self, action: #selector(self.topViewTapped(_:)))
                topCard_view.addGestureRecognizer(tapTop)
                
                
                name_lbl.text = user1.nickname
                desc_lbl.text = "User description will go here.."
                
                profileDetail_view.martialStatus_lbl.text = "Not Specified"
                profileDetail_view.cast_lbl.text = user1.ethnic
                profileDetail_view.color_lbl.text = "Not Specified"
                profileDetail_view.education_lbl.text = "Not Specified"
                profileDetail_view.job_lbl.text = user1.job
                profileDetail_view.height_lbl.text = "Not Specified"
                profileDetail_view.religion_lbl.text = "Not Specified"
                
            }
            else{
                self.profileDetail_view.isHidden = true
                
            }
            
        }
        
        
    }
}

//MARK:- Interface Setup
extension ProfileCard{
    func setupInterface(){
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "userObj_sent"), object: nil, queue: nil,
        using: self.notificationReceived)
        
        topCard_view.roundCorners([.allCorners], radius: 55)
        
        topCard_view.setCardView()
        botCard_view.roundCorners([.topLeft, .topRight], radius: 55)
        botCard_view.setCardView()
        profile_imgView.layer.cornerRadius = 55
    }
    
    
    func setCardsProfile(user: User){
        
    }
}
