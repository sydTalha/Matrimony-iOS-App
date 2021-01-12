//
//  PhoneVerifyVC.swift
//  RajaaRani
//
//

import UIKit
import OTPFieldView
import JGProgressHUD
import SwiftyJSON
import Alamofire
import CoreLocation

class EmailVerifyVC: UIViewController {

    //MARK:- Properties
    var user: User?
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    //MARK:- Outlets
    
    @IBOutlet weak var otpView: OTPFieldView!
    
    @IBOutlet weak var emailTitle_lbl: UILabel!
    
    
    //MARK:- Actions

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func codeResendTapped(_ sender: UIButton) {
        
        //performSegue(withIdentifier: "goToCompleteProfile", sender: self)
    }
    
    

}

//MARK:- Event Handlers
extension EmailVerifyVC{
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
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
extension EmailVerifyVC{
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
}

//MARK:- Interface Setup
extension EmailVerifyVC{
    func setupInterface(){
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        setupOtpView()
        
        emailTitle_lbl.text = user?.email
        
        getLocationService()
    }
    
    
    func setupOtpView(){
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = UIColor.gray
        self.otpView.filledBorderColor = UIColor(red: 98/255, green: 13/255, blue: 135/255, alpha: 1.0)
        self.otpView.cursorColor = UIColor(red: 98/255, green: 13/255, blue: 135/255, alpha: 1.0)
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.otpInputType = .numeric
        self.otpView.initializeUI()
        
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

//MARK:- OTPView Delegate
extension EmailVerifyVC: OTPFieldViewDelegate{
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
        
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
        
    func enteredOTP(otp otpString: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        verifyOTP(otpCode: otpString, hud: hud)
        
    }
    
    
}


//MARK:- CLLocation Delegate
extension EmailVerifyVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("in loc")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.user?.city = city.lowercased()
            self.user?.country = country.lowercased()
            self.user?.lat = locValue.latitude
            self.user?.lon = locValue.longitude
            print(self.lat, self.lon)
            
            self.sendRegisterRequest()
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
extension EmailVerifyVC{
    
    func sendRegisterRequest(){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        let params = ["email": self.user?.email ?? "",
                      "DOB": self.user?.DOB ?? "",
                      "gender": self.user?.gender ?? "",
                      "location": ["coords": ["lat": self.lat, "lon": self.lon], "city": self.user?.city ?? "", "country": self.user?.country ?? ""]] as [String : Any]
        print(params)
        
        AF.request(config.registerURL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response.response?.statusCode ?? 0)
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let errorMsg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                print(result)
                hud.dismiss()
                
            }
        }
        
    }
    
    func verifyOTP(otpCode: String, hud: JGProgressHUD){
        let params = ["email": self.user?.email ?? "",
                      "code": otpCode] as [String : Any]
        
        AF.request(config.verifyURL, method: .get, parameters: params).responseJSON { (response) in
            print(response.result)
            
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let errorMsg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    let alert = UIAlertController(title: "Alert", message: "\(errorMsg)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                print(result)
                
                //save user prefs
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                
                userDefaults.set(encodedData, forKey: "user")
                
                userDefaults.synchronize()
                
                
                self.performSegue(withIdentifier: "goToCompleteProfile", sender: self)
                hud.dismiss()
                
            }
            
        }
    }
    
    
    func locationDenied(){
        if let url = URL(string:UIApplication.openSettingsURLString) {
            
           if UIApplication.shared.canOpenURL(url) {
                
            let alertText = "It looks like your privacy settings are preventing us from accessing your location. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."

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
