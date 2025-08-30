//
//  RegisterViewModel.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

class RegisterViewModel: ObservableObject{
    @Environment(\.dismiss) var dismiss
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    func RegisterUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
                alertMessage = error.localizedDescription
                showingAlert = true
            } else {
                // Get the user's UID from the result
                guard let user = authResult?.user else { return }
                
                // Use the user's UID to create a document in the 'users' collection
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "email": user.email,
                    "uid": user.uid
                ]) { dbError in
                    if let dbError = dbError {
                        print("Error saving user to Firestore: \(dbError.localizedDescription)")
                    } else {
                        print("User data saved successfully!")
                        // Dismiss the view to go back to the login screen
                        self.dismiss()
                    }
                }
            }
        }
    }
}
