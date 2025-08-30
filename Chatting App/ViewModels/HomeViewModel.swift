//
//  HomeViewModel.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            if !searchText.isEmpty {
                searchUsers()
            } else {
                searchResults = []
            }
        }
    }
    @Published var searchResults: [User] = []
    @Published var chatHistory: [Chat] = []

    private var chatHistoryListener: ListenerRegistration?

    func signOut(dismissAction: DismissAction) {
        do {
            try Auth.auth().signOut()
            chatHistoryListener?.remove()
            dismissAction()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func searchUsers() {
        searchResults = []
        guard !searchText.isEmpty else { return }

        let db = Firestore.firestore()
        db.collection("users")
            .whereField("email", isGreaterThanOrEqualTo: searchText)
            .whereField("email", isLessThanOrEqualTo: searchText + "~")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.searchResults = querySnapshot!.documents.compactMap { try? $0.data(as: User.self) }
                }
            }
    }

    func fetchChatHistory() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        chatHistoryListener?.remove()
        
        chatHistoryListener = Firestore.firestore().collection("chats")
            .whereField("participants", arrayContains: currentUID)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                guard let documents = querySnapshot?.documents else {
                    print("No chat documents found: \(error?.localizedDescription ?? "")")
                    return
                }

                // This is the new, more robust way to handle the asynchronous data.
                let group = DispatchGroup()
                var chatDocumentsWithEmail: [(doc: QueryDocumentSnapshot, otherUserEmail: String)] = []
                
                for doc in documents {
                    let data = doc.data()
                    let participants = data["participants"] as? [String] ?? []
                    guard let otherUID = participants.first(where: { $0 != currentUID }) else { continue }
                    
                    group.enter()
                    
                    Firestore.firestore().collection("users").document(otherUID).getDocument { (userDoc, userError) in
                        defer { group.leave() }
                        
                        guard let userDoc = userDoc, userDoc.exists, let userData = userDoc.data() else { return }
                        guard let otherUserEmail = userData["email"] as? String else { return }
                        
                        chatDocumentsWithEmail.append((doc: doc, otherUserEmail: otherUserEmail))
                    }
                }
                
                group.notify(queue: .main) {
                    self.chatHistory = chatDocumentsWithEmail.compactMap { item in
                        let data = item.doc.data()
                        let lastMessage = data["lastMessage"] as? String
                        let participants = data["participants"] as? [String] ?? []
                        
                        return Chat(id: item.doc.documentID, otherUserEmail: item.otherUserEmail, lastMessage: lastMessage, participants: participants)
                    }
                    
                    // Sort the chats after all data is ready.
                    self.chatHistory = self.chatHistory.sorted(by: { $0.otherUserEmail < $1.otherUserEmail })
                }
            }
    }
}
