
import Foundation
import SwiftUI
import SwiftDefaults

enum HomeTab: Int ,CaseIterable{

    
    case chat = 0, calls,stories, settings
    
    var details: (label: String, image: String) {
        switch self {
        case .chat:
            return ("Chats", "ellipsis.bubble.fill")
        case .calls:
            return ("Calls", "phone.fill")
        case .stories:
            return ("Stories", "circle.circle")
        case .settings:
            return ("Settings", "gear.circle")
        }
    }
}


enum RouterTab: Hashable {
    case signIn, signUp, entry, info, signUpInfo
    case home(HomeTab)
}


enum Editors: String{
    case nameEditor, bioEditor
}
enum SheetTab: Hashable, Identifiable {    
    case editorSheet(Editors)
    var id: String {
        
        if case let .editorSheet(editors) = self {
            return "SheetId_\(editors.rawValue)"

        }
        
        return "unknown"
        }
}


enum UserType:String, DefaultValue{
    typealias DefaultType = UserType
    
    case newUser = "newUser", currentUser = "currentUser"
    static var key: String { "UserType" }
    static var defaultValue: UserType { .newUser }
}



class RouterViewModel: ObservableObject{
    @Published var selectedTab: RouterTab
    @Published var path = NavigationPath()
    @Published var activeSheet: SheetTab?
    @Published var isInitializing: Bool = true
    @Published var homeIndex: Int?
  
    init(){
        UserDefaultsManager.shared.initiate(forType: UserType.self)
        
        let value = UserDefaultsManager.shared.getStoredValue(forType: UserType.self)
        
      selectedTab = UserType(rawValue: value ?? "") != nil ? .entry : .home(.chat)
        
    }
    
    func pushToNavigation(_ tab: RouterTab){
        path.append(tab)
    }
    

    func routeToInfo(){
        selectedTab = .info
    }
    func routeToSignUpInfo(){
        selectedTab = .signUpInfo
    }
    func routeToSignUp (){
        selectedTab = .signUp
    }
    
    func routeToSignIn (){
        selectedTab = .signIn
    }
    
    func routeToHome(){
      selectedTab = .home(.chat)
    }
    
    func routeToEntry(){
        selectedTab = .entry
    }
    
    
}

