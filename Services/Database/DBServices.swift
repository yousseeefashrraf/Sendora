import Firebase
import FirebaseCore
import Foundation
import FirebaseAuth
import FirebaseFirestore

enum Collections: String, CaseIterable{
  case users = "users", chats = "chat", messages = "message"
  
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
  
  func getMessages(forChat chatId: String, lastMessage: DocumentSnapshot?) async -> ([MessageModel], DocumentSnapshot?){
    
    var query = db.collection(Collections.chats.rawValue)
      .document(chatId)
      .collection(Collections.messages.rawValue)
      .whereField(MessageModel.CodingKeys.chatId.rawValue, isEqualTo: chatId)
      .order(by: MessageModel.CodingKeys.timestamp.rawValue, descending: true)
      .limit(to: 40)
    if let lastMessage {
      query = query.start(afterDocument: lastMessage)
    }
    
    let snapshot = try? await query.getDocuments().documents
    let messages = snapshot?.compactMap{ try? $0.data(as: MessageModel.self) } ?? []
    
    return (messages, snapshot?.last)
  }
  
  func getChatsAndUsers(lastDocument: DocumentSnapshot?, userId: String, fetchedUsers: [String]) async -> ([ChatModel], DocumentSnapshot?, [UserModel]){
    
    var query = db.collection(Collections.chats.rawValue)
      .order(by: ChatModel.CodingKeys.lastUpdate.rawValue, descending: true)
      .whereField(ChatModel.CodingKeys.participantsIds.rawValue, arrayContains: userId)
      .limit(to: 10)
    
    
    if let lastDocument { query = query.start(afterDocument: lastDocument) }
    
    do{
      let chatsSnap = try? await query.getDocuments().documents
    } catch {
      print(error)
    }
    
    let chatsSnap = try? await query.getDocuments().documents
    let lastSnap = chatsSnap?.last
    
    let chats = chatsSnap?.compactMap {try? $0.data(as: ChatModel.self)} ?? []
    let usersIds = Array(Set(chats.flatMap { $0.participantsIds }).subtracting(fetchedUsers)).sorted()
    
    
    var users: [UserModel] = []
    
    for chunk in stride(from: 0, to: usersIds.count, by: 10){
      let subUsersIds = usersIds[chunk ..< min(chunk+10, usersIds.count)]
      let userQuery = try? await db.collection(Collections.users.rawValue)
        .whereField(UserModel.CodingKeys.userId.rawValue, in: Array(subUsersIds))
        .getDocuments()
        .documents
      users += userQuery?.compactMap {try? $0.data(as: UserModel.self)} ?? []
      
    }
    
    return (chats, lastSnap, users)
  }
  
  
  
}

