//
//  ChatDetailVC.swift
//  RajaaRani
//

//

import UIKit
import MessageKit
import InputBarAccessoryView
import TwilioChatClient
import Alamofire
import SwiftyJSON
import JGProgressHUD



class ChatDetailVC: MessagesViewController{

    //MARK:- Properties
    
    var messages: [MessageType] = []
    var user: User?
    var sender: SenderType?
    var otherUser: User?
    var currentTwilioUser: TCHMember?
    var otherTwilioUser: TCHMember?

    var twilioToken = ""
    var isConnected = false
    var isSynced = false
    var client: TwilioChatClient?
    var channelList: TCHChannels?
    var currentChannel: TCHChannel?
    var chat_id = ""
    
    var hud: JGProgressHUD?
    
    
    

    
    //MARK:- Outlets
    @IBOutlet weak var header_view: UIView!
    
    @IBOutlet weak var headerSeparator_view: UIView!
    @IBOutlet weak var username_lbl: UILabel!
    
    @IBOutlet weak var phoneIcon: UIImageView!
    
    @IBOutlet weak var videoIcon: UIImageView!
    
    
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    //MARK:- Event Handlers

    @objc func phoneTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView

        self.present(utils.displayDialog(title: "Coming Soon", msg: "This feature is under development and coming very soon"), animated: true, completion: nil)
    }

    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView

        self.present(utils.displayDialog(title: "Coming Soon", msg: "This feature is under development and coming very soon"), animated: true, completion: nil)
    }
    
}

//MARK:- Sender Protocol
public struct Sender: SenderType {
    public let senderId: String

    public let displayName: String
}

//MARK:- Lifecycle
extension ChatDetailVC{
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.sender = Sender(senderId: self.user?._id ?? "", displayName: self.user?.nickname ?? "")
        
        hud = JGProgressHUD(style: .dark)
        hud?.interactionType = .blockAllTouches
        
        self.fetchTokenFromAPI(username: self.user?._id ?? "") { (token) in
            self.twilioToken = token
            print(self.chat_id)
            self.initializeClientWithToken(token: self.twilioToken)
        }
        
//        SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: user?.email ?? "") { (userList) in
//            print(userList?.count)
//        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
//        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
//
//            DispatchQueue.global(qos: .background).async {
//                DispatchQueue.main.async {
//                    let date = messageInfo["date"] as! String
//
//                    let message = Message(id: UUID().uuidString, content: messageInfo["message"] as! String, created: date.convertToTimeInterval(), senderID: "id12", senderName: messageInfo["nickname"] as! String)
//                    self.messages.append(message)
//                    self.messagesCollectionView.reloadData()
//                    self.messagesCollectionView.scrollToBottom(animated: true)
//                }
//            }
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        //QBChat.instance.addDelegate(self)
        
        
        
/*
        
//        loginQuickBlox()
//
//
//        let currentUserHalfID = self.stripUserIDs(id: self.user?._id ?? "")
//
//        if let id = UInt.parse(from: currentUserHalfID) {
//
//
//            QBSettings.autoReconnectEnabled = true
//            QBSettings.reconnectTimerInterval = 5
//            QBSettings.carbonsEnabled = true
//            QBSettings.keepAliveInterval = 20
//            QBSettings.streamManagementSendMessageTimeout = 0
//            QBSettings.networkIndicatorManagerEnabled = false
//
////            let currentUser = QBUUser()
////            currentUser.id = id
////            currentUser.password = self.user?._id ?? ""
//
//            QBRequest.user(withEmail: self.user?.email ?? "") { (response, qbCurrUser) in
//                if response.isSuccess{
//                    self.currentQBUser = qbCurrUser
//                    self.currentQBUser.password = self.user?._id ?? ""
//                    QBRequest.user(withEmail: self.otherUser?.email ?? "") { (resp, qbOtherUser) in
//                        if resp.isSuccess{
//                            self.otherQBUser = qbOtherUser
//                            self.otherQBUser.password = self.otherUser?._id ?? ""
//                            QBChat.instance.connect(withUserID: self.otherQBUser.id, password: self.otherQBUser.password ?? "", completion: { (error) in
//                                if error != nil{
//                                    print("error connecting to chat: \(error)")
//                                }
//                                else{
//
//                                    if self.dialog.occupantIDs?.contains(NSNumber(integerLiteral: Int(self.otherQBUser.id))) ?? false{
//
//                                    }
//                                    else{
//                                        self.dialog.occupantIDs = [NSNumber(integerLiteral: Int(self.otherQBUser.id))]
//                                    }
//
//                                    print(self.dialog.occupantIDs)
//                                    QBRequest.createDialog(self.dialog, successBlock: { (response, createdDialog) in
//                                        if response.isSuccess{
//                                            self.chatDialog = createdDialog
//                                        }
//                                        else{
//                                            print("error creating dialog: \(response)")
//                                        }
//
//                                    }, errorBlock: { (response) in
//                                        print("error init chat: \(response)")
//                                    })
//                                }
//                            })
//
//
//
//
//
//                        }
//                    } errorBlock: { (errResponse) in
//                        print("error fetching other user: \(errResponse)")
//                    }
//
//
//                }
//            } errorBlock: { (err) in
//                print("error fetching user: \(err)")
//            }
//
//
//
//
//            let otherUserHalfID = self.stripUserIDs(id: self.otherUser?._id ?? "")
//
//
//
//
//            if let otherUserID = UInt.parse(from: otherUserHalfID){
//
//            }
//
//
//        }
        
        
        

        
        
//        agora = AgoraRtmKit.init(appId: "c38108fcd58b4d40b01d4d0d9223c87a", delegate: self)
//        agora?.login(byToken: "18ca0a9ff5b14abf84bb2e5d4248089c", user: self.user?.email ?? "", completion: { (errorCode) in
//            if errorCode != AgoraRtmLoginErrorCode.ok{
//                print("login failed \(errorCode) ")
//            }
//            else{
//                print("login success, continue to chat")
//
//            }
//        })
        

        
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "handleConnectedUserUpdateNotification"), object: nil, queue: nil,
//        using: self.handleConnectedUserUpdateNotification)
//
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "handleDisconnectedUserUpdateNotification"), object: nil, queue: nil,
//        using: self.handleDisconnectedUserUpdateNotification)
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("handleConnectedUserUpdateNotification:")), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector(("handleDisconnectedUserUpdateNotification:")), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)  */

    }
    
}

