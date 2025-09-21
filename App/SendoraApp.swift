//
//  SendoraApp.swift
//  Sendora
//
//  Created by Youssef Ashraf on 26/07/2025.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn
import GoogleSignInSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        print("Firebase app configured!")
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

// Create a main AppState class
class AppState: ObservableObject {
    @Published var routerViewModel = RouterViewModel()
    @Published var userViewModel = UserViewModel()
    @Published var coreDataManager = CoreDataManager()
    
    lazy var syncManager = SyncManager(
        userViewModel: userViewModel,
        coreDataManager: coreDataManager,
        routerViewModel: routerViewModel
    )
}

@main
struct SendoraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState() // Single source of truth
    @StateObject var imageCloudServices = ImageCloudServices()
    @Environment(\.scenePhase) var scenePhase
  @StateObject var chatsViewModel = ChatsViewModel(isTesting: true)
    @State var lastUpdate = Date()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState.routerViewModel)
                .environmentObject(appState.userViewModel)
                .environmentObject(imageCloudServices)
                .environmentObject(chatsViewModel)
                .task {
                    await appState.syncManager.initialize()
                }
                .onChange(of: scenePhase){
                    
                    if(Date.now.timeIntervalSince(lastUpdate) >= 5){
                    
                        appState.routerViewModel.isInitializing = true
                        appState.syncManager = SyncManager(userViewModel: appState.userViewModel, coreDataManager: appState.coreDataManager, routerViewModel: appState.routerViewModel)
                    }
                    lastUpdate = .now
                    
                }
        }
    }
}
