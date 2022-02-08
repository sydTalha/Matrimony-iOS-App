//
//  AppDelegate.swift
//  RajaaRani
//
//

import UIKit
import GoogleSignIn
import Alamofire
import PushKit
import CallKit
import Firebase
import SwiftyJSON
import TwilioVideo

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window:UIWindow?
    var devToken: String = ""
    var currentCallUUID: UUID?
    var room: Room?
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    var currentUserID: String = ""
    var chat_id: String = ""
    var otherUserName: String = ""

    //g-sign in: 690010998607-qfr8i70m0vh5pr9loafnf045kmq5lqtk.apps.googleusercontent.com
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        self.voipRegistration()
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
          (granted, error) in
          print("User allowed notifications:", granted)
          if granted {
            DispatchQueue.main.async {
                center.delegate = self
                UIApplication.shared.registerForRemoteNotifications()
            }
          }
        }
        
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

//MARK:- Push Notification Delegate
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //register for notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Received device token \(deviceToken)")
        if let chatClient = ChatPushNotificationState.shared.chatClient, chatClient.user != nil {
            chatClient.register(withNotificationToken: deviceToken) { (result) in
                if (!result.isSuccessful()) {
                    print("errorrr \(result.error?.localizedDescription)")
                    // try registration again or verify token
                }
            }
        }
        else {
            ChatPushNotificationState.shared.updatedPushToken = deviceToken
        }
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
          tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        //devToken = tokenString
        
    }
    
    
    //fail to register for notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("hereee \(error.localizedDescription)")
        ChatPushNotificationState.shared.updatedPushToken = nil
    }
    
    
    //received remote notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("received notifiii: \(userInfo)")
       
        
    }


    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        print("received notifi")
       let userInfo = response.notification.request.content.userInfo
        if let chatClient = ChatPushNotificationState.shared.chatClient, chatClient.user != nil {
           // If your reference to the Chat client exists and is initialized, send the notification to it
           chatClient.handleNotification(userInfo) { (result) in
               if (!result.isSuccessful()) {
                print("error occurred while handling notifi\(result.error)")
                   // Handling of notification was not successful, retry?
               }
               else{
                
                print(userInfo)
               }
            
           }
       } else {
            
           // Store the notification for later handling
            ChatPushNotificationState.shared.receivedNotification = userInfo
            
            print(userInfo)
       }
    }
    
    //about to present the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //completionHandler(.badge)
    }
}

//MARK:- PKPush Registe Delegate
extension AppDelegate: PKPushRegistryDelegate{
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("pushRegistry -> deviceToken :\(deviceToken)")
        self.devToken = deviceToken
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        print("received notifiiiii \(payload.dictionaryPayload)")
        
        let result = JSON(payload.dictionaryPayload)
        
