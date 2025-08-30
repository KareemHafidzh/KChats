//
//  Chat.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 29/08/25.
//

import Foundation
import FirebaseFirestore

struct Chat: Identifiable, Codable {
    // @DocumentID to automatically get the document ID.
    @DocumentID var id: String?
    
    // The email of the other user in the chat.
    let otherUserEmail: String
    
    // The text of the last message in the chat.
    var lastMessage: String?

    // An array of the UIDs of the two users in the chat.
    let participants: [String]
}
