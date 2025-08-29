//
//  ContentView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showingAlert = false
    @State var alertMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("KChats").font(.system(size: 45))
                Spacer()
                
                CustomTextField(textInTheField: "Enter your name", text: $email).keyboardType(.emailAddress)
                CustomTextField(textInTheField: "Enter your password", text: $password)
                
                Button("Log In") {
                    //template
                    LoginUser()
                }
                
                NavigationLink("If you dont have account, Register Here!") {
                    RegisterView()
                }
                Spacer()
            }
            .padding()
            .alert("Login Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            HomeView()
        }
    }
    
    
    func LoginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
                alertMessage = error.localizedDescription
                showingAlert = true
                
            }else{
                self.isLoggedIn = true
            }
        }
    }
}

#Preview {
    ContentView()
}

struct CustomTextField: View {
    let textInTheField: String
    @Binding var text: String
    
    var body: some View {
        TextField(textInTheField, text: $text)
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
        
    }
}
