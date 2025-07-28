
import SwiftUI
import Foundation

@MainActor
class AlertsViewModel: ObservableObject{
   @Published  var appAlert: AppAlert?
  @Published var id = UUID()
  func configureAnAlert(alert: AppAlert){
    
      
      appAlert = alert
      
    
    Task{ [weak self] in
      
      try await Task.sleep(nanoseconds: 5 * 1000_000_000)
      
      
          self?.appAlert = nil
        
      
    }
  }
  
  func isAlertValid() -> Bool{
    guard let appAlert = appAlert else { return false }
    switch appAlert {
    case .auth(.verificationEmailSent): return true
    default : return false
    }
  }
  
  
  
}
