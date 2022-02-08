//
//  VideoVC.swift
//  RajaaRani
//

//

import UIKit
import TwilioVideo
import AVFoundation
import CallKit
import Hero

class VideoVC: UIViewController {

    //MARK:- Properties
    var user: User?
    var chat_id: String = ""
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    
    var callKitProvider: CXProvider?
    var callKitCallController: CXCallController?
    var videoToken: String = ""
    var room: Room?
    
    
    var remoteView: VideoView?
    
    //MARK:- Outlets
    
    @IBOutlet weak var localVideoView: VideoView!
    
    @IBOutlet weak var endBtn: UIButton!
    
    @IBOutlet weak var videoOffBtn: UIButton!
    
    @IBOutlet weak var muteBtn: UIButton!
    //MARK:- Actions
    
    @IBAction func muteTapped(_ sender: UIButton) {
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)

         
        
        if localAudioTrack?.isEnabled ?? false{
            localAudioTrack?.isEnabled = false
            
            let largeBoldDoc = UIImage(systemName: "mic.slash", withConfiguration: largeConfig)
            UIView.transition(with: self.muteBtn,
                              duration: 0.3,
                              options: .curveEaseInOut,
               animations: { [weak self] in
                self?.muteBtn.setImage(largeBoldDoc, for: .normal)
            }, completion: nil)
            
           
            
        }
        else{
            localAudioTrack?.isEnabled = true
            let largeBoldDoc = UIImage(systemName: "mic", withConfiguration: largeConfig)
            UIView.transition(with: self.muteBtn,
                              duration: 0.3,
                              options: .curveEaseInOut,
               animations: { [weak self] in
                self?.muteBtn.setImage(largeBoldDoc, for: .normal)
            }, completion: nil)
        }
    }
    
    @IBAction func endBtnTapped(_ sender: UIButton) {
        
        self.disconnect()
        
    }
    
    @IBAction func videoOffBtnTapped(_ sender: UIButton) {
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        if localVideoTrack?.isEnabled ?? false{
            localVideoTrack?.isEnabled = false
            
            let largeBoldDoc = UIImage(systemName: "video.slash", withConfiguration: largeConfig)
            UIView.transition(with: self.videoOffBtn,
                              duration: 0.3,
                              options: .curveEaseInOut,
               animations: { [weak self] in
                self?.videoOffBtn.setImage(largeBoldDoc, for: .normal)
            }, completion: nil)
        }
        else{
            localVideoTrack?.isEnabled = true
            
            let largeBoldDoc = UIImage(systemName: "video", withConfiguration: largeConfig)
            UIView.transition(with: self.videoOffBtn,
                              duration: 0.3,
                              options: .curveEaseInOut,
               animations: { [weak self] in
                self?.videoOffBtn.setImage(largeBoldDoc, for: .normal)
            }, completion: nil)
        }
    }
    
    @IBAction func flipCameraTapped(_ sender: Any) {
        
    }
    
}

//MARK:- Lifecycle
extension VideoVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioDevice = DefaultAudioDevice()
        audioDevice.isEnabled = true
        TwilioVideoSDK.audioDevice = audioDevice
        //TwilioVideoSDK.setLogLevel(.debug)
        
        LocalNetworkPrivacyPolicy.allowAll
        
        self.navigationController?.hero.navigationAnimationType = .fade
        self.navigationController?.hero.isEnabled = true
        
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        
        
        
        if PlatformUtils.isSimulator {
            self.localVideoView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        
        self.setupInterface()
        self.setupCallKit()
        
    }
}

