//
//  User.swift
//  Chatting App
//
//  Created by Kareem Abdul Hafidzh on 30/08/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    let uid: String
}
