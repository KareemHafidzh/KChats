//
//  ChatView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    // A constant to hold the chat ID for this conversation
    let chatID: String
    
    @State private var messages: [Message] = []
    @State var chatText: String = ""
    var body: some View {
        VStack{
            ScrollView {
                ForEach(messages) { message in
                    ChatBubbleView(message: message)
                }
            }
            
            HStack {
                TextField("Chat here", text: $chatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 20)
            .background(Color(.systemBackground))
        }
        .onAppear {
            // Your function to fetch messages from Firestore
            // This is where you would call your Firestore listener
        }
        .navigationTitle("Chat")
    }
    
    func sendMessage() {
            // Your logic for sending a message to Firestore
        }
}
