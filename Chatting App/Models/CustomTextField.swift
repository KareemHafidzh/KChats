//
//  CustomTextField.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import SwiftUI

struct CustomEmailTextField: View {
    let textInTheField: String
    @Binding var text: String
    
    var body: some View {
        TextField(textInTheField, text: $text)
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
    }
}

struct CustomSecureTextField: View {
    let textInTheField: String
    @Binding var text: String
    
    var body: some View {
        SecureField(textInTheField, text: $text)
            .textInputAutocapitalization(.none)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
    }
}
