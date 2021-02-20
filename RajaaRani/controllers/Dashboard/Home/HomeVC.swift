//
//  HomeVC.swift
//  RajaaRani
//

//

import UIKit
import Koloda
import Alamofire
import JGProgressHUD
import SwiftyJSON
import CoreLocation
import AVFoundation
import TwilioChatClient
import TwilioVideo

class HomeVC: UIViewController {

    //MARK:- Properties
    
    var cardExpanded = false
    var count = 0
    var user: User?
    let locationManager = CLLocationManager()
    var dbUsers = [User]()
    var matchedEmail: String = ""
    var kolodaIndex = 0
    
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var hud: JGProgressHUD = JGProgressHUD(style: .dark)
    var twilioClient: TwilioClient = TwilioClient()
    var twilioToken: String = ""
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var username_Age_lbl: UILabel!
    
    @IBOutlet weak var dislike_view: UIView!
    
    @IBOutlet weak var like_view: UIView!
    
    @IBOutlet weak var cardView: KolodaView!
    
    @IBOutlet weak var endOfStack_lbl: UILabel!
    
    
    //MARK:- Constraints
    
    
    //MARK:- Actions
    
    
   


}


//MARK:- Event Handlers
extension HomeVC{

    @objc func willEnterForeground() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        if authStatus == .denied || authStatus == .restricted {
            // add any alert or inform the user to to enable location services
            
            //self.performSegue(withIdentifier: "goToNoLoc", sender: self)
            
            locationDenied()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            print("getting loc")
            locationManager.startUpdatingLocation()
        }
       
    }
    
    @objc func likeTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("here")
        cardView.swipe(.right)
    }

    @objc func dislikeTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("here")
        cardView.swipe(.left)
    }
    
}


//MARK:- Lifecycle
extension HomeVC{
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("in appear")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInterface()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
//        cardStack_main.delegate = self
//        cardStack_main.dataSource = self
        cardView.delegate = self
        cardView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLikes"{
            let destVC = segue.destination as! LikedVC
            destVC.email = matchedEmail
        }
    }
    
}


//MARK:- Interface Setup
extension HomeVC{
    func setupInterface(){
        print(user?.email)
        
        print(NetworkMonitor.isConnectionAvailable)
//        if !NetworkMonitor.isConnectionAvailable{
//            let alert = UIAlertController(title: "Network not available", message: "Please enable Wi-Fi or Cellular Data to access data", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        
        
        
        if self.user?.isCompleted ?? false{
            self.tabBarController?.tabBar.isUserInteractionEnabled = false

            self.setupTwilioChatChannels()
        }
        self.cardView.cornerRadius = 13
        self.cardView.setCardView()
        self.cardView.countOfVisibleCards = 2
        self.like_view.layer.cornerRadius = self.like_view.frame.size.width/2
        self.like_view.clipsToBounds = true
        
        self.dislike_view.layer.cornerRadius = self.dislike_view.frame.size.width/2
        self.dislike_view.clipsToBounds = true
        
        
        
        getLocationService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setupEventHandlers()
        
    }
    
    func getLocationService(){
        
        
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        if authStatus == .denied || authStatus == .restricted {
            // add any alert or inform the user to to enable location services
            
            locationDenied()
            
            
            
        }
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            print("getting loc")
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func hideLikeDislikeViews(){
//        UIView.transition(with: self.like_view,
//                          duration: 0.5,
//              options: .transitionCrossDissolve,
//           animations: { [weak self] in
//            self?.like_view.isHidden = true
//        }, completion: nil)
//
//        UIView.transition(with: self.dislike_view,
//                          duration: 0.5,
//              options: .transitionCrossDissolve,
//           animations: { [weak self] in
//            self?.dislike_view.isHidden = true
//        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5) {
            self.like_view.alpha = 0.0
        } completion: { (finished) in
            self.like_view.isHidden = finished
        }

        
        UIView.animate(withDuration: 0.5) {
            self.dislike_view.alpha = 0.0
        } completion: { (finished) in
            self.dislike_view.isHidden = finished
        }

        
        UIView.animate(withDuration: 0.5) {
            self.cardView.alpha = 0.0
        } completion: { (finished) in
            self.cardView.isHidden = finished
        }

        UIView.animate(withDuration: 0.5) {
            self.endOfStack_lbl.alpha = 1.0
        } completion: { (finished) in
            self.endOfStack_lbl.isHidden = !finished
        }
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 0.0
        } completion: { (finished) in
            self.tableView.isHidden = finished
        }
        
