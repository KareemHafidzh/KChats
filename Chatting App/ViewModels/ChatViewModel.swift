//
//  ChatViewModel.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var chatID: String?
    
    let otherUserEmail: String
    var dismiss: DismissAction?
    
    // Declare a variable to hold the listener registration.
    var listenerRegistration: ListenerRegistration?
    
    init(otherUserEmail: String) {
        self.otherUserEmail = otherUserEmail
        findOrCreateChat()
    }
    
    deinit {
        // Remove the listener when the ViewModel is deallocated
        listenerRegistration?.remove()
    }
    
    func findOrCreateChat() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("email", isEqualTo: otherUserEmail)
            .getDocuments { (querySnapshot, error) in
                guard let otherUserDoc = querySnapshot?.documents.first else {
                    print("Other user not found")
                    return
                }
                let otherUserUID = otherUserDoc.data()["uid"] as? String ?? ""
                
                db.collection("chats")
                    .whereField("participants", arrayContains: currentUID)
                    .getDocuments { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else { return }
                        
                        for doc in documents {
                            let participants = doc.data()["participants"] as? [String] ?? []
                            if participants.contains(otherUserUID) {
                                self.chatID = doc.documentID
                                self.fetchMessages()
                                print("Chat found: \(self.chatID!)")
                                return
                            }
                        }
                        
                        if self.chatID == nil {
                            let newChatRef = db.collection("chats").document()
                            self.chatID = newChatRef.documentID
                            
                            newChatRef.setData([
                                "participants": [currentUID, otherUserUID],
                                "lastMessage": ""
                            ]) { error in
                                if let error = error {
                                    print("Error creating new chat: \(error.localizedDescription)")
                                } else {
                                    self.fetchMessages()
                                    print("New chat created: \(self.chatID!)")
                                }
                            }
                        }
                    }
            }
    }
    
    func sendMessage() {
        guard let currentUserID = Auth.auth().currentUser?.uid, !messageText.isEmpty, let id = chatID else { return }
        
        let db = Firestore.firestore()
        db.collection("chats").document(id).collection("messages").addDocument(data: [
            "senderID": currentUserID,
            "text": messageText,
            "timestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error adding message: \(error.localizedDescription)")
            } else {
                self.messageText = ""
            }
        }
    }
    
    func fetchMessages() {
        guard let id = chatID else { return }
        
        listenerRegistration?.remove()
        
        listenerRegistration = Firestore.firestore().collection("chats").document(id).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                
                self.messages = documents.compactMap { document in
                    try? document.data(as: Message.self)
                }
                
                if let lastMessage = self.messages.last {
                    Firestore.firestore().collection("chats").document(id).updateData([
                        "lastMessage": lastMessage.text
                    ])
                }
            }
    }
}
