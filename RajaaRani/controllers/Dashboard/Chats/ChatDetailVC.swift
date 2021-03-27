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
import TwilioVideo
import Hero


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
    
    var twilioObj: TwilioClient = TwilioClient()
    var hud: JGProgressHUD?
    
    
    
    

    
    //MARK:- Outlets
    @IBOutlet weak var header_view: UIView!
    
    @IBOutlet weak var headerSeparator_view: UIView!
    @IBOutlet weak var username_lbl: UILabel!
    
    @IBOutlet weak var phoneIcon: UIImageView!
    
    @IBOutlet weak var videoIcon: UIImageView!
    
    
    //MARK:- Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
  
    //MARK:- Event Handlers

    @objc func phoneTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView

//        self.present(utils.displayDialog(title: "Coming Soon", msg: "This feature is under development and coming very soon"), animated: true, completion: nil)
        performSegue(withIdentifier: "goToCall", sender: self)
        
    }

    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView

//        self.present(utils.displayDialog(title: "Coming Soon", msg: "This feature is under development and coming very soon"), animated: true, completion: nil)
        
        performSegue(withIdentifier: "goToVideo", sender: self)
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
        
//        self.fetchTokenFromAPI(username: self.user?._id ?? "") { (token) in
//            self.twilioToken = token
//            print(self.chat_id)
//            self.initializeClientWithToken(token: self.twilioToken)
//        }

        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
        
        self.twilioObj.client?.delegate = self
        
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .fade
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        
        
        
        
        
        
        if currentChannel == nil{
            //create a channel here
            print("channel is still empty")
//            let options = [
//                TCHChannelOptionFriendlyName: self.chat_id,
//                TCHChannelOptionType: TCHChannelType.private.rawValue
//            ] as [String : Any]
//            self.twilioObj.client?.channelsList()?.createChannel(options: options, completion: { channelResult, channel in
//                if (channelResult.isSuccessful()) {
//                    print("channel created")
//                    self.hud?.dismiss()
//                    self.currentChannel = channel
//
//                    self.currentChannel?.join(completion: { (result) in
//                        if result.isSuccessful(){
//                            self.currentChannel?.members?.add(byIdentity: self.otherUser?._id ?? "", completion: { (joinResult) in
//                                if joinResult.isSuccessful(){
//                                    print("both users added")
//                                }
//                                else{
//                                    print(joinResult.error)
//                                    self.present(utils.displayDialog(title: "Oops", msg: "Error adding member to chat channel"), animated: true, completion: nil)
//                                }
//                            })
//                        }
//                        else{
//                            print(result.error)
//                            self.present(utils.displayDialog(title: "Oops", msg: "Error joining a chat channel"), animated: true, completion: nil)
//                        }
//                    })
//
//
//
//                } else {
//                    self.present(utils.displayDialog(title: "Oops", msg: "Error Creating a chat channel"), animated: true, completion: nil)
//                }
//            })
        }
        
        
//        if let currentChannel = self.currentChannel{
//            //let members = currentChannel.members?.membersList()
//            let dispatchGroup = DispatchGroup()
//            for members in currentChannel.members?.membersList() ?? []{
//                if members.identity != self.user?._id ?? "" {
//                    dispatchGroup.enter()
//                    currentChannel.join { (result) in
//                        if result.isSuccessful(){
//                            print("joined current channel")
//                            dispatchGroup.leave()
//                        }
//                        else{
//                            print(result.error)
//                            self.present(utils.displayDialog(title: "Twilio Chat Error", msg: "An error occurred while joining current chat channel"), animated: true, completion: nil)
//                            dispatchGroup.leave()
//                        }
//                    }
//                    break
//                }
//            }
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCall"{
            let destVC = segue.destination as! CallVC
            destVC.user = self.user
            destVC.otherUser = self.otherUser
            destVC.chat_id = self.chat_id
        }
        
        if segue.identifier == "goToVideo"{
            let destVC = segue.destination as! VideoVC
            destVC.user = self.user
            destVC.chat_id = self.chat_id
        }
    }
    
}

//MARK:- Interface Setup
extension ChatDetailVC{
    func setupInterface(){
        setupMessageVC()
        
        
        self.currentChannel?.messages?.getLastWithCount(100, completion: { (result, items) in
            if result.isSuccessful(){
                if let items = items{
                    if items.count != 0{
                        for message in items{
                            
                            if message.author ?? "" == self.user?._id ?? ""{
                                let msgType = Message(id: message.sid ?? "", content: message.body ?? "", created: message.dateCreatedAsDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, senderID: message.author ?? "", senderName: self.user?._id ?? "")
                                
                                self.messages.append(msgType)
                                
                            }
                            else if message.author ?? "" == self.otherUser?._id ?? ""{
                                let msgType = Message(id: message.sid ?? "", content: message.body ?? "", created: message.dateCreatedAsDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, senderID: message.author ?? "", senderName: self.otherUser?._id ?? "")
                                self.messages.append(msgType)
                                
                            }
                            
                        }
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom(animated: true)
                    }
                }
            }
            else{
                self.present(utils.displayDialog(title: "Oops", msg: "Failed to load chat previous messages"), animated: true, completion: nil)
            }
        })
        
        setupEventHandlers()
        
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
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        let currentText: String = inputBar.inputTextView.text
        currentChannel?.typing()
    }
    
}





//MARK:- Twilio Chat Delegates
extension ChatDetailVC: TwilioChatClientDelegate, TCHChannelDelegate{
//    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
//
//
//        if status == .all {
//            self.channelList = client.channelsList()
//            self.isSynced = true
//            //self.joinChannel()
//        }
//        else if status == .identifier{
//            print("identifier: \(status.rawValue)")
//            self.channelList = client.channelsList()
//            self.isSynced = true
//            //self.joinChannel()
//        }
//        else if status == .metadata{
//            print("metadata: \(status.rawValue)")
//            self.channelList = client.channelsList()
//            self.isSynced = true
//            self.joinChannel()
//        }
//        else if status == .failed{
//            print("failed: \(status.rawValue)")
//        }
//        else if status == .none{
//            print("none: \(status.rawValue)")
//        }
//        else{
//            print("error syncing \(status.rawValue)")
//        }
//    }
//
//    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
//        if channel.status == .invited{
//            if channel.sid == self.chat_id{
//                channel.join { (result) in
//                    if result.isSuccessful(){
//                        print("joined invited channel")
//                    }
//                    else{
//                        self.present(utils.displayDialog(title: "Error", msg: "Something went wrong while accepting invite to channel"), animated: true, completion: nil)
//                    }
//                }
//            }
//
//        }
//    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        
        setTypingIndicatorViewHidden(true, animated: true)
        
        let msg = Message(id: message.sid ?? "", content: message.body ?? "", created: message.dateCreatedAsDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, senderID: self.otherUser?._id ?? "", senderName: self.otherUser?.nickname ?? "")
        
        if message.author == self.otherUser?._id ?? ""{
            messages.append(msg)
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func chatClient(_ client: TwilioChatClient, typingStartedOn channel: TCHChannel, member: TCHMember) {
        print("typing")
        messagesCollectionView.scrollToBottom(animated: true)
        setTypingIndicatorViewHidden(false, animated: true)
    }
    func chatClient(_ client: TwilioChatClient, typingEndedOn channel: TCHChannel, member: TCHMember) {
        print("typing ended")
        
        setTypingIndicatorViewHidden(true, animated: true)
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}

//MARK:- Helpers
extension ChatDetailVC{
    
    
    func joinChatChannel(){
        
    }
    
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
