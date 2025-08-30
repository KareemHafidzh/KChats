//
//  HomeView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var searchResults: [String] = []
    
    var body: some View {
        NavigationStack{
            List{
                // 3. Display the fetched search results
                ForEach(searchResults, id: \.self) { email in
                    Text(email)
                }
            }
            .navigationTitle("KChats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        signOut()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for an email")
            .onChange(of: searchText) { oldText, newText in
                searchUsers()
        }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // 5. Function to perform the Firebase query
    func searchUsers() {
        // Clear previous results before starting a new search
        searchResults = []
        
        guard !searchText.isEmpty else { return } // Exit if search text is empty
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("email", isGreaterThanOrEqualTo: searchText)
            .whereField("email", isLessThanOrEqualTo: searchText + "~")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    // Map the documents to a list of emails
                    var emails: [String] = []
                    for document in querySnapshot!.documents {
                        let email = document.data()["email"] as? String ?? ""
                        if !email.isEmpty {
                            emails.append(email)
                        }
                    }
                    self.searchResults = emails
                }
            }
    }
}

#Preview {
    HomeView()
}
