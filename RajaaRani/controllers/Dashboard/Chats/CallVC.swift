//
//  CallVC.swift
//  RajaaRani
//

//

import UIKit
import TwilioVideo
import CallKit
import AVFoundation
import Hero

class CallVC: UIViewController {

    //MARK:- Properties
    var user: User?
    var chat_id: String = ""
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    
    var callKitProvider: CXProvider?
    var callKitCallController: CXCallController?
    var videoToken: String = ""
    var room: Room?
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var status_lbl: UILabel!
    
    @IBOutlet weak var username_lbl: UILabel!
    
    @IBOutlet weak var endBtn: UIButton!
    
    //MARK:- Actions
    
    @IBAction func backTapped(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        
        self.room?.disconnect()
        self.hero.dismissViewController()
    }
    
    @IBAction func speakerTapped(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func muteTapped(_ sender: UIButton) {
        
        
    }
    
    
    
    
    //MARK:- Event Handlers
    

}

//MARK:- Lifecycle
extension CallVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.configureAudioSessionToEarSpeaker()
        do { ///Audio Session: Set on Speaker
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            try AVAudioSession.sharedInstance().setActive(true)

            print("Successfully configured audio session (EAR-Speaker).", "\nCurrent audio route: ",AVAudioSession.sharedInstance().currentRoute.outputs)
        }
        catch{
            print("#configureAudioSessionToEarSpeaker Error \(error.localizedDescription)")
        }
        
        self.audioDevice = DefaultAudioDevice()
        audioDevice.isEnabled = true
        TwilioVideoSDK.audioDevice = audioDevice
        
        
        
        self.setupInterface()
        //TwilioVideoSDK.setLogLevel(.debug)
        self.setupCallKit()
        
        self.navigationController?.hero.navigationAnimationType = .fade
        self.navigationController?.hero.isEnabled = true
        
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        
    }
    
    
    
}

//MARK:- Interface Setup
extension CallVC{
    
    func setupCallKit(){
        let configuration = CXProviderConfiguration(localizedName: "CallKit Quickstart")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = false
        configuration.supportedHandleTypes = [.generic]
        if let callKitIcon = UIImage(named: "iconMask80") {
            configuration.iconTemplateImageData = callKitIcon.pngData()
        }

        callKitProvider = CXProvider(configuration: configuration)
        callKitCallController = CXCallController()
        
        if let callKitProvider = callKitProvider {
            callKitProvider.setDelegate(self, queue: nil)
        }
        
        
        
    }
    func setupInterface(){
        
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        imgView.clipsToBounds = true
        
        endBtn.layer.cornerRadius = endBtn.frame.size.width/2
        endBtn.clipsToBounds = true
        
        TwilioManager.fetchVideoTokenFromAPI(username: self.user?._id ?? "", chat_id: chat_id) { (token) in
            if token == "" {
                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio Video token"), animated: true, completion: nil)
            }
            else{
                //create audio/video call room
                self.videoToken = token
                self.status_lbl.text = "ringing"
                self.performStartCallAction(uuid: UUID(), roomName: self.chat_id)
                
                
            }
        }
    }
}

//MARK:- TwilioVideo Room Delegate
extension CallVC: RoomDelegate, LocalParticipantDelegate{
    func roomDidFailToConnect(room: Room, error: Error) {
        print("error123 : \(error.localizedDescription)")
        self.status_lbl.text = "call failed"
    }
    
    func roomDidConnect(room: Room) {
        
        //self.configureAudioSessionToEarSpeaker()
        
        if let localParticipant = room.localParticipant {
            print("Local identity \(localParticipant.identity)")

            // Set the delegate of the local particiant to receive callbacks
            localParticipant.delegate = self
        }
        print(room.remoteParticipants.count)
        if room.remoteParticipants.count == 1{
            self.status_lbl.text = "connected"
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        print("disconnect error: \(error?.localizedDescription)")
        
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("joined: \(participant.identity)")
        self.status_lbl.text = "connected"
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        
        room.disconnect()
        self.hero.dismissViewController()
    }
    
    
    
}

//MARK:- CallKit Delegate
extension CallVC: CXProviderDelegate{
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        
        if let callKitProvider = callKitProvider{
            callKitProvider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
        }
    
