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
import Quickblox
import QuickbloxWebRTC

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
         self.view.frame.origin.y = -215 // Move view 150 points upward
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
        
        user = User(_id: "", email: "", DOB: "", gender: "", nickname: "", city: "", country: "", lat: 0.0, lon: 0.0, sect: "", ethnic: "", job: "", phone: "", isCompleted: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVerify"{
            let destVC = segue.destination as! GenderSelectionVC
            destVC.user = self.user
        }
        else if segue.identifier == "goToDashboard"{
            let tabVC = segue.destination as! UITabBarController
            let destVC = tabVC.children.first as! HomeVC
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
            
            let result = JSON(res.value)
            
            if responseCode >= 400 && responseCode <= 499{
                
                print(result)
                let errorMsg = result["message"].stringValue
                if errorMsg == "null"{
                    self.user?.email = email
                    self.performSegue(withIdentifier: "goToVerify", sender: self)
                }
                else{
                    DispatchQueue.main.async {
                        hud.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                        
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
            }
            else if responseCode == 200{
                self.user = self.parseUserObj(result: result)
                
                
                //sign in quickblox
                if self.user?.isCompleted ?? false{
                    //self.loginQuickBlox(hud: hud)
                    self.saveUserInUserDefaults(user: self.user!)
                    
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                }
                else{
                    hud.dismiss()
                    self.saveUserInUserDefaults(user: self.user!)
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                }
                
                
            }
            else{
                DispatchQueue.main.async {
                    hud.dismiss()
                    self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong, please try again"), animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
    func parseUserObj(result: JSON) -> User{
        let _id = result["_id"].stringValue
        let dob = result["DOB"].stringValue
        let gender = result["gender"].stringValue
        let email = result["email"].stringValue
        let city = result["location"]["city"].stringValue
        let country = result["location"]["country"].stringValue
        let lat = result["location"]["coords"]["lat"].doubleValue
        let lon = result["location"]["coords"]["lon"].doubleValue
        let isCompleted = result["isCompleted"].boolValue
        
        let userDb = User(_id: _id, email: email, DOB: dob, gender: gender, nickname: "", city: city, country: country, lat: lat, lon: lon, sect: "", ethnic: "", job: "", phone: "", isCompleted: isCompleted)
        
        if isCompleted{
            userDb.nickname = result["nickname"].stringValue
            userDb.sect = result["sect"].stringValue
            userDb.ethnic = result["ethnic"].stringValue
            userDb.job = result["job"].stringValue
            userDb.phone = result["phone"].stringValue
        }
        
        return userDb
    }
    
    
    func loginQuickBlox(hud: JGProgressHUD){
        
        QBRequest.logIn(withUserEmail: self.user?.email ?? "", password: self.user?._id ?? "") { (response, userResp) in
            hud.dismiss()
            
            self.saveUserInUserDefaults(user: self.user!)
            
            self.performSegue(withIdentifier: "goToDashboard", sender: self)
        } errorBlock: { (errorCode) in
            
            if errorCode.status.rawValue == 401{
                //need to register user
                print("here in register \(self.user?._id ?? "")")
                let userQB = QBUUser()
                if let user1 = self.user{
                    var count = 0
                    var halfID = ""
                    for val in user1._id{
                        if count == user1._id.count / 2{
                            break
                        }
                        else{
                            halfID = halfID + String(val)
                        }
                        count = count + 1
                    }
                    
                    if let id = UInt.parse(from: halfID) {
                        userQB.id = id
                        
                        userQB.email = user1.email
                        userQB.fullName = user1.nickname
                        userQB.password = user1._id
                        print("here")
                        
                        QBRequest.signUp(userQB) { (response, userQBResponse) in
                            //success
                            
                            if response.isSuccess{
                                hud.dismiss()
                                
                                
                            }
                            else{
                                print(response.error)
                                DispatchQueue.main.async {
                                    hud.dismiss()
                                    self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong, please try again, if issue presists then contact support"), animated: true, completion: nil)
                                }
                            }
                            
                        } errorBlock: { (errorCode) in
                            print("signup error: \(errorCode)")
                            
                            DispatchQueue.main.async {
                                hud.dismiss()
                                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong, please try again"), animated: true, completion: nil)
                            }
                        }

                    }
                    
                }
                
                
                
                
                
                
                
            }
            else{
                print("error logging in quickblox: \(errorCode.status.rawValue)")
                DispatchQueue.main.async {
                    hud.dismiss()
                    self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong, please try again"), animated: true, completion: nil)
                }
            }
            
            
        }

    }
    
    
    func saveUserInUserDefaults(user: User){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        
        userDefaults.set(encodedData, forKey: "user")
        
        userDefaults.synchronize()
    }
}
