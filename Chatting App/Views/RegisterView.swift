//
//  RegisterView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseAuth

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
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
    NavigationStack{
        RegisterView()
    }
}
