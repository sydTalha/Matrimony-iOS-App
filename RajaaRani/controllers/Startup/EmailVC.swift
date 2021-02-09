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
import TwilioChatClient


class EmailVC: UIViewController {

    //MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var user: User?
    
    //MARK:- Twilio Properties
    var twilioClient: TwilioChatClient?
    var channelList: TCHChannels?
    var userChannelList = [TCHChannel]()
    var twilioObj: TwilioClient = TwilioClient()
    
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
        
        user = User(_id: "", email: "", DOB: "", gender: "", nickname: "", city: "", country: "", lat: 0.0, lon: 0.0, sect: "", ethnic: "", job: "", phone: "", isCompleted: false, chatids: [])
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
                
                if let currUser = self.user{
                    if currUser.isCompleted{
                        
                        self.fetchTwilioTokenFromAPI(username: currUser._id) { (token) in
                            print(token)
                            
                            self.initializeClientWithToken(token: token) {
                                print("initialized")
                                
                                //save to User Defs and segue
                                self.saveUserInUserDefaults(user: currUser)
                                
                                //post notification to chat detail VC
                                
                                let notifDict = ["twilio": self.twilioObj]
                                NotificationCenter.default.post(name: .twilioDataNotificationKey, object: nil, userInfo: notifDict)
                                
                                self.performSegue(withIdentifier: "goToDashboard", sender: self)
                                
                            }
                            
                        }
                        
                    }
                    else{
                        hud.dismiss()
                        self.saveUserInUserDefaults(user: currUser)
                        self.performSegue(withIdentifier: "goToDashboard", sender: self)
                    }
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
        
        let userDb = User(_id: _id, email: email, DOB: dob, gender: gender, nickname: "", city: city, country: country, lat: lat, lon: lon, sect: "", ethnic: "", job: "", phone: "", isCompleted: isCompleted, chatids: [])
        
        if isCompleted{
            userDb.nickname = result["nickname"].stringValue
            userDb.sect = result["sect"].stringValue
            userDb.ethnic = result["ethnic"].stringValue
            userDb.job = result["job"].stringValue
            userDb.phone = result["phone"].stringValue
            let chatids = result["chat_ids"].arrayValue
            var idArr = [String]()
            for id in chatids{
                idArr.append(id.stringValue)
            }
            userDb.chatids = idArr
        }
        
        return userDb
    }
    
    func saveUserInUserDefaults(user: User){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        
        userDefaults.set(encodedData, forKey: "user")
        
        userDefaults.synchronize()
    }
    
    func fetchTwilioTokenFromAPI(username: String, completion: @escaping (String)->()){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        let params = ["username": username]
        AF.request(config.getTwilioTokenURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            
            let result = JSON(response.value)
            print(response)
            if responseCode >= 400 && responseCode <= 499{
                hud.dismiss()
                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio token"), animated: true, completion: nil)
            }
            else{
                hud.dismiss()
                let token = result.stringValue
                completion(token)
            }
        }
    }
    
    func initializeClientWithToken(token: String, completion: @escaping ()->()){
        
        TwilioChatClient.setLogLevel(.critical)
        
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { result, chatClient in
            print(chatClient)
            guard (result.isSuccessful()) else {
                print(result)
                return
            }
            print("here")
            self.twilioClient = chatClient
            print("early: \(self.twilioClient?.channelsList()?.subscribedChannels().count)")
            self.twilioObj.client = chatClient
            if let client = chatClient{
                if let channels = client.channelsList(){
                    self.twilioObj.channelList = channels.subscribedChannels()
                    channels.userChannelDescriptors { (res, paginator) in
                        if res.isSuccessful(){
                            //get paginator
                            if let paginatorItems = paginator{
                                for item in paginatorItems.items(){
                                    if let channelName = item.friendlyName{
                                        if channelName.contains(self.user?.email ?? ""){
                                            print(channelName)
                                            self.twilioObj.channelDescriptors.append(item)
                                        }
                                    }
                                }
                                print(self.twilioObj.channelDescriptors.count)
                                completion()
                            }
                        }
                    }
                    
                }
            }
            
            
//            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            self.isConnected = true
//            self.client = chatClient
//
//
//            self.setupChatChannel { (channel) in
//                self.currentChannel = channel
//            }
        }
    }
    
}

extension EmailVC: TwilioChatClientDelegate{
    
    func chatClient(_ client: TwilioChatClient, connectionStateUpdated state: TCHClientConnectionState) {
        if state == .error || state == .fatalError{
            print("error occurred while connecting")
        }
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        
        print("in sync")
        if status == .all {
            print("all: \(status.rawValue)")
            self.channelList = twilioClient?.channelsList()
            
            let chatClient = TwilioClient()
            
            self.channelList?.userChannelDescriptors(completion: { (result, paginator) in
                if result.isSuccessful(){
                    //print(paginator?.items().count)
                    if let currUser = self.user{
//                        let myGroup = DispatchGroup()
//                        myGroup.enter()
//                        if let paginator = paginator{
//                            chatClient.channelDescriptors = paginator.items()
//                        }
////                        for page in paginator?.items() ?? [TCHChannelDescriptor](){
////                            if let channelName = page.friendlyName{
////                                print(channelName)
//////                                if channelName.contains(currUser.email) && channelName.contains("unaveed97@gmail.com"){
//////                                    page.channel { (result, channel) in
//////
//////                                        if result.isSuccessful(){
//////                                            channel?.destroy(completion: { (result) in
//////                                                if result.isSuccessful(){
//////                                                    print("deleted")
//////                                                }
//////                                                else{
//////                                                    print(result.error)
//////                                                }
//////                                            })
//////                                        }
//////
//////                                    }
//////                                }
////
////                                if currUser.chatids.contains(channelName){
////
////
////                                    page.channel { (result, channel) in
////                                        if result.isSuccessful(){
////                                            if let channel = channel{
////                                                self.userChannelList.append(channel)
////
////                                            }
////                                        }
////                                        else{
////                                            self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while initializing chat channels"), animated: true, completion: nil)
////                                        }
////
////                                    }
////
////
////                                }
////                            }
////                        }
//
//
//                        chatClient.channelList = self.userChannelList
//                        print("channel list: ", chatClient.channelDescriptors.count)
//                        chatClient.client = self.twilioClient
//
                        
                        
                        
                    }
                    
                }
                else{
                    self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while initializing chat channels"), animated: true, completion: nil)
                }
                
            })
            
        }
        else if status == .identifier{
            print("identifier: \(status.rawValue)")
            self.channelList = client.channelsList()
            
            //self.joinChannel()
        }
        else if status == .metadata{
            print("metadata: \(status.rawValue)")
            self.channelList = twilioClient?.channelsList()
            
            
            
            
        }
        else if status == .failed{
            print("failed: \(status.rawValue)")
        }
        else if status == .none{
            print("none: \(status.rawValue)")
        }
        else{
            print("error syncing \(status.rawValue)")
        }
    }
}
