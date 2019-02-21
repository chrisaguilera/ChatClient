//
//  MessageLabel.swift
//  ChatClient
//
//  Created by Chris Aguilera on 2/20/19.
//  Copyright © 2019 Chris Aguilera. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
        super.drawText(in: rect.inset(by: insets))
    }
}
