//
//  SignUpView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 27/07/2025.
//

import SwiftUI



struct SignUpView: View {
  @State var email = ""
  @State var password = ""
  @State var confirmationPassword = ""
  @StateObject var alertsViewModel = AlertsViewModel()
  @EnvironmentObject var routerViewModel: RouterViewModel
  let type: AuthType = .signUp
  let slogan = "Simple chat. Seamless payments."
  
  var body: some View {
    ZStack(alignment: .bottom){
      VStack(spacing: -40){
        
        Image("community")
          .resizable()
          .scaledToFill()
          .frame(height: 350)
          .clipped()
          .frame(maxWidth: .infinity)
                
        ZStack{
          Color.white
          
          
          VStack(alignment: .leading, spacing: 15){
            
            
            EmailTextField(email: $email)
            PasswordTextView(password: $password, includeForgotPass: false)
            PasswordTextView(password: $confirmationPassword, includeForgotPass: false, passType: .confPassword)
            
            
            ConfirmationButtonView(authType: type, color: .softPurple)
              .onTapGesture {
                Task{
                  do{
                    try await AuthenticationServices.shared.signUp(withEmail: email, password: password, confirmationPassword: confirmationPassword)
                    Task{
                      try await Task.sleep(nanoseconds: 2_000_000_000)
                      routerViewModel.routeToSignIn()

                    }
                  } catch {
                    if let error = error as? AuthError{
                      let alert: AppAlert = .auth(error)
                      alertsViewModel.configureAnAlert(alert:  alert)
                      
                    }
                    
                  }
                  
                }
                
              }
            
            
            SwitchAuthView(authType: type)
            
            
            
            HStack(alignment: .center){
              let height = 2.0
              Rectangle()
                .frame(height: height)
                .opacity(0.5)
              
              Text("or")
              
              Rectangle()
                .frame(height: height)
                .opacity(0.5)
              
            }
            .frame(height: 15)
            .clipped()
            .foregroundStyle(Color.background)
            
            
            AnotherSignInMethodView(authType: type, alertsViewModel: alertsViewModel)
              .padding(.bottom, 60)

            Spacer()
            
          }
          .padding(.horizontal, 20)
          .padding(.top, 25)
          
          
          
          
          
        }
        .clipShape(RoundedRectangle(cornerRadius: 27))
        .ignoresSafeArea()
        
      }
      .background(.black)
      
      
      VStack{
        if case let .auth(alert) = alertsViewModel.appAlert {
          AlertView(error: alert,
                       isShown:  .init(get: {
            if alertsViewModel.appAlert != nil{
              return true
            } else {
              return false
            }
          }, set: { value in
            if !value{
              
              alertsViewModel.appAlert = nil
            }
            
          }),  isAlertValid: alertsViewModel.isAlertValid() )
          .transition(.blurReplace)

          
          
        }
         

      }
      .animation(.bouncy.speed(0.6))
      .padding(.bottom, 80)

      
      
    }
    .ignoresSafeArea()
    
    
  }
}



#Preview {
  SignUpView()
}
