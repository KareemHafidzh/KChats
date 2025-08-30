//
//  LoginViewModel.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

class LoginViewModel:ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var isLoggedIn = false
    
    func LoginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
                
            }else{
                print("User data Authentication successfully!")
                self.isLoggedIn = true
            }
        }
    }
}