//MARK:- Interface Setup
extension VideoVC{
    func setupInterface(){
        
        endBtn.layer.cornerRadius = endBtn.frame.size.width/2
        endBtn.clipsToBounds = true
        
        muteBtn.layer.cornerRadius = muteBtn.frame.size.width/2
        muteBtn.clipsToBounds = true
        
        videoOffBtn.layer.cornerRadius = videoOffBtn.frame.size.width/2
        videoOffBtn.clipsToBounds = true
        
        
        TwilioManager.fetchVideoTokenFromAPI(username: self.user?._id ?? "", chat_id: chat_id) { (token) in
            if token == "" {
                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Twilio Video token"), animated: true, completion: nil)
            }
            else{
                //create audio/video call room
                self.videoToken = token
                
                self.performStartCallAction(uuid: UUID(), roomName: self.chat_id)
                
                
            }
        }
        
        
    }
    
    
    func setupCallKit(){
        let configuration = CXProviderConfiguration(localizedName: "CallKit Quickstart")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
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
}

//MARK:- CallKit Delegate
extension VideoVC: CXProviderDelegate{
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func performRoomConnect(uuid: UUID, roomName: String? , completionHandler: @escaping (Bool) -> Swift.Void){
        let connectOptions = ConnectOptions(token: videoToken){ (builder) in
            
            builder.roomName = self.chat_id
            
            
            self.localAudioTrack = LocalAudioTrack()
            
            let localDataTrack = LocalDataTrack()
            
            
            if let audioTrack = self.localAudioTrack{
                audioTrack.isEnabled = true
                
                builder.audioTracks = [audioTrack]
            }
            
            
            
            builder.preferredAudioCodecs = [IsacCodec()]
            builder.preferredVideoCodecs = [Vp8Codec()]
            
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
            
            if let videoTrack = self.localVideoTrack{
                videoTrack.isEnabled = true
                builder.videoTracks = [videoTrack]
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
    
    
}


//MARK:- TwilioVideo Room Delegate
extension VideoVC: RoomDelegate, LocalParticipantDelegate{
    func roomDidFailToConnect(room: Room, error: Error) {
        print("error123 : \(error.localizedDescription)")
        //self.status_lbl.text = "call failed"
    }
    
    func roomDidConnect(room: Room) {
        if let localParticipant = room.localParticipant {
                print("Local identity \(localParticipant.identity)")

                // Set the delegate of the local particiant to receive callbacks
                localParticipant.delegate = self
            }
        print(room.remoteParticipants.count)
        if room.remoteParticipants.count == 1{
            //self.status_lbl.text = "connected"
        }
        
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        print("disconnect error: \(error?.localizedDescription)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        print("joined: \(participant.identity)")
        //self.status_lbl.text = "connected"
        participant.delegate = self
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print("call disconnected")
        
        self.disconnect()
        
    }
    
    
}


//MARK:- Remote Particiapant Delegate
extension VideoVC: RemoteParticipantDelegate{
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
    
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        print("connected to video: \(remoteParticipant?.identity)")
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        print("connected to audio")
    }
    
}


//MARK:- Helpers
extension VideoVC{
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }

        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.localVideoView)
            localVideoView.contentMode = .scaleAspectFill
            print("Video track created")

//            if (frontCamera != nil && backCamera != nil) {
//                // We will flip camera on tap.
//                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.flipCamera))
//                self.previewView.addGestureRecognizer(tap)
//            }

            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    print("error occurred: \(error.localizedDescription)")
                } else {
                    self.localVideoView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            print("No front or back capture device found!")
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
        case AVAudioSession.RecordPermission.granted:
            // Record permission already granted.
            completion(true)
            break
        case AVAudioSession.RecordPermission.denied:
            // Record permission denied.
            completion(false)
            break
        case AVAudioSession.RecordPermission.undetermined:
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
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)

        self.view.insertSubview(self.remoteView!, at: 0)
        
        // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `VideoView` programmatically.
        self.remoteView!.contentMode = .scaleAspectFill
        //self.view.addSubview(self.remoteView!)
        
        
        let centerX = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView!,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.view,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.view.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView!,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.view,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.view.addConstraint(height)	
        
    }
    
    
    func disconnect(){
        self.localVideoTrack?.isEnabled = false
        self.localAudioTrack?.isEnabled = false
        
        
        self.camera?.stopCapture()
        
        
        self.room?.disconnect()
        self.hero.dismissViewController()
    }
}

//MARK:- CameraSource Delegate
extension VideoVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        print("Camera source failed with error: \(error.localizedDescription)")
    }
}

//MARK:- VideoView Delegate
extension VideoVC: VideoViewDelegate{
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}
