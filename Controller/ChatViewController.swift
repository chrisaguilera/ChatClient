//
//  ChatViewController.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/19/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let tableView = UITableView()
    let messageInputView = MessageInputView()
    
    var messages = [Message]()
    
    var chatModel: ChatModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Load subviews
        loadViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatModel!.delegate = self
    }
    
    // Adjust tableview and message input view when keyboard is used
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let messageInputViewHeight = self.messageInputView.bounds.height
            let point = CGPoint(x: self.messageInputView.center.x, y: endFrame.origin.y - messageInputViewHeight/2.0)
            
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height, right: 0)
            
            UIView.animate(withDuration: 0.25) {
                self.messageInputView.center = point
                self.tableView.contentInset = inset
            }
        }
        
    }
    
    // Load subviews
    func loadViews() {
        
        if let friendUsername = chatModel?.friend_username {
            navigationItem.title = (friendUsername == "" ? "User" : friendUsername)
        }
        view.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        messageInputView.delegate = self
        
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        view.addSubview(messageInputView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let messageInputViewHeight: CGFloat = 100.0
        let size = view.bounds.size
        tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height - messageInputViewHeight)
        messageInputView.frame = CGRect(x: 0, y: size.height - messageInputViewHeight, width: size.width, height: messageInputViewHeight)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = MessageTableViewCell(style: .default, reuseIdentifier: "Default Cell")
        messageCell.selectionStyle = .none
        
        let message = messages[indexPath.row]
        messageCell.apply(message: message)
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = MessageTableViewCell.height(for: messages[indexPath.row])
        return height
    }
    
    // Insert a new cell
    func insertNewMessage(message: Message) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

extension ChatViewController: ChatModelDelegate {
    
    func handleNewUser(usernames: [String]) {
        
    }
    
    func handleChatRequest(username: String) {
    
    }
    
    func handleBeginChat(username: String) {
    
    }
    
    func handleNewMessage(message: Message) {
        insertNewMessage(message: message)
    }
    
    
}

extension ChatViewController: MessageInputViewDelegate {

    // Add message to messages
    func sendWasTapped(message: String) {
        if let username = chatModel?.username {
            let newMessage = Message(sender: .ourself, sender_username: username, message: message)
            insertNewMessage(message: newMessage)
            print("Sending message: \(newMessage.message_content)")
            chatModel?.sendNewMessage(message: newMessage)
        }
    }
    
}
