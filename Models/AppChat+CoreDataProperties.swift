//
//  AppChat+CoreDataProperties.swift
//  Sendora
//
//  Created by Youssef Ashraf on 20/09/2025.
//
//

public import Foundation
public import CoreData


public typealias AppChatCoreDataPropertiesSet = NSSet

extension AppChat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppChat> {
        return NSFetchRequest<AppChat>(entityName: "AppChat")
    }

    @NSManaged public var chatId: String?
    @NSManaged public var isArchived: Bool
    @NSManaged public var isMuted: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var messagesIds: NSSet?
    @NSManaged public var participants: NSSet?

}

// MARK: Generated accessors for messagesIds
extension AppChat {

    @objc(addMessagesIdsObject:)
    @NSManaged public func addToMessagesIds(_ value: AppMessage)

    @objc(removeMessagesIdsObject:)
    @NSManaged public func removeFromMessagesIds(_ value: AppMessage)

    @objc(addMessagesIds:)
    @NSManaged public func addToMessagesIds(_ values: NSSet)

    @objc(removeMessagesIds:)
    @NSManaged public func removeFromMessagesIds(_ values: NSSet)

}

// MARK: Generated accessors for participantsIds
extension AppChat {

    @objc(addParticipantsIdsObject:)
    @NSManaged public func addToParticipantsIds(_ value: AppUser)

    @objc(removeParticipantsIdsObject:)
    @NSManaged public func removeFromParticipantsIds(_ value: AppUser)

    @objc(addParticipantsIds:)
    @NSManaged public func addToParticipantsIds(_ values: NSSet)

    @objc(removeParticipantsIds:)
    @NSManaged public func removeFromParticipantsIds(_ values: NSSet)

}

extension AppChat : Identifiable {

}
