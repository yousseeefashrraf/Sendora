//
//  SendoraTests.swift
//  SendoraTests
//
//  Created by Youssef Ashraf on 26/07/2025.
//

import XCTest
@testable import Sendora

final class SendoraTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

final class EmailTestAuh: XCTestCase{
    let email = "yousseeefashraf@gmail.com"
    let pass = "12@Y.com"
    
    func testSignUp() async{

        
        let expected = AuthError.verificationEmailSent
        
        
        do{
             try await AuthenticationServices.shared.signUp(withEmail: email, password: pass, confirmationPassword: pass)
        } catch{
            var result = error
            XCTAssertEqual(result as! AuthError, expected)

        }
       
    }
    
    func testSendEmail() async {
        do{
            try await AuthenticationServices.shared.sendVerificationEmail()
        } catch{
            XCTFail()
        }
    }
    
    func testIfUserCanLoginWithoutVerification() async{
        let email = "yousseeefashraf@gmail.com"
        let pass = "12@Y.com"
        
        let expected = AuthError.needsVerification
        
        
        let _ =  try? await AuthenticationServices.shared.signUp(withEmail: email, password: pass, confirmationPassword: pass)
        
        
        do {
            try await AuthenticationServices.shared.signIn(withEmail: email, password: pass)
        } catch{
            let result = error
            XCTAssertEqual(result , expected)
            
        }
    }
        
    
    func testIfUserCanLoginAfterVerification() async {
        let email = "yousseeefashraf@gmail.com"
        let pass = "12@Y.com"
        
        do {
            try await AuthenticationServices.shared.signIn(withEmail: email, password: pass)
         

        } catch{
            XCTFail()

        }
        
    }

        
    }
    
final class GoogleTestAuh: XCTestCase{
    let email = "yousseeefashraf@gmail.com"
    let pass = "12@Y.com"
    
    func testSignUp() async{

        
        let expected = AuthError.verificationEmailSent
        
        
        do{
             try await AuthenticationServices.shared.signUp(withEmail: email, password: pass, confirmationPassword: pass)
        } catch{
            var result = error
            XCTAssertEqual(result as! AuthError, expected)

        }
       
    }
    
    func testSendEmail() async {
        do{
            try await AuthenticationServices.shared.sendVerificationEmail()
        } catch{
            XCTFail()
        }
    }
    
    func testIfUserCanLoginWithoutVerification() async{
        let email = "yousseeefashraf@gmail.com"
        let pass = "12@Y.com"
        
        let expected = AuthError.needsVerification
        
        
        let _ =  try? await AuthenticationServices.shared.signUp(withEmail: email, password: pass, confirmationPassword: pass)
        
        
        do {
            try await AuthenticationServices.shared.signIn(withEmail: email, password: pass)
        } catch{
            let result = error
            XCTAssertEqual(result , expected)
            
        }
    }
        
    
    func testIfUserCanLoginAfterVerification() async {
        let email = "yousseeefashraf@gmail.com"
        let pass = "12@Y.com"
        
        do {
            try await AuthenticationServices.shared.signIn(withEmail: email, password: pass)
         

        } catch{
            XCTFail()

        }
        
    }

        
    }


    

