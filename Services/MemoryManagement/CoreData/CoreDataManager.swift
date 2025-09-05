import CoreData
import Combine
import Foundation
import SwiftUI

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
    
    // FIXED: Proper async handling
    func getOrCreateAppUser(from dbUser: UserModel) async throws -> AppUser {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<AppUser>(entityName: "AppUser")
                    request.predicate = NSPredicate(format: "id == %@", dbUser.userId ?? "")
                    
                    if let existingUser = try self.context.fetch(request).first {
                        // Update only what exists in both models
                        existingUser.username = dbUser.username
                        existingUser.email = dbUser.email
                        existingUser.bio = dbUser.bio
                        existingUser.profilePicture = dbUser.profilePicture
                        existingUser.isNewUser = dbUser.isNewUser
                        // Don't set properties that don't exist in UserModel
                        continuation.resume(returning: existingUser)
                    } else {
                        let newUser = AppUser(context: self.context)
                        newUser.id = dbUser.userId
                        newUser.username = dbUser.username
                        newUser.email = dbUser.email
                        newUser.bio = dbUser.bio
                        newUser.profilePicture = dbUser.profilePicture
                        newUser.isNewUser = dbUser.isNewUser
                        // Set default values for Core Data-only properties
                        newUser.dateCreated = Date()
                        continuation.resume(returning: newUser)
                    }
                    
                    try self.context.save()
                } catch {
                    print("Core Data error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func update(appUser: AppUser, with dbUser: UserModel) {
        appUser.username = dbUser.username
        appUser.email = dbUser.email
        appUser.bio = dbUser.bio
        appUser.profilePicture = dbUser.profilePicture
        appUser.isNewUser = dbUser.isNewUser
        appUser.lastUpdate = dbUser.lastUpdate ?? Date()
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
}

