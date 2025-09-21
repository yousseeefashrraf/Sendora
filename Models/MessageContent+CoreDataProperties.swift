//
//  MessageContent+CoreDataProperties.swift
//  Sendora
//
//  Created by Youssef Ashraf on 20/09/2025.
//
//

public import Foundation
public import CoreData


public typealias MessageContentCoreDataPropertiesSet = NSSet

extension MessageContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageContent> {
        return NSFetchRequest<MessageContent>(entityName: "MessageContent")
    }

    @NSManaged public var content: String?
    @NSManaged public var isImage: Bool
    @NSManaged public var message: AppMessage?

}
