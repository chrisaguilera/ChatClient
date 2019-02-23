//
//  ChatModel.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/4/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

protocol ChatModelDelegate: class {
    func handleNewUser(usernames: [String])
    func handleChatRequest(username: String)
    func handleBeginChat(username: String)
    func handleNewMessage(message: Message)
}

class ChatModel: NSObject {

    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    var username = ""
    var users: [String] = []
    var friend_username = ""
    
    weak var delegate: ChatModelDelegate?
    
    let maxReadLength = 1024
    
    func setupNetworkCommunication() {
        
        print("Setup Network Communication")
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        // Local IP Address 
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "192.168.0.18" as CFString, 2223, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func joinLobby(username: String) {
        self.username = username
        let data = "joinLobby::\(username)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes{
            outputStream.write($0, maxLength: data.count)
        }
    }
    
    func chatRequestWith(_ friend_username: String) {
        self.friend_username = friend_username
        let data = "chatRequestWith::\(friend_username)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes{
            outputStream.write($0, maxLength: data.count)
        }
    }
    
    func acceptChatRequest(friend_username: String) {
        self.friend_username = friend_username
        let data = "acceptChatRequest::\(friend_username)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes{
            outputStream.write($0, maxLength: data.count)
        }
    }
    
    func sendNewMessage(message: Message) {
        let data = "sendNewMessage::\(username)::\(friend_username)::\(message.message_content)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes{
            outputStream.write($0, maxLength: data.count)
        }
    }
    
    
//    func requestUsers() {
//        let data = "requestUsers::".data(using: .utf8)!
//
//        _ = data.withUnsafeBytes{
//            outputStream.write($0, maxLength: data.count)
//        }
//    }
}

extension ChatModel: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            print("New message received")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            print("New message received - End Encountered")
        case Stream.Event.errorOccurred:
            print("Error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("Has space available")
        default:
            print("Some other event...")
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            
            processMessageFromServer(buffer: buffer, length: numberOfBytesRead)
        }
    }
    
    private func processMessageFromServer(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        
        let stringArray = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?.components(separatedBy: "::")
        
        let messageType = stringArray?[0]
        
        // New User
        if messageType! == "newUser" {
            var usernameArray = stringArray!
            usernameArray.remove(at: 0)
            print("Chat Model -- Users from Array: \(usernameArray)")
            delegate?.handleNewUser(usernames: usernameArray)
        }
        // Chat Request
        else if messageType! == "chatRequestFrom" {
            print("Chat Model -- Chat Request From: \(stringArray![1])")
            delegate?.handleChatRequest(username: stringArray![1])
        }
        // Begin Chat
        else if messageType! == "beginChat" {
            print("Chat Model -- Begin Chat: \(stringArray![1]) and \(stringArray![2])")
            delegate?.handleBeginChat(username: stringArray![1] == friend_username ? stringArray![1] : stringArray![2])
        }
        // New Message
        else if messageType! == "newMessage" {
            print("Chat Model -- New message from \(stringArray![1]): \(stringArray![2])")
            let newMessage = Message(sender: .someoneElse, sender_username: stringArray![1], message: stringArray![2])
            delegate?.handleNewMessage(message: newMessage)
        }
    }
}
