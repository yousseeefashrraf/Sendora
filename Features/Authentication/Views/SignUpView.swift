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
  let type: AuthType = .signUp
  let slogan = "Simple chat. Seamless payments."
  
  var body: some View {
    VStack(spacing: -100){
      
      Image("community")
        .resizable()
        .scaledToFill()
        .frame(height: 350)
        .clipped()
        .frame(maxWidth: .infinity)
      
        .ignoresSafeArea()
      
      ZStack{
        Color.white
        
        
        VStack(alignment: .leading, spacing: 15){
          
          
          EmailTextField(email: $email)
          PasswordTextView(password: $password, includeForgotPass: false)
          PasswordTextView(password: $password, includeForgotPass: false, passType: .confPassword)
          
          
          ConfirmationButtonView(authType: type, color: .softPurple)
          
          
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
                    
          
          AnotherSignInMethodView(authType: type)
          
          Spacer()
          
        }
        .padding(.horizontal, 20)
        .padding(.top, 25)
        
        
        
        
        
      }
      .clipShape(RoundedRectangle(cornerRadius: 27))
      .ignoresSafeArea()
      
    }
    .background(.black)
    
  }
}



#Preview {
  SignUpView()
}
