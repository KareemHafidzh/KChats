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
    var dismiss: DismissAction?
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss?()
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
}
