import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable, Codable {
    // @DocumentID to automatically get the document ID
    @DocumentID var id: String?
    
    // The UID of the sender
    let senderID: String
    
    // The content of the message
    let text: String
    
    // The server-side timestamp of the message
    let timestamp: Date

    // A computed property to determine if the message is from the current user.
    // This is much cleaner than using the logic directly in the view.
    var isFromUser: Bool {
        return senderID == Auth.auth().currentUser?.uid
    }
}
