//
//  ChatsVC.swift
//  RajaaRani
//

//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import TwilioChatClient
import EzPopup

class ChatsVC: UIViewController {

    //MARK:- Properties
    var user: User?
    var otherUser: User?
    
    var chat_id: String = ""
    
    var matchedUsers = [User]()
    var readChats = [User]()
    var unreadChats = [User]()
    var allChats = [User]()
    var chatids = [String]()
    var tmpChats = [User]()
    
    var twilioClient: TwilioClient = TwilioClient()
    //MARK:- Outlets
    @IBOutlet weak var username_lbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var matchedCollectionView: UICollectionView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var allChats_btn: UIButton!
    
    @IBOutlet weak var readChats_btn: UIButton!
    
    @IBOutlet weak var unreadChats_btn: UIButton!
    
    //MARK:- Actions
    
    @IBAction func allChatsTapped(_ sender: UIButton) {
        
        //allChats_btn.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        Layer.allButtonBadge(button: allChats_btn, text: allChats_btn.titleLabel?.text ?? "")
        
        for layer in unreadChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
        
        for layer in readChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
        
    }
    
    @IBAction func readChatsTapped(_ sender: Any) {
        
        Layer.readButtonBadge(button: readChats_btn, text: readChats_btn.titleLabel?.text ?? "")
        
        for layer in unreadChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
        
        for layer in allChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
    
    }
    
    @IBAction func unreadChatsTapped(_ sender: UIButton) {
        
        Layer.unreadButtonBadge(button: unreadChats_btn, text: unreadChats_btn.titleLabel?.text ?? "")
        
        for layer in allChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
        
        for layer in readChats_btn.layer.sublayers ?? [CALayer]() {
            if(layer.name == "dot"){
                layer.removeFromSuperlayer()
            }
        }
        
    }
    


}

//MARK:- Notifications
extension ChatsVC{
    @objc func getTwilioObj(_ notification: NSNotification) {
        print("twilio notifi")
        if let twilioObj = notification.userInfo?["twilio"] as? TwilioClient {
            //self.twilioClient = twilioObj
            //print("channel list: \(twilioClient.channelList.count)")
        }
    }
}

//MARK:- Lifecycle
extension ChatsVC{
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !(user?.isCompleted ?? false){
            let storyboard = UIStoryboard(name: "ProfileVerification", bundle: nil)
            let contentVC = storyboard.instantiateViewController(withIdentifier: "complete_profile_vc") as! CompleteProfileVC
            contentVC.user = self.user
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height

            let popupVC = PopupViewController(contentController: contentVC, position: .center(CGPoint.zero), popupWidth: screenWidth, popupHeight: screenHeight)
            popupVC.backgroundAlpha = 1.0
            popupVC.canTapOutsideToDismiss = false
            
            popupVC.shadowEnabled = false
            present(popupVC, animated: true, completion: nil)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.hero.navigationAnimationType = .fade
        
        self.matchedUsers.removeAll()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.getTwilioObj(_:)), name: .twilioDataNotificationKey, object: nil)
        
        fetchUsersFromAPI { (result) in
            if result{
                self.fetchChatIDFromAPI { (res) in
                    if res{
                        print(self.chatids.count)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        tmpChats = matchedUsers
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat"{
            let destVC = segue.destination as! ChatDetailVC
            destVC.user = user
            destVC.otherUser = otherUser
            destVC.chat_id = self.chat_id
            destVC.twilioObj = self.twilioClient
            for name in self.twilioClient.channelList{
                if name.friendlyName == self.chat_id{
                    destVC.currentChannel = name
                }
            }
            if destVC.currentChannel == nil{
                print("here")
                //channel not created
            }
        }
    }
}

//MARK:- Interface Setup
extension ChatsVC{
    func setupInterface(){
        
        topView.roundCorners([.bottomLeft, .bottomRight], radius: 30)
        Layer.allButtonBadge(button: allChats_btn, text: (allChats_btn.titleLabel?.text)!, fontSize: 15)
        
        
        let vc = self.tabBarController?.viewControllers![0] as! HomeVC
        self.user = vc.user
        
        username_lbl.text = self.user?.nickname ?? ""
        
        self.twilioClient = vc.twilioClient
        print("channel list \(twilioClient.channelList)")
        tableView.tableFooterView = UIView()
        
        matchedCollectionView.delegate = self
        matchedCollectionView.dataSource = self
        
        
    }
    
    
    
    
}

//MARK:- CollectionView Delegate and Datasource
extension ChatsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matchedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chat_cell", for: indexPath) as! MatchedChatCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
}

//MARK:- TableView Delegates
extension ChatsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twilioClient.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat_cell") as! ChatTableViewCell
        
        //cell.personName_lbl.text = matchedUsers[indexPath.row].nickname
        //cell.personName_lbl.text = matchedUsers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.otherUser = self.matchedUsers[indexPath.row]
        for id in chatids{
            if id.contains(self.user?.email ?? "") && id.contains(self.otherUser?.email ?? ""){
                self.chat_id = id
            }
        }
        print(self.chat_id)
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
}

//MARK:- Helpers
extension ChatsVC{
    func fetchUsersFromAPI(completion: @escaping (Bool)->()){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        let params = ["email": self.user?.email ?? ""]
        AF.request(config.matchedUsersURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            let result = JSON(response.value)
            if responseCode >= 400 && responseCode <= 499{
                let msg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                
                completion(false)
                
            }
            else if responseCode == 200{
                hud.dismiss()
                let userJsonArr = result.array!
                if userJsonArr.count == 0{
                    
                }
                else{
                    for user in userJsonArr{
                        let _id = user["_id"].stringValue
                        let dob = user["DOB"].stringValue
                        let gender = user["gender"].stringValue
                        let email = user["email"].stringValue
                        let city = user["location"]["city"].stringValue
                        let country = user["location"]["country"].stringValue
                        let lat = user["location"]["coords"]["lat"].doubleValue
                        let lon = user["location"]["coords"]["lon"].doubleValue
                        let isCompleted = user["isCompleted"].boolValue
                        
                        let nickname = user["nickname"].stringValue
                        let sect = user["sect"].stringValue
                        let ethnic = user["ethnic"].stringValue
                        let job = user["job"].stringValue
                        let phone = user["phone"].stringValue
                        let userObj = User(_id: _id, email: email, DOB: dob, gender: gender, nickname: nickname, city: city, country: country, lat: lat, lon: lon, sect: sect, ethnic: ethnic, job: job, phone: phone, isCompleted: isCompleted, chatids: [], matches: [])
                        self.matchedUsers.append(userObj)
                        
                    }
                    
                    self.tableView.reloadData()
                    self.matchedCollectionView.reloadData()
                    completion(true)
                }
                
            }
        }
        
    }
    
    func fetchChatIDFromAPI(completion: @escaping (Bool)->()){
        let params = ["email": self.user?.email ?? ""]
        
        AF.request(config.getChatIDAPI, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            let result = JSON(response.value)
            print(result)
            if responseCode >= 400 && responseCode <= 499{
                let msg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    //hud.dismiss()
                    
                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                completion(false)
                
            }
            else if responseCode == 200{
                self.chatids.removeAll()
                let idArr = result.array!
                for id in idArr{
                    self.chatids.append(id.stringValue)
                }
                completion(true)
            }
        }
    }
    
    
}
