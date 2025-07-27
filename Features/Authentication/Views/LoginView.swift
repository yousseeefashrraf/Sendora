import SwiftUI


struct LoginView: View {
  @State var email = ""
  @State var password = ""
  let slogan = "Simple chat. Seamless payments."
  
  var body: some View {
    VStack(spacing: -40){
      
      Image("auth")
        .resizable()
        .scaledToFill()
        .frame(height: 350)
        .clipped()
        .frame(maxWidth: .infinity)
      
        .ignoresSafeArea()
      
      ZStack{
        Color.white
        
        VStack(alignment: .leading, spacing: 20){
          
          
          EmailTextField(email: $email)
          PasswordTextView(password: $password)
          
          
          
          
          ConfirmationButtonView(authType: .signIn, color: .softPurple)
          
          
          SwitchAuthView(authType: .signIn)
          
        
          
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
          
          Spacer()

          
          AnotherSignInMethodView(authType: .signIn)
          
          Spacer()
          
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
  LoginView()
}