//MARK:- Interface Setup
extension ChatDetailVC{
    func setupInterface(){
        setupMessageVC()
        
        
        setupEventHandlers()
        
        print(isConnected)
        if isConnected{
            
        }
        
//        let message = Message(id: UUID().uuidString, content: "First message text", created: Date().timeIntervalSince1970, senderID: "id12", senderName: "harry")
        
//        self.messagesCollectionView.reloadData()
//        self.messages.append(message)
        
    }
    
    func setupEventHandlers(){
        let phoneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(phoneTapped(tapGestureRecognizer:)))
            phoneIcon.isUserInteractionEnabled = true
            phoneIcon.addGestureRecognizer(phoneTapGestureRecognizer)
        
        let videoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoTapped(tapGestureRecognizer:)))
            videoIcon.isUserInteractionEnabled = true
            videoIcon.addGestureRecognizer(videoTapGestureRecognizer)
    }
    
    func setupMessageVC(){
        
        self.view.addSubview(header_view)
        self.view.addSubview(headerSeparator_view)
        messagesCollectionView.contentInset = UIEdgeInsets(top: self.header_view.frame.height + 12, left: 0.0, bottom: 0.0, right: 0.0)
        messagesCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: self.header_view.frame.height + 12, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
        username_lbl.text = self.otherUser?.nickname ?? ""
    }
}



