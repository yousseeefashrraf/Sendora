//
//  SendoraApp.swift
//  Sendora
//
//  Created by Youssef Ashraf on 26/07/2025.
//

import SwiftUI

@main
struct SendoraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
