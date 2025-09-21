import CoreData
import Combine
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class CoreDataManager: ObservableObject {
  let container: NSPersistentContainer
  @Published var appUser: AppUser?
  private var context: NSManagedObjectContext
  
  init() {
    container = NSPersistentContainer(name: "Sendora")
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
    context = container.viewContext
  }
  
  private func makeAppUser(from dbUser: UserModel, in context: NSManagedObjectContext) -> AppUser {
    let user = AppUser(context: context)
    user.id = dbUser.userId
    user.username = dbUser.username
    user.email = dbUser.email
    user.bio = dbUser.bio
    user.profilePicture = dbUser.profilePicture
    user.isNewUser = dbUser.isNewUser
    // Core Data-only defaults
    user.dateCreated = Date()
    return user
  }
  
  private func updatedAppUser(_ appUser: AppUser, with dbUser: UserModel) -> AppUser {
    let user = appUser
    user.username = dbUser.username
    user.email = dbUser.email
    user.bio = dbUser.bio
    user.profilePicture = dbUser.profilePicture
    user.isNewUser = dbUser.isNewUser
    return user
  }
  
  // Helper: Map Core Data AppUser to domain UserModel
  private func makeUserModel(from appUser: AppUser) -> UserModel {
    return UserModel(
      bio: appUser.bio ?? "",
      profilePicture: appUser.profilePicture ?? "",
      userId: appUser.id ?? "",
      username: appUser.username ?? "",
      isNewUser: appUser.isNewUser,
      email: appUser.email ?? ""
    )
  }
  
  // FIXED: Proper async handling
  func getOrCreateAppUser(from dbUser: UserModel) async throws -> AppUser {
    try await withCheckedThrowingContinuation { continuation in
      context.perform {
        do {
          let request = NSFetchRequest<AppUser>(entityName: "AppUser")
          request.predicate = NSPredicate(format: "id == %@", dbUser.userId ?? "")
          
          if let existingUser = try self.context.fetch(request).first {
            let updated = self.updatedAppUser(existingUser, with: dbUser)
            try self.context.save()
            continuation.resume(returning: updated)
          } else {
            let newUser = self.makeAppUser(from: dbUser, in: self.context)
            try self.context.save()
            continuation.resume(returning: newUser)
          }
          
        } catch {
          print("Core Data error: \(error)")
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func update(appUser: AppUser, with dbUser: UserModel) {
    _ = updatedAppUser(appUser, with: dbUser)
    appUser.lastUpdate = dbUser.lastUpdate ?? Date()
    do { try context.save() } catch { print("Core Data save error: \(error)") }
  }
  
  func deleteAppUser(userId: String) async throws {
    try await withCheckedThrowingContinuation { continuation in
      context.perform {
        do {
          let request = NSFetchRequest<AppUser>(entityName: "AppUser")
          request.predicate = NSPredicate(format: "id == %@", userId)
          
          if let user = try self.context.fetch(request).first {
            self.context.delete(user)
            try self.context.save()
          }
          continuation.resume()
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
 
  
  func syncFromFirebase(user: UserModel) async {
    print("Starting sync from Firebase...")
    do {
      let appUser = try await getOrCreateAppUser(from: user)
      await MainActor.run {
        self.appUser = appUser
        print("Sync completed successfully. AppUser: \(appUser)")
      }
    } catch {
      print("Sync from Firebase failed: \(error)")
    }
  }
  
  func castChatToModel(appChat app: AppChat) -> ChatModel {
    let participants: [String] = app.participants?.allObjects.compactMap { element in
      return element as? String
    } ?? []
    
    let model = ChatModel(
      chatId: app.chatId ?? "",
      isArchived: app.isArchived,
      isMuted: app.isMuted,
      isPinned: app.isPinned,
      lastUpdate: app.lastUpdate ?? .now,
      participantsIds: participants)
    return model
  }
  
  func castChatToCore(chatModel model: ChatModel, participants: [AppUser]) -> AppChat {
    
    let appModel = AppChat(context: container.viewContext)
    
    appModel.chatId = model.id
    appModel.isArchived = model.isArchived
    appModel.isMuted = model.isMuted
    appModel.isPinned = model.isPinned
    appModel.participants = NSSet(array: participants)
    appModel.lastUpdate = model.lastUpdate
    
    try? container.viewContext.save()
    return appModel
  }
  
  func getAllChats() -> [ChatModel] {
    let request = NSFetchRequest<AppChat>(entityName: "AppChat")
    request.sortDescriptors = [NSSortDescriptor(keyPath: \AppChat.lastUpdate, ascending: true)]
    if let chats = try? container.viewContext.fetch(request), !chats.isEmpty {
      return chats.map { castChatToModel(appChat: $0) }
    } else {
      
      return []
    }
  }
  
  func getChatsAndUsers(lastDocument: DocumentSnapshot?, userId: String, fetchedUsers: [String]) async -> ([ChatModel], DocumentSnapshot?, [UserModel]){
    
    //Query
    let request = NSFetchRequest<AppChat>(entityName: "AppChat")
    request.sortDescriptors = [NSSortDescriptor(key: "lastUpdate", ascending: false)]
    request.fetchLimit = 10
    
    var predicates: [NSPredicate] = []
    predicates.append(NSPredicate(format: "ANY participants.id == %@", userId)
    )
    if let lastDocument, let chat = try? lastDocument.data(as: ChatModel.self) {
      predicates.append(NSPredicate(format: "lastUpdate < %@", chat.lastUpdate as NSDate))
      
    }
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates )
    
    
    //Quering Users
    
    do {
      let chats = try container.viewContext.fetch(request)
      let usersIds: Set<String> = Set(chats.flatMap { chat in
        (chat.participants?.allObjects as? [AppUser])?.compactMap(\.id) ?? []
      }).subtracting(fetchedUsers) // this can have a bug
      
      let userRequest = NSFetchRequest<AppUser>(entityName: "AppUser")
      userRequest.predicate = NSPredicate(format: "id IN %@", usersIds)
      let users = try container.viewContext.fetch(userRequest)
      
      let chatModels = chats.compactMap{ castChatToModel(appChat: $0) }
      let userModels: [UserModel] = users.compactMap {makeUserModel(from: $0)}
      return (chatModels, lastDocument, userModels)
    } catch {
      print("Core Data fetch error: \(error)")
    }
    
    // Fallbacks: try local again, otherwise fetch from remote and map
    do {
      let chats = try container.viewContext.fetch(request)
      let chatModels = chats.map { castChatToModel(appChat: $0) }
      return (chatModels, lastDocument, [])
    } catch {
      print("Core Data fallback error: \(error)")
      // Remote fetch as final fallback
      let remote = await DBServicesManager.shared.getChatsAndUsers(lastDocument: lastDocument, userId: userId, fetchedUsers: fetchedUsers)
      
      let appUseres =  remote.2.compactMap { makeAppUser(from: $0, in: container.viewContext) }
      let appChats = remote.0.compactMap{castChatToCore(chatModel: $0, participants: appUseres)}
      
      try? container.viewContext.save()
      
      return remote
    }
  }
  
  func castMessageToCore(messageModel: MessageModel, appChat: AppChat) -> AppMessage{
    let appMessage = AppMessage(context: container.viewContext)
    
    appMessage.timestamp = messageModel.timestamp
    appMessage.isRead = messageModel.isRead
    appMessage.chat = appChat
    appMessage.isRead = messageModel.isRead
    appMessage.isStarred = messageModel.isStarred
    appMessage.messageId = messageModel.messageId
    appMessage.senderId = messageModel.senderId
    
    let content = MessageContent(context: container.viewContext)
    content.content = messageModel.content.content
    content.isImage = messageModel.content.isImage
    appMessage.messageContent = content
    try? container.viewContext.save()
    
    return appMessage

  
  }
  
  func castMessageToModel(appMessage: AppMessage) -> MessageModel{
    let content = ContentModel(content: appMessage.messageContent?.content ?? "",
                               isImage: appMessage.messageContent?.isImage ?? false)
    
    var message = MessageModel()
    message.senderId = appMessage.senderId ?? ""
    message.content = content
    message.timestamp = appMessage.timestamp ?? .now
    message.chatId = appMessage.chat?.chatId ?? ""
    message.isRead = appMessage.isRead
    message.isStarred = appMessage.isStarred
    message.messageId = appMessage.messageId ?? ""

    return message
    
  }
  
  func getMessages(forChat chatId: String, lastMessage: DocumentSnapshot?, appChat: AppChat) async -> ([MessageModel], DocumentSnapshot?){
    
   
      let request = NSFetchRequest<AppMessage>(entityName: "AppMessage")
      request.fetchLimit = 40
      request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
      var predicates: [NSPredicate] = []
      
      predicates.append(NSPredicate(format: "ANY chat.chatId %@", chatId))
      
      if let lastMessage = try? lastMessage?.data(as: MessageModel.self)  {
        predicates.append(NSPredicate(format:"timestamp < %@", lastMessage.timestamp as NSDate))
        
      }
    
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    do{
      let result = try container.viewContext.fetch(request)
      return (result.compactMap{ castMessageToModel(appMessage: $0)}, lastMessage)
    } catch{
      print("Message Error occured: \(error.localizedDescription)")
    }
      //local fallback
    do{
      let result = try container.viewContext.fetch(request)
      return (result.compactMap{ castMessageToModel(appMessage: $0)}, lastMessage)
    } catch{
      print("Message Error occured: \(error.localizedDescription)")
    }
    
      var result = await DBServicesManager.shared.getMessages(forChat: chatId, lastMessage: lastMessage)
      let appMessages = result.0.compactMap{ castMessageToCore(messageModel: $0, appChat: appChat) }
      try? container.viewContext.save()
      return result

    
    
    
    
  }
  
  
}
