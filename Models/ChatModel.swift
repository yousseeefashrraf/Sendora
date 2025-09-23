import Foundation
import FirebaseCore
import Firebase

struct ChatModel: Codable, Hashable, Identifiable {
  
    var id: String?
    var isArchived: Bool
    var isMuted: Bool
    var isPinned: Bool
    var lastUpdate: Date
    var participantsIds: [String]
  
    
    // Simple initializer with defaults
    init(chatId: String = "", isArchived: Bool = false, isMuted: Bool = false, isPinned: Bool = false, lastUpdate: Date = .now, participantsIds: [String] = []) {
        self.id = chatId
        self.isArchived = isArchived
        self.isMuted = isMuted
        self.isPinned = isPinned
        self.lastUpdate = lastUpdate
        self.participantsIds = participantsIds
    }

    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case isArchived = "is_archived"
        case isMuted = "is_muted"
        case isPinned = "is_pinned"
        case lastUpdate = "last_update"
        case participantsIds = "participants_ids"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.isArchived = try container.decode(Bool.self, forKey: .isArchived)
        self.isMuted = try container.decode(Bool.self, forKey: .isMuted)
        self.isPinned = try container.decode(Bool.self, forKey: .isPinned)
        // Date strategy: first try decoding as String with ISO8601, else decode Date directly
        if let dateString = try? container.decode(String.self, forKey: .lastUpdate) {
            let isoFormatter = ISO8601DateFormatter()
            self.lastUpdate = isoFormatter.date(from: dateString) ?? .now
        } else {
            self.lastUpdate = (try? container.decode(Date.self, forKey: .lastUpdate)) ?? .now
        }
        self.participantsIds = try container.decode([String].self, forKey: .participantsIds)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(isMuted, forKey: .isMuted)
        try container.encode(isPinned, forKey: .isPinned)
        let isoFormatter = ISO8601DateFormatter()
        let dateString = isoFormatter.string(from: lastUpdate)
        try container.encode(dateString, forKey: .lastUpdate)
        try container.encode(participantsIds, forKey: .participantsIds)
    }
}

class ChatsViewModel: ObservableObject {
  
  @Published var chats: [ChatModel] = []
  @Published var messages: [String: [MessageModel]] = [:]
  @Published var currentChat: ChatModel?
  @Published var lastDocuments: [String: DocumentSnapshot?] = [:]
  @Published var fetchedUsers: [UserModel] = []
  
  func getChatsAndUseres(userVm: UserViewModel, coreManager: CoreDataManager){
    
    for i in Collections.allCases {
      lastDocuments[i.rawValue] = nil
    }
    guard let id = userVm.dbUser?.userId else { return }
    let fetchedIds = fetchedUsers.compactMap { $0.userId }
    Task{
      let result = await coreManager.getChatsAndUsers(lastDocument: lastDocuments[Collections.chats.rawValue] ?? nil, userId: id, fetchedUsers: fetchedIds)
      
      await MainActor.run {
        fetchedUsers.append(contentsOf: result.2)
        chats = result.0
        
        lastDocuments[Collections.chats.rawValue] = result.1
        
        
        
      }
      
    }
  }
  
 /* init(isTesting: Bool){
    guard isTesting else {return}
    
    let chat1 = ChatModel(chatId: "chat1",lastUpdate: .now, participantsIds: ["1","2"])
    chats.append(chat1)
    let chat2 = ChatModel(chatId: "chat2",lastUpdate: .now, participantsIds: ["1","2"])
    chats.append(chat2)
    
    let messagesMock = ["Heyy how are you?","Great, hbu?", "last night was so funny haha", "idk, you think so!", "ofc!! omg it was so amazing","See you tonight then!","Bet!", "Deal!"]
    for (index, content) in messagesMock.enumerated(){

      let message = MessageModel(chatId: "chat1", content: ContentModel(content: content),isRead: false, messageId: "1\(index)", senderId: "\(index % 2 == 0 ? 1 : 2)",timestamp: .now)

      if let _ = messages["chat1"] {
        messages["chat1"]?.append(message)
      } else {
        messages["chat1"] = []
      }
      
      
    }
    
    for (index, content) in messagesMock.enumerated(){

      let message = MessageModel(chatId: "chat2", content: ContentModel(content: content),isRead: false, messageId: "2\(index)", senderId: "\(index % 2 == 0 ? 1 : 2)",timestamp: .now.addingTimeInterval(-60*60*24*2))
      
      if let _ = messages["chat2"] {
        messages["chat2"]?.append(message)
      }  else {
        messages["chat2"] = []
      }
      
    }
    
    print(messages)
  } */
}