        UIView.animate(withDuration: 0.5) {
            self.username_Age_lbl.alpha = 0.0
        } completion: { (finished) in
            self.username_Age_lbl.isHidden = finished
        }
        
//        UIView.transition(with: self.cardView,
//                          duration: 0.5,
//              options: .transitionCrossDissolve,
//           animations: { [weak self] in
//            self?.cardView.isHidden = true
//        }, completion: nil)
    }
    
    
    func unhideLikeDislikeViews(){
        UIView.transition(with: self.like_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.like_view.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: self.dislike_view,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.dislike_view.isHidden = false
        }, completion: nil)
        
        UIView.transition(with: self.cardView,
                          duration: 0.3,
              options: .transitionCrossDissolve,
           animations: { [weak self] in
            self?.cardView.alpha = 1.0
            self?.cardView.isHidden = false
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.endOfStack_lbl.alpha = 0.0
        } completion: { (finished) in
            self.endOfStack_lbl.isHidden = finished
        }
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1.0
        } completion: { (finished) in
            self.tableView.isHidden = !finished
        }
        
        UIView.animate(withDuration: 0.5) {
            self.username_Age_lbl.alpha = 1.0
        } completion: { (finished) in
            self.username_Age_lbl.isHidden = !finished
        }
        
    }
    
    
    func setTextAnimation(label: UILabel, text: String){
//        let animation:CATransition = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name:
//            CAMediaTimingFunctionName.easeInEaseOut)
//        animation.type = CATransitionType.push
//        label.text = text
//        animation.duration = 0.25
//        label.layer.add(animation, forKey: CATransitionType.push.rawValue)
        
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = 0.5
        label.layer.add(animation, forKey: nil)
        label.text = text
    }
    
    
    func setupEventHandlers(){
        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeTapped(tapGestureRecognizer:)))
            like_view.isUserInteractionEnabled = true
            like_view.addGestureRecognizer(likeTapGestureRecognizer)
        
        let dislikeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dislikeTapped(tapGestureRecognizer:)))
            dislike_view.isUserInteractionEnabled = true
            dislike_view.addGestureRecognizer(dislikeTapGestureRecognizer)
    }
    
    func setupTwilioChatChannels(){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "user")
        if decoded != nil{
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? User
            
            if decodedUser != nil{
                self.user = decodedUser
                
                //fetching twilio token only when user is logged in
                TwilioManager.fetchTokenFromAPI(username: self.user?._id ?? "") { (token) in
                    if token == "" {
                        self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio token"), animated: true, completion: nil)
                    }
                    else{
                        print(token)
                        self.twilioToken = token
                        self.initializeClientWithToken(token: token) {
                            print(self.twilioClient.channelDescriptors.count)
                        }
                        
                    }
                }
                
                DispatchQueue.global(qos: .background).async {
                    
                }
            }
        }
        
        else{
            
        }
    }
    
}


//MARK:- Twilio Chat Delegate
extension HomeVC: TwilioChatClientDelegate{
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        
        if status == .channelsListCompleted{
            print("channel list available: \(client.channelsList()?.subscribedChannels().count)")
        }
        if status == .started{
            print("started")
        }
        if status == .completed{
            print("completed \(client.channelsList()?.subscribedChannels().count)")
            
        }
        if status == .failed{
            print("failed")
            self.present(utils.displayDialog(title: "Oops", msg: "Twilio API Failed"), animated: true, completion: nil)
        }
    }
    
}

//MARK:- TwilioVideo Room Delegate
extension HomeVC: RoomDelegate{
    func roomDidConnect(room: Room) {
        
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        
    }
}

