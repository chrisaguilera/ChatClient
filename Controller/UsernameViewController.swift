//
//  UsernameViewController.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/5/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    let chatModel = ChatModel()
    
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatModel.setupNetworkCommunication()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        username = textField.text ?? "Default User"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination.isKind(of: ChatLobbyViewController.self) {
            
            print("Segue to ChatLobbyViewController")
            
            let clvc = segue.destination as! ChatLobbyViewController
            clvc.username = username
            clvc.chatModel = chatModel
        }
    }

}
