//
//  AppMessage+CoreDataProperties.swift
//  Sendora
//
//  Created by Youssef Ashraf on 20/09/2025.
//
//

public import Foundation
public import CoreData


public typealias AppMessageCoreDataPropertiesSet = NSSet

extension AppMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppMessage> {
        return NSFetchRequest<AppMessage>(entityName: "AppMessage")
    }

    @NSManaged public var isRead: Bool
    @NSManaged public var isStarred: Bool
    @NSManaged public var messageId: String?
    @NSManaged public var senderId: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var chat: AppChat?
    @NSManaged public var messageContent: MessageContent?

}

extension AppMessage : Identifiable {

}