//MARK:- TableView Datasource, Delegates
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var user = User(_id: "", email: "", DOB: "", gender: "", nickname: "", city: "", country: "", lat: 0.0, lon: 0.0, sect: "", ethnic: "", job: "", phone: "", isCompleted: false, chatids: [], matches: [])
        if !dbUsers.isEmpty{
            user = dbUsers[kolodaIndex]
        }
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutme_cell") as! AboutMeCell
            
            self.setTextAnimation(label: cell.aboutDesc_lbl, text: "About me. To choose what personal info to show when you interact with others on Google services, sign in to your account. Sign in. PrivacyTermsHelpAbout.")
            
            
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userStats1_cell") as! UserStatsFirstCell
            
            self.setTextAnimation(label: cell.marital_lbl, text: "Single")
            self.setTextAnimation(label: cell.religion_lbl, text: "Islam")
            
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userStats2_cell") as! UserStatsSecondCell
            
            self.setTextAnimation(label: cell.education_lbl, text: "Bachelor")
            if user.job != "" {
                self.setTextAnimation(label: cell.job_lbl, text: user.job)
            }
            else{
                self.setTextAnimation(label: cell.job_lbl, text: "")
            }
            
            self.setTextAnimation(label: cell.cast_lbl, text: "Niazi")
            self.setTextAnimation(label: cell.height_lbl, text: "195 cm")
            self.setTextAnimation(label: cell.complection_lbl, text: "Light")
            
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 90
        }
        if indexPath.row == 1{
            return 50
        }
        if indexPath.row == 2{
            return 67
        }
        else{
            return 55
        }
    }
    
    
}



//MARK:- Kolada CardView Delegate
extension HomeVC: KolodaViewDataSource, KolodaViewDelegate{
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let img = UIImage(named: "placeholder-card")
        let imgView = UIImageView(image: img)
        
        
        let ss = UIView()
        
        ss.frame = cardView.bounds
        //imgView.frame = ss.frame
        //ss.addSubview(imgView)
        
        playVideo(videoLayer: ss)
        cardView.bringSubviewToFront(ss)
        
        
        
        //let profileView = ProfileCard(frame: cardStack_main.bounds)
        //imgView.cornerRadius = 13
        
        //let userCardDetails = ["userCard": dbUsers[index]]
        //NotificationCenter.default.post(name: Notification.Name("userObj_sent"), object: nil, userInfo: userCardDetails as [AnyHashable : Any])
        
        
//        profileView.user = dbUsers[index]
//        s.addSubview(profileView)
        return ss
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        print(index)
        
        
        self.kolodaIndex = index
        let user = dbUsers[index]
        
        var indexArr = [IndexPath]()
        indexArr.append(IndexPath(row: 0, section: 0))
        indexArr.append(IndexPath(row: 1, section: 0))
        indexArr.append(IndexPath(row: 2, section: 0))
        self.tableView.reloadRows(at: indexArr, with: .automatic)
        
        self.setTextAnimation(label: username_Age_lbl, text: user.nickname)
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dbUsers.count
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        //print(index)
        let swipeUser = dbUsers[index]
        //self.kolodaIndex = index
//        var indexArr = [IndexPath]()
//        indexArr.append(IndexPath(row: 0, section: 0))
//        indexArr.append(IndexPath(row: 1, section: 0))
//        indexArr.append(IndexPath(row: 2, section: 0))
//        self.tableView.reloadRows(at: indexArr, with: .automatic)
//
//        self.setTextAnimation(label: username_Age_lbl, text: swipeUser.nickname)
        if direction == .left{
            if self.user?.isCompleted ?? false{
                print("swipe left")
                self.swipeLeftAPI(userEmail: self.user?.email ?? "", profileEmail: swipeUser.email, koloda: koloda)
            }
            else{
                koloda.revertAction(direction: .left)
                koloda.reloadData()
                self.showCompleteProfileVC()
            }
            
            
        }
        else if direction == .right{
            print("swipe right ")
            if self.user?.isCompleted ?? false{
                swipeRightAPI(userEmail: self.user?.email ?? "", cardUser: swipeUser, koloda: koloda)
            }
            else{
                //revert and show complete your profile screen
                koloda.revertAction(direction: .right)
                koloda.reloadData()
                self.showCompleteProfileVC()
            }
            
        }
    }

    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right]
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print(koloda.isRunOutOfCards)
        if dbUsers.count == 0{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.hideLikeDislikeViews()
            }
        }
        
        
        
        
    }

    
}


