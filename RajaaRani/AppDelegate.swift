//
//  AppDelegate.swift
//  RajaaRani
//
//

import UIKit
import GoogleSignIn
import Alamofire


@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window:UIWindow?

    //g-sign in: 690010998607-qfr8i70m0vh5pr9loafnf045kmq5lqtk.apps.googleusercontent.com
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //google sign-in initializtaions
        GIDSignIn.sharedInstance().clientID = "690010998607-qfr8i70m0vh5pr9loafnf045kmq5lqtk.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        return true
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //SocketIOManager.sharedInstance.establishConnection()
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        NotificationCenter.default.post(name: Notification.Name("show_indicator"), object: nil)
        
        if let error = error {

            NotificationCenter.default.post(name: Notification.Name("hide_indicator_err"), object: nil)

            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
                return
            }
        }
        // Perform any operations on signed in user here.
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        //user.profile.imageURL(withDimension: )
        
        //print(userId, idToken, fullName, givenName, familyName, email)
        let googleUserDetails = ["userInfo": user]
        NotificationCenter.default.post(name: Notification.Name("googleSignIn_notification"), object: nil, userInfo: googleUserDetails as [AnyHashable : Any])

    }

    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}