//MARK:- MessageVC Delegates
extension ChatDetailVC: InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if message.sender.senderId == sender?.senderId{
            return UIColor(red: 98/255, green: 13/255, blue: 135/255, alpha: 1.0)
        }
        else{
            return UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
        }
        
    }
    
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if message.sender.senderId == sender?.senderId{
//            return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//        }
//        return nil
//    }
    
    
    func currentSender() -> SenderType {
        return sender!
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }

    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    private func insertNewMessage(_ message: Message) {
        //add the message to the messages array and reload it
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //When use press send button this method is called.
        print("here")
        
        
        if let msgs = currentChannel?.messages{
            let options = TCHMessageOptions().withBody(text)
            msgs.sendMessage(with: options) { (result, msg) in
                if result.isSuccessful(){
                    let message = Message(id: msg?.sid ?? "", content: text, created: Date().timeIntervalSince1970, senderID: self.user?._id ?? "", senderName: self.user?.nickname ?? "")
                    
                    self.insertNewMessage(message)
                    print(self.messages.count)
                }
                else{
                    print(result.error)
                    self.present(utils.displayDialog(title: "Error", msg: "Something went wrong while sending message"), animated: true, completion: nil)
                }
            }
        }
        
        
        //clearing input field
        inputBar.inputTextView.text = ""
        //messagesCollectionView.reloadData()
        //messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
}



//MARK:- Twilio API Delegates
extension ChatDetailVC: TwilioChatClientDelegate, TCHChannelDelegate{
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        
        
        if status == .all {
            self.channelList = client.channelsList()
            self.isSynced = true
            //self.joinChannel()
        }
        else if status == .identifier{
            print("identifier: \(status.rawValue)")
            self.channelList = client.channelsList()
            self.isSynced = true
            //self.joinChannel()
        }
        else if status == .metadata{
            print("metadata: \(status.rawValue)")
            self.channelList = client.channelsList()
            self.isSynced = true
            self.joinChannel()
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
    
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        if channel.status == .invited{
            if channel.sid == self.chat_id{
                channel.join { (result) in
                    if result.isSuccessful(){
                        print("joined invited channel")
                    }
                    else{
                        self.present(utils.displayDialog(title: "Error", msg: "Something went wrong while accepting invite to channel"), animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        let msg = Message(id: message.sid ?? "", content: message.body ?? "", created: message.dateCreatedAsDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, senderID: self.otherUser?._id ?? "", senderName: self.otherUser?.nickname ?? "")
        
        if message.author == self.otherUser?._id ?? ""{
            messages.append(msg)
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
        
        
    }
    
    
    
}

//MARK:- Helpers
extension ChatDetailVC{
        
    func joinChannel(){
        client?.channelsList()?.channel(withSidOrUniqueName: self.currentChannel?.sid ?? "", completion: { (result, joinedChannel) in
            print(result.error)
            if result.isSuccessful(){
                
                if joinedChannel?.status != .joined{
                    joinedChannel?.join(completion: { (result) in
                        if result.isSuccessful(){
                            self.hud?.dismiss()
                            print("joined: \(joinedChannel?.members?.membersList().count)")
                            if joinedChannel?.members?.membersList().count ?? 0 > 0 && joinedChannel?.members?.membersList().count ?? 0 < 2{
                                print("able to join another")
                                
                                joinedChannel?.members?.invite(byIdentity: self.otherUser?._id ?? "", completion: { (res) in
                                    if res.isSuccessful(){
                                        print("invited user: \(self.otherUser?.email ?? "")")
                                    }
                                    else{
                                        self.present(utils.displayDialog(title: "Error", msg: "Something went wrong while joining channel"), animated: true, completion: nil)
                                    }
                                })
                            }
                        }
                        else{
                            print("error joining channel: \(result.error)")
                        }
                    })
                }
            }
            else{
                self.present(utils.displayDialog(title: "Error", msg: "Something went wrong while joining channel"), animated: true, completion: nil)
            }
        })
    }
    
    func setupChatChannel(completion: @escaping (TCHChannel)->()){
        
        var currChannel: TCHChannel?
        var isFound = false
        
        client?.channelsList()?.userChannelDescriptors(completion: { (result, paginator) in
            if result.isSuccessful(){
                
                let myGroup = DispatchGroup()
                myGroup.enter()
                    //// Do your task

                for page in paginator?.items() ?? [TCHChannelDescriptor](){
                    print("fetching...")
                    if page.friendlyName == self.chat_id{
                        //channel already exists
                        isFound = true
                        page.channel { (res, channel) in
                            if res.isSuccessful(){
                                
                                
//                                channel?.destroy(completion: { (result) in
//                                    if result.isSuccessful(){
//                                        print("deleting")
//                                    }
//                                    else{
//                                        print("error deleting channels")
//                                    }
//                                })
                                self.hud?.dismiss()
                                print("existing channel fetched")
                                currChannel = channel ?? TCHChannel()
                                completion(currChannel!)
                                
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.present(utils.displayDialog(title: "Error", msg: "Error fetching an existing channel"), animated: true, completion: nil)
                                }
                                    
                            }
                            
                        }
                        //join a channel
                        
                    }
                }
                
                
                myGroup.leave() //// When your task completes
                myGroup.notify(queue: DispatchQueue.main) {

                    // do your remaining work
                    
                    if isFound == false{
                        //create new channel
                        print("in channel ")
                        let options = [
                            TCHChannelOptionFriendlyName: self.chat_id,
                            TCHChannelOptionType: TCHChannelType.private.rawValue
                        ] as [String : Any]
                        self.client?.channelsList()?.createChannel(options: options, completion: { channelResult, channel in
                            if (channelResult.isSuccessful()) {
                                print("channel created")
                                self.hud?.dismiss()
                                currChannel = channel ?? TCHChannel()
                                completion(currChannel!)

                            } else {
                                self.present(utils.displayDialog(title: "Oops", msg: "Error Creating a chat channel"), animated: true, completion: nil)
                            }
                        })
                    }
                    
                }
                
                
                
                
                
                
                
            }
            else{
                self.present(utils.displayDialog(title: "Error", msg: "Error fetching channels list"), animated: true, completion: nil)
            }
        })
    }
    
    func stripUserIDs(id: String)->String{
        
        
        var count = 0
        var halfID = ""
        for val in id{
            if count == id.count / 2{
                break
            }
            else{
                halfID = halfID + String(val)
            }
            count = count + 1
        }
        
        return halfID
    }

    func fetchTokenFromAPI(username: String, completion: @escaping (String)->()){
        self.hud?.show(in: self.view)
        let params = ["username": username]
        AF.request(config.getTwilioTokenURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            let responseCode = response.response?.statusCode ?? 0
            
            let result = JSON(response.value)
            print(response)
            if responseCode >= 400 && responseCode <= 499{
                self.present(utils.displayDialog(title: "Oops", msg: "Something went wrong while fetching Chat token"), animated: true, completion: nil)
            }
            else{
                let token = result.stringValue
                completion(token)
            }
        }
    }
    
    func initializeClientWithToken(token: String){
        print("here: \(self.twilioToken)")
        TwilioChatClient.setLogLevel(.critical)
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { result, chatClient in
            print(chatClient)
            guard (result.isSuccessful()) else {
                print(result)
                return
            }
            print("here")
            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.isConnected = true
            self.client = chatClient
        
            
            self.setupChatChannel { (channel) in
                self.currentChannel = channel
            }
        }
    }
    
    func populateChannelDescriptors(){
        
        channelList?.userChannelDescriptors(completion: { (result, paginator) in
            if result.isSuccessful(){
                
            }
            else{
                
            }
            
            guard let paginator = paginator else {
                return
            }
            
            let newChannelDescriptors = NSMutableOrderedSet()
            newChannelDescriptors.addObjects(from: paginator.items())
            self.channelList?.channel(withSidOrUniqueName: self.user?._id ?? "", completion: { (res, channel) in
                if res.isSuccessful(){
                    
                }
                else{
                    print("No channel exists with this name: \(res)")
                }
            })
            
            
            //..
            self.channelList?.publicChannelDescriptors(completion: { (result, paginator) in
                guard let paginator = paginator else { return }
                
                // de-dupe channel list
               let channelIds = NSMutableSet()
               for descriptor in newChannelDescriptors {
                   if let descriptor = descriptor as? TCHChannelDescriptor {
                       if let sid = descriptor.sid {
                           channelIds.add(sid)
                       }
                   }
               }
               for descriptor in paginator.items() {
                   if let sid = descriptor.sid {
                       if !channelIds.contains(sid) {
                           channelIds.add(sid)
                           newChannelDescriptors.add(descriptor)
                       }
                   }
               }
               
               
               // sort the descriptors
//               let sortSelector = #selector(NSString.localizedCaseInsensitiveCompare(_:))
//               let descriptor = NSSortDescriptor(key: "friendlyName", ascending: true, selector: sortSelector)
//               newChannelDescriptors.sort(using: [descriptor])
                
               //self.channelDescriptors = newChannelDescriptors
               
//               if let delegate = self.delegate {
//                   delegate.reloadChannelDescriptorList()
//               }
                           
            })
        })
    }
    
    func createChannelWithName(name: String, completion: @escaping (Bool, TCHChannel?) -> Void) {
        if (name == ChannelManager.defaultChannelName) {
            completion(false, nil)
            return
        }
        
        let channelOptions = [
            TCHChannelOptionFriendlyName: name,
            TCHChannelOptionType: TCHChannelType.private.rawValue
            
        ] as [String : Any]
        
        self.channelList?.createChannel(options: channelOptions) { result, channel in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion((result.isSuccessful()), channel)
        }
    }
}
