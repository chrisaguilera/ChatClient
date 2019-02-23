//
//  MessageTableViewCell.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/19/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var message_sender: MessageSender = .ourself
    let nameLabel = UILabel()
    let messageLabel = MessageLabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func apply(message: Message) {
        message_sender = message.sender
        nameLabel.text = message.sender_username
        messageLabel.text = message.message_content
        setNeedsLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: "Helvetica", size: 10) //UIFont.systemFont(ofSize: 10)
        
        clipsToBounds = true
        
        addSubview(messageLabel)
        addSubview(nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageLabel.textColor = .white
        
        let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude))
        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        
        if message_sender == .ourself {
            nameLabel.isHidden = true
            
            messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 16, y: bounds.size.height/2.0)
            messageLabel.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
        } else {
            nameLabel.isHidden = true
//            nameLabel.sizeToFit()
//            nameLabel.center = CGPoint(x: nameLabel.bounds.size.width/2.0 + 16 + 4, y: nameLabel.bounds.size.height/2.0 + 4)
            
            messageLabel.center = CGPoint(x: messageLabel.bounds.size.width/2.0 + 16, y: bounds.size.height/2.0)
            messageLabel.backgroundColor = .lightGray
        }
        
        messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height/2.0, 20)
        
    }
    
    class func height(for message: Message) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = CGFloat(integerLiteral: 0)
        let messageHeight = height(forText: message.message_content, fontSize: 17, maxSize: maxSize)
        
        return nameHeight + messageHeight + 32 + 16
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
