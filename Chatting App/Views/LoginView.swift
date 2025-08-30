//
//  ContentView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack{
            VStack {
                Text("KChats").font(.system(size: 45))
                Spacer()
                
                CustomEmailTextField(textInTheField: "Enter your email", text: $viewModel.email).keyboardType(.emailAddress)
                CustomSecureTextField(textInTheField: "Enter your password", text: $viewModel.password)
                
                Button("Log In") {
                    //template
                    viewModel.LoginUser()
                }
                
                NavigationLink("If you dont have account, Register Here!") {
                    RegisterView()
                }
                Spacer()
            }
            .padding()
            .alert("Login Error", isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            HomeView()
        }
    }
}

#Preview {
    LoginView()
}
