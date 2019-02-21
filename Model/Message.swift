//
//  Message.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/5/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

enum MessageSender {
    case ourself
    case someoneElse
}

class Message: NSObject {
    let sender: MessageSender
    let sender_username: String
    let message_content: String
    
    init(sender: MessageSender, sender_username: String, message: String) {
        self.sender = sender
        self.sender_username = sender_username
        self.message_content = message
    }
}
