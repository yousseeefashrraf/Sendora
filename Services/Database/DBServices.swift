import Firebase
import FirebaseCore
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Collections: String{
    case users = "users", chats, messages
    
    var invalidCreateOperatingDescribiton: String{
        switch self {
        case .users:
            return "An error occured while trying to update you profile. Please try again later."
        case .chats:
            return "An error occured while trying to make an new chat. Please try again later."
        case .messages:
            return "An error occured while trying to send the message. Please try again later."

        }
    }
    }

class DBServicesManager{
    static var shared = DBServicesManager()
    private let db = Firestore.firestore()
    private init(){}
    
    func setDocData(collection: Collections, newDocument: Codable, documentId: String) async throws{
        do{
            try db.collection(collection.rawValue).document(documentId).setData(from: newDocument)
        } catch{
            throw error
        }
        
    }
    
    func createUser() async throws{
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email
            let DBUser = UserModel(bio: "", profilePicture: "", userId: uid, username: "newUser", isNewUser: true, email: email)
            try await DBServicesManager.shared.setDocData(collection: .users, newDocument: DBUser, documentId: uid)
        }
    }

    
    func createDocument(collection: Collections, newDocument: Codable) async throws{
        do{
            try db.collection(collection.rawValue).addDocument(from: newDocument)
        } catch{
            print("Error")
            throw AuthError.unknow
        }
        
    }
    
    func updateDocument<T>(collection: Collections, documentId: String, propertyToUpdate property: CodingKey, newValue: T) async throws{
        do{
            try await db.collection(collection.rawValue).document(documentId).updateData([property.stringValue : newValue])
        } catch{
            
        }
    }
    func getDocument<T: Codable>(collection: Collections,documentId: String, documentType: T.Type) async throws -> Codable{
        do{
           return try await db.collection(collection.rawValue).document(documentId).getDocument(as: documentType)
        } catch{
            throw error
        }
    }
    
}

