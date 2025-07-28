import SwiftUI


struct LoginView: View {
  @State var email = ""
  @State var password = ""
  @StateObject var alertsViewModel = AlertsViewModel()
  @EnvironmentObject var routerViewModel: RouterViewModel
  let slogan = "Simple chat. Seamless payments."
  
  var body: some View {
    ZStack(alignment: .bottom){
      
      
      VStack(spacing: -40){
        
        Image("auth")
          .resizable()
          .scaledToFill()
          .frame(height: 350)
          .clipped()
          .frame(maxWidth: .infinity)
      
        ZStack{
          Color.white
          
          VStack(alignment: .leading, spacing: 20){
            
            
            EmailTextField(email: $email)
            PasswordTextView(password: $password)
            
            
            
            
            ConfirmationButtonView(authType: .signIn, color: .softPurple)
              .onTapGesture {
                Task{
                  do{
                    try await AuthenticationServices.shared.signIn(withEmail: email, password: password)
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
      .padding(.bottom, 40)
      
      
    }
  }
}




#Preview {
  LoginView()
}
