//
//  ChatLobbyViewController.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/4/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

class ChatLobbyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var username = ""
    
    var chatModel:ChatModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "Chat Lobby"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        chatModel?.joinLobby(username: username)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatModel!.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension ChatLobbyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatModel!.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default Cell", for: indexPath) as! UserTableViewCell
        let username = chatModel!.users[indexPath.section]
        cell.usernameLabel.text = username
        return cell
    }


}

extension ChatLobbyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Index Path Section: \(indexPath.section)")
        
        // Send chat request
        let friend = chatModel?.users[indexPath.section]
        print("Requested chat with: \(friend!)")
        chatModel?.chatRequestWith(friend!)
    }

}

extension ChatLobbyViewController: ChatModelDelegate {

    func handleNewUser(usernames: [String]) {
        chatModel!.users = usernames
        print("Users: \(chatModel!.users)")
        
        tableView.reloadData()
    }
    
    func handleChatRequest(username: String) {
        let alert = UIAlertController(title: "New Chat Request", message: "You have a new chat request from \(username). Would you like to accept?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (UIAlertAction) in
            print("Accept")
            self.chatModel?.acceptChatRequest(friend_username: username)
        }))
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { (UIAlertAction) in
            print("Decline")
        }))
        self.present(alert, animated: true)
    }
    
    func handleBeginChat(username: String) {
        let chatViewController = ChatViewController()
        chatViewController.chatModel = chatModel
        navigationController?.show(chatViewController, sender: true)
    }
    
    func handleNewMessage(message: Message) {
        
    }
    
}