        if result["type"].exists(){
            let name = result["name"].stringValue
            let type = result["type"].stringValue
            self.otherUserName = name
            
            let config = CXProviderConfiguration(localizedName: "RajaaRani")
            config.includesCallsInRecents = false
            config.supportsVideo = false
            let provider = CXProvider(configuration: config)
            provider.setDelegate(self, queue: nil)
            let update = CXCallUpdate()
            update.remoteHandle = CXHandle(type: .generic, value: name)
            update.hasVideo = false
            
            if type == "call"{
                self.currentUserID = result["current_user_id"].stringValue
                self.chat_id = result["chat_id"].stringValue
                print(result)
                
                self.currentCallUUID = UUID()
                print(currentCallUUID!)
                provider.reportNewIncomingCall(with: currentCallUUID!, update: update, completion: { error in })
            }
            if type == "decline"{
                if currentCallUUID != nil{
                    let cxCallController = CXCallController()
                    print(currentCallUUID!)
                    let endCallAction = CXEndCallAction(call: currentCallUUID!)
                    let transaction = CXTransaction(action: endCallAction)
                    cxCallController.request(transaction) { error in
                        if let error = error {
                            print("EndCallAction transaction request failed: \(error.localizedDescription).")
                            provider.reportCall(with: self.currentCallUUID!, endedAt: Date(), reason: .remoteEnded)
                            return
                        }
                        print("EndCallAction transaction request successful")
                    }
                }
            }
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
}

//MARK:- CallKit Delegate
extension AppDelegate: CXProviderDelegate{
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        connectVoiceCall(user_id: currentUserID, chat_id: chat_id) { (success) in
            if success{
                print("connected voice")
                let state = UIApplication.shared.applicationState
                if state == .background || state == .inactive {
                    // background
                    action.fulfill()
                } else if state == .active {
                    // foreground
                    
                    if let controller = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "callvc") as? CallVC {
                        controller.otherUserNickname = self.otherUserName
                        controller.state = .active
                        controller.definesPresentationContext = true
                        controller.modalPresentationStyle = .overCurrentContext
                        if let window = self.window, let rootViewController = window.rootViewController
                        {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController

                            }

                            currentController.present(controller, animated: true, completion: nil)
                        }
                    
                        
                    }
                    
                    
                    
                    action.fulfill()
                    
                }
                
                
                
            }
            else{
                print("call failed to connect")
                action.fail()
            }
        }
        
        
        
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        
        action.fulfill(withDateEnded: Date())
    }
}

//MARK:- Twilio Calls Delegate
extension AppDelegate: RoomDelegate, LocalParticipantDelegate{
    func roomDidFailToConnect(room: Room, error: Error) {
        print("error123 : \(error.localizedDescription)")
        
    }
    
    func roomDidConnect(room: Room) {
        
        //self.configureAudioSessionToEarSpeaker()
        
        self.audioDevice.block = {
            do {
                DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()

                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setMode(.voiceChat)
            } catch let error as NSError {
                print("Fail: \(error.localizedDescription)")
            }
        }

        self.audioDevice.block()
        
        
        if let localParticipant = room.localParticipant {
            print("Local identity \(localParticipant.identity)")

            // Set the delegate of the local particiant to receive callbacks
            localParticipant.delegate = self
        }
        print(room.remoteParticipants.count)
        if room.remoteParticipants.count == 1{
            
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        print("disconnect error: \(error?.localizedDescription)")
        
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("joined: \(participant.identity)")
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        
        room.disconnect()
        
    }
}

//MARK:- Helpers in AppDelegate
extension AppDelegate{
    func voipRegistration() {
            
        // Create a push registry object
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    
    private func connectVoiceCall(user_id: String, chat_id: String, completion: @escaping (Bool)->()){
        TwilioManager.fetchVideoTokenFromAPI(username: user_id, chat_id: chat_id) { (token) in
            if token == "" {
                //disconnect call with error
                completion(false)
            }
            else{
                //create audio/video call room
                
                self.performRoomConnect(uuid: UUID(), token: token, roomName: chat_id) { (success) in
                    print(success)
                    if success{
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                
                }
                
            }
        }
    }
    
    private func performRoomConnect(uuid: UUID, token: String, roomName: String, completionHandler: @escaping (Bool) -> Swift.Void){
        let connectOptions = ConnectOptions(token: token) { (builder) in
            builder.roomName = roomName
            
            
            
            
            let localAudioTrack = LocalAudioTrack()
            let localDataTrack = LocalDataTrack()
            if let audioTrack = localAudioTrack {
                audioTrack.isEnabled = true
                
                builder.audioTracks = [ audioTrack ]
                
            }
            builder.preferredAudioCodecs = [IsacCodec()]

            
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }

            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            if let dataTrack = localDataTrack {
                    builder.dataTracks = [ dataTrack ]
            }
            builder.uuid = uuid
            
            
        }
        
        self.room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        if room != nil{
            completionHandler(true)
        }
        else{
            completionHandler(false)
        }
        
    }
    
}

