import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
struct UserModel: Codable, Equatable, Hashable {
  var bio: String?
  var profilePicture: String?
  var userId: String?
  var username: String?
  var isNewUser: Bool
  var email: String?
  var lastUpdate: Date?
  
  init(bio: String?, profilePicture: String?, userId: String? = nil, username: String?, isNewUser: Bool, email: String?) {
    self.bio = bio
    self.profilePicture = profilePicture
    self.userId = userId
    self.username = username
    self.isNewUser = isNewUser
    self.email = email
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
    self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
    self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    self.username = try container.decodeIfPresent(String.self, forKey: .username)
    self.isNewUser = try container.decode(Bool.self, forKey: .isNewUser)
    self.email = try container.decodeIfPresent(String.self, forKey: .email)
    self.lastUpdate = try container.decodeIfPresent(Date.self, forKey: .lastUpdate)
  }
  
  
  
  enum CodingKeys: String,CodingKey{
    case bio = "bio", profilePicture = "profile_picture",userId="user_id",username = "username",
         isNewUser = "is_new_user", email = "email", lastUpdate = "last_update"
  }
  
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(self.bio, forKey: .bio)
    try container.encodeIfPresent(self.profilePicture, forKey: .profilePicture)
    try container.encode(self.userId, forKey: .userId)
    try container.encodeIfPresent(self.username, forKey: .username)
    try container.encode(self.isNewUser, forKey: .isNewUser)
    try container .encodeIfPresent(self.email, forKey: .email)
    try container.encodeIfPresent(self.lastUpdate, forKey: .lastUpdate)
  }
  
  
  
  
}

class UserViewModel: ObservableObject{
  @Published var dbUser: UserModel?
  var cancellables = Set<AnyCancellable>()
  
  @Published var authUser: User?
  private var handle: AuthStateDidChangeListenerHandle?
  
  init(){
    handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
      
      guard let self = self else { return }
      Task{
        await MainActor.run {
          self.authUser = user
        }
      }
    }
    
    $authUser
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] user in
        guard let self = self else { return }
        
        if user != nil {
          Task {
            try? await self.fetchDBUser()
          }
        } else {
          self.dbUser = nil
        }
      }
      .store(in: &cancellables)
    
    
    
  }
  
  @MainActor func fetchDBUser() async throws {
    guard dbUser == nil else { return }
    if let uid = Auth.auth().currentUser?.uid {
      do {
        let fetchedUser = try await DBServicesManager.shared.getDocument(
          collection: .users,
          documentId: uid,
          documentType: UserModel.self
        ) as? UserModel
        
        self.dbUser = fetchedUser
      } catch {
        print("Failed to fetch user: \(error)")
        throw error
      }
    }
  }
  
  @MainActor func setToOldUser(){
    Task{
      try? await updateUserProperty(keypath: \.isNewUser, newValue: false, forKey: UserModel.CodingKeys.isNewUser)
    }
  }
  
  @MainActor func updateUserProperty<T>(keypath: WritableKeyPath<UserModel, T>, newValue: T, forKey key: CodingKey) async throws{
    if var user = self.dbUser{
      user[keyPath: keypath] = newValue
      self.dbUser = user
      if let id = user.userId{
        
        do{
          try await DBServicesManager.shared.updateDocument(collection: .users, documentId: id, propertyToUpdate: key, newValue: newValue)
        } catch{
          throw AuthError.unknow // should be edited later
        }
        
      }
    }
    
  }
  
  deinit {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }
}


