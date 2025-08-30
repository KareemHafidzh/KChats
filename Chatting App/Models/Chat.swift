//
//  Chat.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import Foundation

struct Chat: Identifiable {
    let id: String // The document ID from Firestore
    let otherUserEmail: String
    var lastMessage: String?
}
