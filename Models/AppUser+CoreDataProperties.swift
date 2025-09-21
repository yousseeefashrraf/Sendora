//
//  AppUser+CoreDataProperties.swift
//  Sendora
//
//  Created by Youssef Ashraf on 20/09/2025.
//
//

public import Foundation
public import CoreData


public typealias AppUserCoreDataPropertiesSet = NSSet

extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var bio: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var isNewUser: Bool
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var profilePicture: String?
    @NSManaged public var username: String?
    @NSManaged public var chatIds: NSSet?

}

// MARK: Generated accessors for chatIds
extension AppUser {

    @objc(addChatIdsObject:)
    @NSManaged public func addToChatIds(_ value: AppChat)

    @objc(removeChatIdsObject:)
    @NSManaged public func removeFromChatIds(_ value: AppChat)

    @objc(addChatIds:)
    @NSManaged public func addToChatIds(_ values: NSSet)

    @objc(removeChatIds:)
    @NSManaged public func removeFromChatIds(_ values: NSSet)

}

extension AppUser : Identifiable {

}
