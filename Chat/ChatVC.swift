//
//  ChatVC.swift
//  Chat
//
//  Created by Юрий Макаров on 10.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

class ChatVC: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageInputBarDelegate {
    
    
    var idRoom: String?
    var titleChat: String?
    var messages: [Messages] = []
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        self.title = titleChat!
        downloadAllMessage()
    }
    
    func currentSender() -> Sender {
        return Sender(id: DataSourse.shared.myID, displayName: DataSourse.shared.MyName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func downloadAllMessage(){
            let query = self.ref.child("ChatRoom").child(idRoom!).child("Messages").queryLimited(toLast: 25)
        query.observe(.childAdded) { (snapshot) in
            if  let data        = snapshot.value as? [String: String],
                let SenderId          = data["senderID"],
                let text              = data["text"],
                let SenderName        = data["senderName"],
                let messageID         = data["messageID"]
            {
                let newMsg = Messages(sender: Sender(id: SenderId, displayName: SenderName), messageId: messageID, sentDate: Date(), kind: .text(text))
                self.messages.append(newMsg)
                self.messagesCollectionView.insertSections([self.messages.count - 1])
                self.messagesCollectionView.scrollToBottom()
        }
        }
    }
    
    
    
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if case let newMessage = Messages(sender: currentSender(), messageId: self.ref.childByAutoId().key, sentDate: Date(), kind: MessageKind.text(text)) {
        let newMessageFir: [String : String] = [ "senderID" : newMessage.sender.id,
                                                 "text" : text,
                                                 "senderName" : newMessage.sender.displayName,
                                                 "messageID" : newMessage.messageId]
        self.ref.child("ChatRoom").child(idRoom!).child("Messages").child(newMessage.messageId).setValue(newMessageFir)
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }

    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}



class Messages: MessageType{
    var sender: Sender
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    init(sender: Sender, messageId: String, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
}
