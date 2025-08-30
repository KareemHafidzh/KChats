//
//  HomeView.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            NavigationStack {
                List {
                    if viewModel.searchText.isEmpty {
                        chatHistorySection
                    } else {
                        searchResultsSection
                    }
                }
                .navigationTitle("KChats")
                .searchable(text: $viewModel.searchText, prompt: "Search for a user or chat")
                .textInputAutocapitalization(.never)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") {
                            viewModel.signOut(dismissAction: dismiss)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchChatHistory()
                }
            }
        }
    
    // A computed property to render the chat history section
        private var chatHistorySection: some View {
            Section(header: Text("Chat History")) {
                ForEach(viewModel.chatHistory) { chat in
                    NavigationLink(destination: ChatView(otherUserEmail: chat.otherUserEmail)) {
                        VStack(alignment: .leading){
                            Text(chat.otherUserEmail)
                                .font(.headline)
                            Text(chat.lastMessage ?? "Start a chat ^v^")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        
        // A computed property to render the search results section
        private var searchResultsSection: some View {
            Section(header: Text("Search Results")) {
                ForEach(viewModel.searchResults) { user in
                    NavigationLink(destination: ChatView(otherUserEmail: user.email)) {
                        Text(user.email)
                    }
                }
            }
        }
}

#Preview {
    HomeView()
}
