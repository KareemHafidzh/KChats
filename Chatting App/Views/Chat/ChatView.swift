//
//  ChatView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    let otherUserEmail: String
    
    @StateObject var viewModel: ChatViewModel
    
    // Custom initializer to create the ViewModel with the required data
    init(otherUserEmail: String) {
        self.otherUserEmail = otherUserEmail
        // Create an instance of the ViewModel and pass the other user's email
        self._viewModel = StateObject(wrappedValue: ChatViewModel(otherUserEmail: otherUserEmail))
    }
    
    var body: some View {
        Group {
            if let _ = viewModel.chatID {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                    }
                    .background(Color(.systemGray6))
                    
                    HStack {
                        TextField("Type a message...", text: $viewModel.messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: viewModel.sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                }
            } else {
                ProgressView("Starting chat...")
            }
        }
        .navigationTitle(otherUserEmail)
        .navigationBarTitleDisplayMode(.inline)
    }
}
