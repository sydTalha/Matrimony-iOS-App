//
//  TwilioClient.swift
//  RajaaRani
//

//

import Foundation
import TwilioChatClient

class TwilioClient{
    var client: TwilioChatClient? = nil
    var channelList: [TCHChannel] = [TCHChannel]()
    var channelDescriptors: [TCHChannelDescriptor] = [TCHChannelDescriptor]()
}
