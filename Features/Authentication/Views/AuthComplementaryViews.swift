//
//  AuthComplementaryViews.swift
//  Sendora
//
//  Created by Youssef Ashraf on 27/07/2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct SwitchAuthView: View{
    @EnvironmentObject var routerViewModel: RouterViewModel

  var authType: AuthType
  var body: some View{
    HStack{
      if authType == .signIn {
        Text("Don't Have An Account?")
        Text("Sign Up")
          .bold()
          .onTapGesture {
              routerViewModel.routeToSignUp()
          }
      } else {
        Text("Already Have An Account?")
        Text("Sign In")
              .onTapGesture {
                  routerViewModel.routeToSignIn()
              }
          .bold()
      }
    
        
    }
    .frame(maxWidth: .infinity, maxHeight: 15,alignment: .center)
    .font(.callout)
    .foregroundStyle(.black)
    
  }
}

struct EmailTextField: View{
  @Binding var email: String
  var body: some View{
    VStack(alignment: .leading, spacing: 15){
      
      Text("Email")
        .foregroundStyle(Color.background)
      ZStack(alignment: .leading){
        if email == "" {
          Text(verbatim: "Placeholder@gmail.com")
          
            .foregroundStyle(.white)
            .animation(.spring)
            .opacity(0.5)
        }
        
        TextField("", text: $email)
          .accentColor(.slateGray)
          .textInputAutocapitalization(.never)
          .keyboardType(.emailAddress)

        
      }
      .foregroundStyle(.white)
      .frame(height: 65)
      .padding(.horizontal, 20)            .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      
    }
  }
}

struct PasswordTextView: View{
  @Binding var password: String
  @State var isPassShown = false
  var includeForgotPass = true
  var passType: PasswordType = .password
  var body: some View{
    VStack(alignment: .leading, spacing: 15){
      
      Text("\(passType.rawValue)")
        .foregroundStyle(Color.background)
      
      HStack{
        ZStack(alignment: .leading){
          if password == "" {
            Text(verbatim: passType == .password ?  "Enter Your Password" : "Confirm Your Password")
              .foregroundStyle(.white)
            
              .opacity(0.5)
          }
          
          if isPassShown{
            TextField("", text: $password)
              .accentColor(.slateGray)
              .textInputAutocapitalization(.never)

          } else {
            SecureField("", text: $password)
              .accentColor(.slateGray)
              .textInputAutocapitalization(.never)

            
          }
          
          
        }
        
        Image(systemName: isPassShown ? "eye.slash.fill" : "eye.fill" )
          .onTapGesture {
            withAnimation(.bouncy.speed(1)) {
              isPassShown.toggle()
              
            }
          }
      }
      .foregroundStyle(.white)
      .frame(height: 65)
      .padding(.horizontal, 20)
      .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      
      
      if includeForgotPass {
        Text("Forgot Password?")
          .foregroundStyle(Color.electricBlue)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .font(.callout)
      }
     
      
      
    }
  }
}


struct ConfirmationButtonView: View{
  var authType: AuthType
  var color: Color = Color.electricBlue
  var body: some View {
    ZStack(alignment: .leading){
      
      Text("\(authType.rawValue)")
        .foregroundStyle(.white)
        .opacity(0.9)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding(.horizontal, 25)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 35))
      
      
    }
    
  }
}

struct AnotherSignInMethodView: View{
  
  var authType: AuthType
    @ObservedObject var alertsViewModel: AlertsViewModel
  var body: some View{
    HStack{
      Spacer()
      
      HStack{
        
        Image("G")
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)
       
      }
      .padding(20)
      .background(Color.background)
      .clipShape(RoundedRectangle(cornerRadius: 35))
      .onTapGesture {
          Task{
              do{
                  try await AuthenticationServices.shared.signInWithGoogle()
              } catch {
                  if let error = error as? AuthError{
                      alertsViewModel.configureAnAlert(alert: .auth(error))
                  }
                  
              }
              
          }
          
      }
      Spacer()
      
      SignInWithAppleButton(authType == .signIn ? .signIn : .signUp,onRequest: { _ in }, onCompletion: { _ in })
        .signInWithAppleButtonStyle(.black)
        .frame(height: 60)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 35))
      
        .onTapGesture {
          print("Apple Sign In tapped - not implemented yet")
        }
      
      Spacer()
      
    }
  }
}

#Preview {
}
