//
//  LoginVC.swift
//  RajaaRani
//

//

import UIKit
import AVFoundation
import GoogleSignIn
import JGProgressHUD


class LoginVC: UIViewController {

    //MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var looper: AVPlayerLooper?
    
    let hud_google = JGProgressHUD(style: .dark)
    
    var existingUser: User?
    
    
    //MARK:- Outlets
    @IBOutlet weak var report_view: UIView!
    
    @IBOutlet weak var videoLayer: UIView!
    
    @IBOutlet weak var hear_imgView: UIImageView!
    @IBOutlet weak var subtitle_lbl: UILabel!
    
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var privacyMain_lbl: UILabel!
    
    @IBOutlet weak var loginForm_stack: UIStackView!
    
    
    //MARK:- Constraints Outlets
    
    
    //MARK:- Actions
    
    @IBAction func googleTapped(_ sender: Any) {
        self.present(utils.displayDialog(title: "Disabled", msg: "Please continue with email for now"), animated: true, completion: nil)
//
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.signIn()
//
//
//
//        //Notifications
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "hide_indicator_err"), object: nil, queue: nil,
//        using: self.hide_indicator_notification)
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "show_indicator"), object: nil, queue: nil,
//        using: self.indicator_notification)
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "googleSignIn_notification"), object: nil, queue: nil,
//        using: self.notificationReceived)
        
        
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        self.present(utils.displayDialog(title: "Disabled", msg: "Please continue with email for now"), animated: true, completion: nil)
        //performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    
 
    @IBAction func emailTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToEmail", sender: self)
        
    }
    
    
}

//MARK:- Globar Notifications
extension LoginVC{
    //Google Sign-in notifications
    func notificationReceived(notification: Notification) {
        hud_google.dismiss()
        
        if let user = notification.userInfo?["userInfo"] as? GIDGoogleUser{
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
            
            
//            print(userId, idToken, fullName, givenName, familyName, email)
        }
        
        print("segue to next")
    }
    
    func hide_indicator_notification(notification: Notification){
        hud_google.dismiss()
    }
    
    func indicator_notification(notification: Notification){
        
        hud_google.textLabel.text = "Logging in"
        hud_google.show(in: self.view)
    }
    
    
}


//MARK:- Lifecycle
extension LoginVC{
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "user")
        if decoded != nil{
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? User
            
            if decodedUser != nil{
                self.existingUser = decodedUser
                performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
        
        else{
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome"{
            let tabVC = segue.destination as! UITabBarController
            let destVC = tabVC.children.first as! HomeVC
            destVC.user = self.existingUser
        }
    }
}


//MARK:- Interface Setup
extension LoginVC{
    func setupInterface(){
        report_view.layer.cornerRadius = report_view.frame.size.width/2
        report_view.clipsToBounds = true
        
        playVideo()
    }
    
    func allViewsToFront(){
        videoLayer.bringSubviewToFront(report_view)
        videoLayer.bringSubviewToFront(hear_imgView)
        videoLayer.bringSubviewToFront(title_lbl)
        videoLayer.bringSubviewToFront(subtitle_lbl)
        videoLayer.bringSubviewToFront(privacyMain_lbl)
        videoLayer.bringSubviewToFront(loginForm_stack)
    }
}

//MARK:- Helpers
extension LoginVC{
    
    
    
    func playVideo(){
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mp4") else{
            return
        }
        
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        looper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        
        playerLayer!.frame = self.view.bounds
        playerLayer!.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer!)
        queuePlayer?.play()
        
        allViewsToFront()
    }
    
    
    
    
}