//MARK:- CLLocation Delegate
extension HomeVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            //self.user?.city = city.lowercased()
            self.user?.country = country.lowercased()
            self.loadProfiles()
            
        }
        
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted{
            
            
            locationDenied()
        }
    }
}

//MARK:- Helpers
extension HomeVC{
    
    func loadProfiles(){
        self.dbUsers.removeAll()
        
        let params = ["email": self.user?.email ?? "",
                      "gender": self.user?.gender ?? "",
                      "city": self.user?.city ?? "",
        "country": self.user?.country ?? ""] as [String: Any]
        print(params)
        AF.request(config.fetchPeopleURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (resp) in
            let result = JSON(resp.value)
            let responseCode = resp.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let errorMsg = result["message"].stringValue
                DispatchQueue.main.async {
                    //self.hud.dismiss()
                    self.present(utils.displayDialog(title: "Oops", msg: errorMsg), animated: true, completion: nil)
                }
            
            }
            else if responseCode == 200{
                print(result)
                if result.exists(){
                    
                    let userArr = result.array!
                    if userArr.count == 0{
                        //self.hud.dismiss()
                        print("no users")
                        self.hideLikeDislikeViews()
                    }
                    else{
                        for user in userArr{
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
                            self.dbUsers.append(userObj)
                            
                            
                            
                        }
                        self.cardView.reloadData()
                        self.unhideLikeDislikeViews()
                    }
                    
//                    self.cardStack_main.reloadData()
                }
                DispatchQueue.main.async {
                    //self.hud.dismiss()
                    
                    //self.unhideLikeDislikeViews()
                }
            }
            else{
                self.present(utils.displayDialog(title: "API Timeout", msg: "An error occurred with Backend API"), animated: true, completion: nil)
            }
        }
    }
    
    func swipeLeftAPI(userEmail: String, profileEmail: String, koloda: KolodaView){
        
        
        let params = ["email": userEmail,
        "profileEmail": profileEmail] as [String: Any]
        
        AF.request(config.swipeLeftURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (res) in
            let result = JSON(res.value)
            let responseCode = res.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let errorMsg = result["message"].stringValue
                DispatchQueue.main.async {
                    
                    koloda.revertAction()
                    self.present(utils.displayDialog(title: "Oops", msg: errorMsg), animated: true, completion: nil)
                    
                }
            }
            else if responseCode == 200{
                
            }
            
        }
    }
    
    func swipeRightAPI(userEmail: String, cardUser: User, koloda: KolodaView){
        
        
        let params = ["email": userEmail,
                      "profileEmail": cardUser.email] as [String: Any]
        
        AF.request(config.swipeRightURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (res) in
            let result = JSON(res.value)
            let responseCode = res.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let errorMsg = result["message"].stringValue
                DispatchQueue.main.async {
                    
                    koloda.revertAction()
                    self.present(utils.displayDialog(title: "Oops", msg: errorMsg), animated: true, completion: nil)
                    
                }
            }
            else if responseCode == 200{
                let isMatched = result["success"].boolValue
                print("is matched \(isMatched)")
                if(isMatched){
                    //user matched
                    //..
                    let chat_id = result["chat_id"].stringValue
                    
                    self.matchedEmail = cardUser.email
                    print("congrats! you matched with \(cardUser.email)")
                    
                    //create user channel
                    let options = [
                        TCHChannelOptionFriendlyName: chat_id,
                        TCHChannelOptionType: TCHChannelType.private.rawValue
                    ] as [String : Any]
                    self.twilioClient.client?.channelsList()?.createChannel(options: options, completion: { (channelResult, channel) in
                        if channelResult.isSuccessful(){
                            if let channel = channel{
                                channel.join { (res) in
                                    if res.isSuccessful(){

                                        self.twilioClient.channelList.append(channel)
                                        channel.members?.add(byIdentity: cardUser._id, completion: { (addRes) in
                                            if addRes.isSuccessful(){

                                                DispatchQueue.main.async {
                                                    self.performSegue(withIdentifier: "goToLiked", sender: self)
                                                }
                                            }
                                            else{
                                                print(addRes.error)
                                                self.present(utils.displayDialog(title: "Oops", msg: "Error adding member to channel"), animated: true, completion: nil)
                                            }
                                        })

                                    }
                                    else{
                                        print(res.error)
                                        self.present(utils.displayDialog(title: "Oops", msg: "Error joining matched channel"), animated: true, completion: nil)
                                    }
                                }
                                
                            }
                            
                        }
                        else{
                            print(channelResult.error)
                            self.present(utils.displayDialog(title: "Oops", msg: "Error creating matched channel"), animated: true, completion: nil)
                        }
                    })
                    
                    
                    
                }
                else{
                    
                }
            }
            
        }
    }
    
    func locationDenied(){
        if let url = URL(string:UIApplication.openSettingsURLString) {
            
           if UIApplication.shared.canOpenURL(url) {
                
            let alertText = "It looks like your privacy settings are preventing us from accessing your location. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Location on.\n\n3. Open this app and try again."

            let alertButton = "Go"
            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
            goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })
        
        
            let alert = UIAlertController(title: "Location Access Denied", message: alertText, preferredStyle: .alert)
            alert.addAction(goAction)
            self.present(alert, animated: true, completion: nil)
            
           }
        }
    }
    
    func playVideo(videoLayer: UIView){
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mp4") else{
            return
        }
        
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        looper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        
        playerLayer!.frame = videoLayer.bounds
        playerLayer!.videoGravity = .resizeAspectFill
        
        videoLayer.cornerRadius = 13
        videoLayer.layer.addSublayer(playerLayer!)
        queuePlayer?.play()
        
        //allViewsToFront()
    }
    
    func initializeClientWithToken(token: String, completion: @escaping ()->()){
        
        TwilioChatClient.setLogLevel(.critical)
        hud.show(in: self.view)
        
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { result, chatClient in
            print(chatClient)
            guard (result.isSuccessful()) else {
                print(result.resultText)
                return
            }
            print("here")
            
            //print("early: \(self.twilioClient?.channelsList()?.subscribedChannels().count)")
            
            if let client = chatClient{
                self.twilioClient.client = client
                if let channels = client.channelsList(){
                    self.twilioClient.channelList = channels.subscribedChannels()
                    
                    if self.twilioClient.channelList.count == 0{
                        
                        //no channels exists
                        self.hud.dismiss()
                        self.tabBarController?.tabBar.isUserInteractionEnabled = true
                        completion()
                        
                    }
                    else{
                        
                        
                        
                        channels.userChannelDescriptors { (res, paginator) in
                            if res.isSuccessful(){
                                //get paginator
                                if let paginatorItems = paginator{
                                    for item in paginatorItems.items(){
                                        if let channelName = item.friendlyName{
                                            
                                            if channelName.contains(self.user?.email ?? ""){
                                                print(channelName)
                                                
//                                                item.channel { (res, channel) in
//                                                    channel?.destroy(completion: { (resu) in
//                                                        print("deleted")
//                                                    })
//                                                }
                                                self.twilioClient.channelDescriptors.append(item)
                                            }
                                        }
                                    }
                                    self.hud.dismiss()
                                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                                    completion()
                                }
                            }
                            else{
                                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while getting chat channels"), animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func showCompleteProfileVC(){
        let profileStoryboard = UIStoryboard.init(name: "ProfileVerification", bundle: nil)
        let completeVC = profileStoryboard.instantiateViewController(identifier: "complete_profile_vc") as! CompleteProfileVC
        completeVC.from = 1
        completeVC.modalPresentationStyle = .fullScreen
        self.present(completeVC, animated: true, completion: nil)
    }
    
}



