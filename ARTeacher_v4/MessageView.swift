//
//  MessageView.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 24/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import UIKit

class MessageView : UIVisualEffectView {
    
    private var label = UILabel()
    private var currentMessage: String?
    private var messagesQeueue = [String]()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        
        self.contentView.addSubview(label)
        
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func queueMessage(message: String) {
        if currentMessage != nil {
            messagesQeueue.insert(message, at: 0)
            return
        }

        messagesQeueue.insert(message, at: 0)
        self.showMessage()
    }
    
    func showMessage() {
        self.currentMessage = messagesQeueue.popLast()
        
        if self.currentMessage == nil {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.alpha = 0
            })
        } else {
            label.text = self.currentMessage
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.alpha = 1
            }) { (finished) in
                // wait 5 seconds
                _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    self.showMessage()
                })
            }
        }
        
    }
    
}
