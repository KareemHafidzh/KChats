//
//  RegisterView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State var email: String = ""
    @State var password: String = ""
    @State var showingAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        
        VStack {
            Text("Register Here!")
            
            TextField("Enter your email here!", text: $email)
            TextField("Enter your password here!", text: $password)
            
            Button {
                RegisterUser()
                
            } label: {
                Text("Register")
            }
        }
        .alert("Login Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
            
        } message: {
            Text(alertMessage)
        }
        
    }
    
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

#Preview {
    NavigationStack{
        RegisterView()
    }
}
