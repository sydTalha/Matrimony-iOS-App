//
//  EmailVC.swift
//  RajaaRani
//

//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import JGProgressHUD

class EmailVC: UIViewController {

    //MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var user: User?
    
    //MARK:- Outlets
    @IBOutlet weak var report_view: UIView!
    
    @IBOutlet weak var videoLayer: UIView!
    
    @IBOutlet weak var hear_imgView: UIImageView!
    @IBOutlet weak var subtitle_lbl: UILabel!
    
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var privacyMain_lbl: UILabel!
    
    @IBOutlet weak var loginForm_stack: UIStackView!
    
    @IBOutlet weak var back_img: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    //MARK:- Constraints Outlets
    
    
    //MARK:- Actions

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        
        
        if(emailTxtField.text?.isEmpty ?? true){
            let alert = UIAlertController(title: "Empty Field", message: "Please enter a valid email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let emailText = emailTxtField.text!
            if (self.isValidEmail(emailText)){
                
                //valid email
                
                //check if user exists from Login API call
                self.checkUser(email: emailText)
                
                
            }
            else{
                let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    

}


//MARK:- Event Handlers
extension EmailVC{
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -180 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
}

//MARK:- Lifecycle
extension EmailVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        user = User(email: "", DOB: "", gender: "", nickname: "", sect: "", ethnic: "", job: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVerify"{
            let destVC = segue.destination as! GenderSelectionVC
            destVC.user = self.user
        }
    }
    
}


//MARK:- Interface Setup
extension EmailVC{

    func setupInterface(){
        self.hideKeyboardWhenTappedAround()
        
        report_view.layer.cornerRadius = report_view.frame.size.width/2
        report_view.clipsToBounds = true
        
        playVideo()
        
        
        //Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func allViewsToFront(){
        videoLayer.bringSubviewToFront(report_view)
        videoLayer.bringSubviewToFront(hear_imgView)
        videoLayer.bringSubviewToFront(title_lbl)
        videoLayer.bringSubviewToFront(subtitle_lbl)
        videoLayer.bringSubviewToFront(privacyMain_lbl)
        videoLayer.bringSubviewToFront(loginForm_stack)
        videoLayer.bringSubviewToFront(back_img)
        videoLayer.bringSubviewToFront(backBtn)
    }

}

//MARK:- Helpers
extension EmailVC{
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

    //email validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
        
    func checkUser(email: String){
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        print("here")
        let params = ["email": email]
        AF.request(config.loginURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (res) in
            let responseCode = res.response?.statusCode ?? 0
            print(res.result)
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(res.value)
                print(result)
                let errorMsg = result["message"].stringValue
                if errorMsg == "null"{
                    self.user?.email = email
                    self.performSegue(withIdentifier: "goToVerify", sender: self)
                }
                DispatchQueue.main.async {
                    hud.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else if responseCode == 200{
                
                self.performSegue(withIdentifier: "goToDashboard", sender: self)
            }
            
        }
    }
    
    
}
