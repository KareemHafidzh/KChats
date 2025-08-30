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
    
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            Text("Register Here!")
            CustomEmailTextField(textInTheField: "Enter your email here!", text: $viewModel.email)
            CustomSecureTextField(textInTheField: "Enter your password here!", text: $viewModel.password)
            
            Button {
                viewModel.RegisterUser()
            } label: {Text("Register")}
        }
        .alert("Login Error", isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack{
        RegisterView()
    }
}
