import Foundation
import Firebase
import FirebaseAuth
import SwiftDefaults
import GoogleSignIn
import GoogleSignInSwift



class AuthenticationServices: ObservableObject{
    static var shared = AuthenticationServices()
    
    //validation
    static func isValid(forPassword pass: String) throws(AuthError){
        
        guard pass.count >= 8 else { throw .weakPassword}
        guard pass.rangeOfCharacter(from: .decimalDigits) != nil else { throw .weakPassword}
        guard pass.rangeOfCharacter(from: .uppercaseLetters) != nil else { throw .weakPassword}
        guard pass.rangeOfCharacter(from: .lowercaseLetters) != nil else { throw .weakPassword}
        guard pass.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:'\",.<>?/`~")) != nil else {
            throw .weakPassword
        }
    }
    
    func signUpErrorHandler( Handler:  () async throws -> () ) async throws(AuthError){
        do{
            try await Handler()
        } catch AuthErrorCode.emailAlreadyInUse {
            throw AuthError.emailALreadyInUse
        } catch AuthErrorCode.invalidEmail {
            throw AuthError.invalidEmail
        } catch AuthError.verificationEmailSent {
            throw .verificationEmailSent
        } catch AuthError.weakPassword{
            throw .weakPassword
        }
        catch GIDSignInError.canceled{
            throw .cancelled
        } catch {
            throw .unknow
        }
    }
    
    
    // services
    func signUp(withEmail email: String, password: String, confirmationPassword confPass: String) async throws(AuthError){
        
        do{
            try await signUpErrorHandler{
                
                guard password == confPass else {
                    throw AuthError.invalidConfPassword
                }
                
                guard !password.isEmpty && !email.isEmpty && !confPass.isEmpty else {
                    throw AuthError.emptyField
                }
                
                
                do{

                    
                    try await DBServicesManager.shared.createUser()

                    try await sendVerificationEmail()
                    
                    throw AuthError.verificationEmailSent
                    
                }
                
            }
        } catch {
            throw error
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
        
    func signIn(withCredential credential: AuthCredential) async throws(AuthError) {
        
        
        do{
            let authData = try await Auth.auth().signIn(with: credential)
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
    
    func signInWithGoogle() async throws{
        
        guard let topVC = await getTopViewController() else { throw AuthError.unknow }
        do{
            try await signUpErrorHandler {
                
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
                
                guard let token = result.user.idToken?.tokenString else {throw AuthError.unknow}
                let accessToken = result.user.accessToken.tokenString
                
                let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: accessToken)
               
                
                try await signIn(withCredential: credential)
                
              if let user = Auth.auth().currentUser{
                
              } else {
                try await DBServicesManager.shared.createUser()
              }

                
                
            }
        } catch {
            print(error)
            throw error
        }
        
    }
    

}