        performRoomConnect(uuid: action.callUUID, roomName: action.handle.value) { (success) in
            if (success) {
                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
                action.fulfill()
            } else {
                action.fail()
            }
        }
    }
    
    
}

//MARK:- Helpers
extension CallVC{
    func performRoomConnect(uuid: UUID, roomName: String? , completionHandler: @escaping (Bool) -> Swift.Void){
        let connectOptions = ConnectOptions(token: videoToken) { (builder) in
            builder.roomName = self.chat_id
            
            
            
            
            var localAudioTrack = LocalAudioTrack()
            var localDataTrack = LocalDataTrack()
            if let audioTrack = localAudioTrack {
                audioTrack.isEnabled = true
                
                builder.audioTracks = [ audioTrack ]
                
            }
            builder.preferredAudioCodecs = [IsacCodec()]
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//
//            }
            
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
        self.checkRecordPermission { (permissionGranted) in
                if (!permissionGranted) {
                    let alertController: UIAlertController = UIAlertController(title: "Voice Quick Start",
                                                                               message: "Microphone permission not granted",
                                                                               preferredStyle: .alert)

                    let continueWithMic: UIAlertAction = UIAlertAction(title: "Continue without microphone",
                                                                       style: .default,
                                                                       handler: { (action) in
                                                                        self.room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
                                                                        completionHandler(true)
                                                                        
                    })
                    alertController.addAction(continueWithMic)

                    let goToSettings: UIAlertAction = UIAlertAction(title: "Settings",
                                                                    style: .default,
                                                                    handler: { (action) in
                                                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                                  options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
                                                                                                  completionHandler: nil)
                                                                        completionHandler(false)
                    })
                    alertController.addAction(goToSettings)

                    let cancel: UIAlertAction = UIAlertAction(title: "Cancel",
                                                              style: .cancel,
                                                              handler: { (action) in
                                                                
                    })
                    alertController.addAction(cancel)

                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
                    completionHandler(true)
                }
            }
        
        
    }
    
    func performStartCallAction(uuid: UUID, roomName: String?) {
        let callHandle = CXHandle(type: .generic, value: roomName ?? "")
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        
        startCallAction.isVideo = true
        
        let transaction = CXTransaction(action: startCallAction)
        
        callKitCallController?.request(transaction)  { error in
            if let error = error {
                
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            self.performRoomConnect(uuid: uuid, roomName: roomName) { (success) in
                print(success)
                if success{
                    
//                    provider.reportOutgoingCall(with: startCallAction.callUUID, connectedAt: Date())
                    startCallAction.fulfill()
                }
                
            }
            NSLog("StartCallAction transaction request successful")
        }
    }
    
    
    
    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        let permissionStatus: AVAudioSession.RecordPermission = AVAudioSession.sharedInstance().recordPermission

        switch permissionStatus {
        case AVAudioSessionRecordPermission.granted:
            // Record permission already granted.
            completion(true)
            break
        case AVAudioSessionRecordPermission.denied:
            // Record permission denied.
            completion(false)
            break
        case AVAudioSessionRecordPermission.undetermined:
            // Requesting record permission.
            // Optional: pop up app dialog to let the users know if they want to request.
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                completion(granted)
            })
            break
        default:
            completion(false)
            break
        }
    }
    
    
    func configureAudioSessionToEarSpeaker(){

        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        do { ///Audio Session: Set on Speaker
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            try audioSession.setActive(true)

            print("Successfully configured audio session (EAR-Speaker).", "\nCurrent audio route: ",audioSession.currentRoute.outputs)
        }
        catch{
            print("#configureAudioSessionToEarSpeaker Error \(error.localizedDescription)")
        }
    }
}
