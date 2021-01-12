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

class HomeVC: UIViewController {

    //MARK:- Properties
    
    var cardExpanded = false
    var count = 0
    var user: User?
    let locationManager = CLLocationManager()
    var dbUsers = [User]()
    
    //MARK:- Outlets
    @IBOutlet weak var cardStack_main: KolodaView!
    
    
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
    
}


//MARK:- Lifecycle
extension HomeVC{
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.cardStack_main.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //loadProfiles()
        self.cardStack_main.reloadData()
        
        //load user obj from prefs
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "user")
        if decoded != nil{
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? User
            
            if decodedUser != nil{
                self.user = decodedUser
                
            }
        }
        
        else{
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        cardStack_main.delegate = self
        cardStack_main.dataSource = self
        
        
        
        
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
        
        getLocationService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
    
    
}



//MARK:- Kolada CardView Delegate
extension HomeVC: KolodaViewDataSource, KolodaViewDelegate{
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let s = UIView()
        let profileView = ProfileCard(frame: cardStack_main.bounds)
        
        let userCardDetails = ["userCard": dbUsers[index]]
        NotificationCenter.default.post(name: Notification.Name("userObj_sent"), object: nil, userInfo: userCardDetails as [AnyHashable : Any])
        
        
        profileView.user = dbUsers[index]
        s.addSubview(profileView)
        return s
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dbUsers.count
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let swipeUser = dbUsers[index]
        if direction == .left{
            print("swipe left")
            self.swipeLeftAPI(userEmail: self.user?.email ?? "", profileEmail: swipeUser.email, koloda: koloda)
            
        }
        else if direction == .right{
            print("swipe right ")
            swipeRightAPI(userEmail: self.user?.email ?? "", profileEmail: swipeUser.email, koloda: koloda)
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
        }
        loadProfiles()
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
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
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
                    hud.dismiss()
                    self.present(utils.displayDialog(title: "Oops", msg: errorMsg), animated: true, completion: nil)
                }
            
            }
            else if responseCode == 200{
                print(result)
                if result.exists(){
                    let userArr = result.array!
                    for user in userArr{
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
                        let userObj = User(email: email, DOB: dob, gender: gender, nickname: nickname, city: city, country: country, lat: lat, lon: lon, sect: sect, ethnic: ethnic, job: job, phone: phone, isCompleted: isCompleted)
                        self.dbUsers.append(userObj)
                        
                        
                        
                    }
                    self.cardStack_main.reloadData()
                }
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                }
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
    
    func swipeRightAPI(userEmail: String, profileEmail: String, koloda: KolodaView){
        
        
        let params = ["email": userEmail,
        "profileEmail": profileEmail] as [String: Any]
        
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
                    print("congrats! you matched with \(profileEmail)")
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
}



