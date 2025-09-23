import Foundation
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestoreCombineSwift
struct ContentModel: Codable, Equatable, Hashable {
    var content: String
    var isImage: Bool

    init(content: String = "", isImage: Bool = false) {
        self.content = content
        self.isImage = isImage
    }
    
    enum CodingKeys: String, CodingKey {
        case content
        case isImage = "is_image"
    }
}

struct MessageModel: Codable, Equatable,Hashable {
  
  
    var chatId: String?
    var content: ContentModel
    var isRead: Bool
    var isStarred: Bool
    var messageId: String
    var senderId: String
    var timestamp: Date
  
    init(chatId: String = "",
         content: ContentModel = ContentModel(),
         isRead: Bool = false,
         isStarred: Bool = false,
         messageId: String = "",
         senderId: String = "",
         timestamp: Date = .now) {
        self.chatId = chatId
        self.content = content
        self.isRead = isRead
        self.isStarred = isStarred
        self.messageId = messageId
        self.senderId = senderId
        self.timestamp = timestamp
    }

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case content = "content"
        case isRead = "is_read"
        case isStarred = "is_starred"
        case messageId = "message_id"
        case senderId = "sender_id"
        case timestamp = "timestamp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // chatId is always required
        self.chatId = try container.decode(String.self, forKey: .chatId)
        self.content = try container.decode(ContentModel.self, forKey: .content)
        self.isRead = (try? container.decode(Bool.self, forKey: .isRead)) ?? false
        self.isStarred = (try? container.decode(Bool.self, forKey: .isStarred)) ?? false
        self.messageId = (try? container.decode(String.self, forKey: .messageId)) ?? ""
        self.senderId = (try? container.decode(String.self, forKey: .senderId)) ?? ""
        // Decode timestamp from ISO8601 string, fallback to Date, fallback to now
        if let dateString = try? container.decode(String.self, forKey: .timestamp) {
            let isoFormatter = ISO8601DateFormatter()
            self.timestamp = isoFormatter.date(from: dateString) ?? .now
        } else {
            self.timestamp = (try? container.decode(Date.self, forKey: .timestamp)) ?? .now
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Always encode chatId explicitly
        try container.encode(chatId, forKey: .chatId)
        try container.encode(content, forKey: .content)
        try container.encode(isRead, forKey: .isRead)
        try container.encode(isStarred, forKey: .isStarred)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(senderId, forKey: .senderId)
        let isoFormatter = ISO8601DateFormatter()
        let dateString = isoFormatter.string(from: timestamp)
        try container.encode(dateString, forKey: .timestamp)
    }
  
  func getAbstractedTime() -> LocalizedStringKey{
    let calendar = Calendar.current
    let todaysDate = calendar.dateComponents([.day, .year, .month], from: .now)
    let messagesDate = calendar.dateComponents([.day, .year, .month], from: timestamp)
    
    let isShowDate = todaysDate != messagesDate
    
    if isShowDate,
       let todayDay = todaysDate.day,
       let messageDay = messagesDate.day,
       let todayMonth = todaysDate.month,
       let messageMonth = messagesDate.month,
       let todayYear = todaysDate.year,
       let messageYear = messagesDate.year {
        // Show weekday name if within the same month/year and within the last 7 days
        if todayYear == messageYear,
           todayMonth == messageMonth,
           (todayDay - messageDay) >= 0,
           (todayDay - messageDay) < 7 {
          let weekdayIndex = Calendar.current.component(.weekday, from: timestamp) - 1 // 0-based index
            let weekdayName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][max(0, min(6, weekdayIndex))]
            return LocalizedStringKey(weekdayName)
        }
    }
    let today = timestamp.formatted(date: isShowDate ? .numeric : .omitted, time: isShowDate ? .omitted : .shortened)
    
    
    return "\(today)"
  }
}

