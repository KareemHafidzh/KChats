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
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Search Results")) {
                    ForEach(viewModel.searchResults) { user in
                        NavigationLink(destination: ChatView(otherUserEmail: user.email)) {
                            Text(user.email)
                        }
                    }
                }
            }
            .navigationTitle("KChats")
            .searchable(text: $viewModel.searchText, prompt: "Search for a user or chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        viewModel.signOut()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
