
import Foundation
import Firebase
import FirebaseAuth
import SwiftDefaults



class AuthenticationServices: ObservableObject{
    static var shared = AuthenticationServices()
    
    init(){}
    //validation
    static func isValid(forPassword pass: String) -> Bool{
        
        guard pass.count >= 8 else {return false}
        guard pass.rangeOfCharacter(from: .decimalDigits) != nil else {return false}
        guard pass.rangeOfCharacter(from: .uppercaseLetters) != nil else {return false}
        guard pass.rangeOfCharacter(from: .lowercaseLetters) != nil else {return false}
        guard pass.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:'\",.<>?/`~")) != nil else {
            return false
        }
        
        
        
        
        
        return true
    }
    
    // services
    func signUp(withEmail email: String, password: String, confirmationPassword confPass: String) async throws(AuthError){
        
        guard password == confPass else {
            throw AuthError.invalidConfPassword
        }
        
        guard !password.isEmpty && !email.isEmpty && !confPass.isEmpty else {
            throw AuthError.emptyField
        }
        
        
        do{
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            
            try await sendVerificationEmail()
            
            throw AuthError.verificationEmailSent
            
        } catch AuthErrorCode.emailAlreadyInUse {
            throw AuthError.emailALreadyInUse
        } catch AuthErrorCode.invalidEmail {
            throw AuthError.invalidEmail
        } catch AuthError.verificationEmailSent {
            throw .verificationEmailSent
        } catch {
            guard AuthenticationServices.isValid(forPassword: password) else {
                throw AuthError.weakPassword
            }
            
            print (error.localizedDescription)
            throw AuthError.unknow
        }
        
     

        
        
        
    }
    
    func signIn(withEmail email: String, password: String) async throws(AuthError) {
        
        
        do{
            let authData = try await Auth.auth().signIn(withEmail: email, password: password)
            if !authData.user.isEmailVerified{
                try Auth.auth().signOut()
                throw AuthError.needsVerification
            }
            UserDefaultsManager.shared.store(forType: UserType.self, value: UserType.currentUser.rawValue)

        } catch AuthErrorCode.wrongPassword{
            throw .wrongPassword
        } catch AuthError.needsVerification {
            throw .needsVerification
        } catch {
            throw .wrongEmailOrPass
        }
        
        
    }
    
    func sendVerificationEmail() async throws(AuthError){
        do {
            try await Auth.auth().currentUser?.sendEmailVerification()
            try Auth.auth().signOut()
        } catch{
            throw AuthError.unknow
        }
    }
    
}



