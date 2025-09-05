import CoreData
import Combine
import Foundation
import SwiftUI


class SyncManager: ObservableObject {
    private let userViewModel: UserViewModel
    private let coreDataManager: CoreDataManager
    private let routerViewModel: RouterViewModel // ADD THIS
    private var cancellables = Set<AnyCancellable>()
    private var hasHandledInitialRouting = false
    @Published var lastSyncDate: Date?
    @Published var syncError: Error?
    
    // ADD routerViewModel parameter
    init(userViewModel: UserViewModel, coreDataManager: CoreDataManager, routerViewModel: RouterViewModel) {
        self.userViewModel = userViewModel
        self.coreDataManager = coreDataManager
        self.routerViewModel = routerViewModel // ADD THIS
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        userViewModel.$authUser
            .sink { [weak self] authUser in
                
                    self?.hasHandledInitialRouting = false // Reset on logout
                    Task{
                       try? await Task.sleep(nanoseconds: 3000_000_000)
                        await MainActor.run { [weak self] in
                            
                            withAnimation (.easeInOut(duration: 0.5)){
                                self?.routerViewModel.isInitializing = false

                            }
                    
                    }
                }
            }
            .store(in: &cancellables)
            
        userViewModel.$dbUser
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] dbUser in
                self?.handleRoutingAfterSync(dbUser: dbUser)
            }
            .store(in: &cancellables)
    }
    
    
    
    private func handleRoutingAfterSync(dbUser: UserModel) {
        // Prevent multiple routing calls during startup
        guard !hasHandledInitialRouting else { return }
        hasHandledInitialRouting = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if dbUser.isNewUser {
                self.routerViewModel.routeToSignUpInfo()
            } else {
                self.routerViewModel.routeToHome()
                print("Home")
            }
        }
    }
    // MARK: - Manual Sync Operations
    func manualSyncFromFirebase() async {
        if let dbUser = userViewModel.dbUser {
            await coreDataManager.syncFromFirebase(user: dbUser)
            await MainActor.run {
                self.lastSyncDate = Date()
            }
        }
    }
    
    func manualSyncToFirebase() async throws {
        // Only sync if there are local changes that should propagate to Firebase
        // This prevents circular updates
        guard let appUser = coreDataManager.appUser,
              let userId = appUser.id else {
            throw SyncError.noLocalUser
        }
        
        // Implement logic to detect if local changes need to be synced to Firebase
        // This is optional and should be used carefully to avoid circular updates
    }
    
    // MARK: - Initial Setup
    func initialize() async {
        // Initial sync when app starts
        if let dbUser = userViewModel.dbUser {
            await coreDataManager.syncFromFirebase(user: dbUser)
        }
            
        
    }
    
    func resetRouting(){
        hasHandledInitialRouting = false
    }
    
    deinit{
        cancellables.removeAll()
    }
}

enum SyncError: LocalizedError {
    case noLocalUser
    case syncConflict
    case networkUnavailable
    
    var errorDescription: String? {
        switch self {
        case .noLocalUser: return "No local user data available"
        case .syncConflict: return "Sync conflict detected"
        case .networkUnavailable: return "Network unavailable for sync"
        }
    }
}
