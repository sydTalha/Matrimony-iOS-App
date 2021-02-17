//
//  SelfieVC.swift
//  RajaaRani
//

//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import JGProgressHUD

class SelfieVC: UIViewController {

    //MARK:- Properties
    var user: User?
    
    //MARK:- Outlets
    @IBOutlet weak var bgCardView: UIView!
    
    @IBOutlet weak var optView_1: UIView!
    
    @IBOutlet weak var optView_2: UIView!
    
    //MARK:- Actions
    
    @IBAction func takeSelfieTapped(_ sender: UIButton) {
        
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            do{
                
                let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                if (captureDevice == nil){
                    print("emulator")
                    
                    
                }
                else{
                    _ = try AVCaptureDeviceInput(device: captureDevice!)
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.allowsEditing = true
                    vc.delegate = self
                    present(vc, animated: true)
                }
                
                
                
            }
            catch{
                print("Error")
            }
            
        case .denied:
            self.camDenied()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if (granted)
                {
                    
                    DispatchQueue.main.async {
                        do{
                            
                            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
                            if (captureDevice == nil){
                                print("emulator")
                            }
                            _ = try AVCaptureDeviceInput(device: captureDevice!)
                            
                            let vc = UIImagePickerController()
                            vc.sourceType = .camera
                            vc.allowsEditing = true
                            vc.delegate = self
                            self.present(vc, animated: true)
                        }
                        catch{
                            print("Error")
                        }
                        
                        
                        
                    }
                    
                    
                }
                else
                {
                    self.camDenied()
                }
            }
            
        default:
            let alert = UIAlertController(title: "Error",
                                          message: "Unable to access camera on your device",
                                          preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
            
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}


//MARK:- Lifecycle
extension SelfieVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUnderReview"{
            let destVC = segue.destination as! ProfileUnderReviewVC
            destVC.user = self.user
        }
    }
}

//MARK:- Interface Setup
extension SelfieVC{
    func setupInterface(){
        self.bgCardView.setCardView()
        
        optView_1.layer.cornerRadius = optView_1.frame.size.width/2
        optView_1.clipsToBounds = true
        optView_1.setSmallShadow()
        optView_2.layer.cornerRadius = optView_2.frame.size.width/2
        optView_2.clipsToBounds = true
        optView_2.setSmallShadow()
    }
}

//MARK:- UIImagePicker and UINavigationController Delegate
extension SelfieVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        uploadImageToDB(image: image)

        
        
    }
}


//MARK:- Helpers
extension SelfieVC{
    func camDenied()
    {
        DispatchQueue.main.async
            {
                var alertText = "It looks like your privacy settings are preventing us from accessing your camera to capture your selfie. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."

                var alertButton = "OK"
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                {
                    alertText = "It looks like your privacy settings are preventing us from accessing your camera to capture your selfie. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."

                    alertButton = "Go"

                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }

                let alert = UIAlertController(title: "Camera Access Denied", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func uploadImageToDB(image: UIImage){
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters = ["email": self.user?.email ?? ""] //Optional for extra parameter
        let headers: HTTPHeaders = ["Content-Type": "image/png"]

        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image", fileName: "selfie.jpg", mimeType: "image/jpg")
               for (key, value) in parameters {
                       multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                   } //Optional for extra parameters
           },
        to:config.selfieVerifyURL, method: .post, headers: headers).response{ response in
            //print(response.result)
            print(JSON(response.value))
            let responseCode = response.response?.statusCode ?? 0
            if responseCode >= 400 && responseCode <= 499{
                let result = JSON(response.value)
                let msg = result["message"].stringValue
                
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                    self.present(utils.displayDialog(title: "Alert", msg: msg), animated: true, completion: nil)
                }
                
            }
            
            else if responseCode == 200{
                let result = JSON(response.value ?? "register response nil")
                
                self.user = self.parseUserObj(result: result)
                
                //save user prefs
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.user!)
                
                userDefaults.set(encodedData, forKey: "user")
                
                userDefaults.synchronize()
                
                print(result)
                DispatchQueue.main.async {
                    hud.dismiss()
                    
                    //segue to next
                    self.performSegue(withIdentifier: "goToUnderReview", sender: self)
                    
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
        
        let nickname = result["nickname"].stringValue
        let sect = result["sect"].stringValue
        let ethnic = result["ethnic"].stringValue
        let job = result["job"].stringValue
        let phone = result["phone"].stringValue
        let userObj = User(_id: _id, email: email, DOB: dob, gender: gender, nickname: nickname, city: city, country: country, lat: lat, lon: lon, sect: sect, ethnic: ethnic, job: job, phone: phone, isCompleted: isCompleted, chatids: [], matches: [])
        
        return userObj
    }
}
