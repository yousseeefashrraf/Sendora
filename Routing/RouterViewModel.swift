
import Foundation
import SwiftUI
import SwiftDefaults

enum Tab {
    case signIn, signUp, entry, home
}



enum UserType:String, DefaultValue{
    typealias DefaultType = UserType
    
    case newUser = "newUser", currentUser = "currentUser"
    static var key: String { "UserType" }
    static var defaultValue: UserType { .newUser }
}



class RouterViewModel: ObservableObject{
    @Published var selectedTab: Tab
    
    init(){
        UserDefaultsManager.shared.initiate(forType: UserType.self)
        
        let value = UserDefaultsManager.shared.getStoredValue(forType: UserType.self)
        
        selectedTab = UserType(rawValue: value ?? "") != nil ? .entry : .home
        
    }
    
    func routeToSignUp (){
        selectedTab = .signUp
    }
    
    func routeToSignIn (){
        selectedTab = .signIn
    }
    
    func routeToHome(){
        selectedTab = .home
    }
    
    func routeToEntry(){
        selectedTab = .entry
    }
    
    
}

