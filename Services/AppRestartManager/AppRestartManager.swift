import Foundation

import SwiftUI


// sync manager needs to be notified through notificatio center to redirect the user, this will reset 
class AppRestartManager: ObservableObject {
    static let shared = AppRestartManager()
    
    @Published var shouldRestart = false
    private var lastRestartCheck = Date()
    
    private init() {
        
    }
    
}
