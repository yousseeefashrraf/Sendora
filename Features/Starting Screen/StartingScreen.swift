//
//  StartingScreen.swift
//  Sendora
//
//  Created by Youssef Ashraf on 26/07/2025.
//

import SwiftUI

struct StartingScreen: View {
    
    let slogan = "Simple chat. Seamless payments."
    
    var body: some View {
        
        ZStack{
            
            Image("Starting")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            LinearGradient(colors: [.black, .clear, .black], startPoint: .top, endPoint: .bottom)
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack{
                Text("Sendora")
                    .foregroundStyle(Color.glassWhite)
                    .font(.system(.largeTitle, design: .monospaced))
                    .bold()
                
                
                Text("\(slogan)")
                    .foregroundStyle(Color.background)
                    .font(.system(.headline, design: .monospaced))
                
                Spacer()
                StartingInfoScreen()
                
            }
            .padding(.top, 30)

            
            
        }
        
        
        
    }
}

struct StartingInfoScreen: View{
    
    
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.background)
            
            VStack(alignment: .leading){
                Text("Smarter Conversations, Seamless Transfers.")
                    .font(.system(.title3, design: .rounded))                            .bold()
                
                Text("Sendora is a modern messaging app that lets you chat, share images, and send money—all in one encrypted, AI-enhanced experience.")
                    .font(.system(.title3,design: .rounded))
                    .padding(.top,1)
                
                ButtonView(label: "Get Started") {
                    // Route to next screen
                }
                    
                
                
                Spacer()
                
            }
            .foregroundStyle(Color.darkGreen)
            
            .padding(30)
            
        }
        
        
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: 290)
        .padding(.horizontal,85)
        
    }
    
}

struct ButtonView: View{
    @EnvironmentObject var routerViewModel: RouterViewModel
    let label: String
    let action: ()->()
    var body: some View{
        Button {
            routerViewModel.routeToSignUp()
            
        } label: {
            HStack{
                Spacer()
                Text("\(label)")
                Spacer()
                
                Image(systemName: "arrow.forward")
                
                    .padding(10)
                    .background(Color.slateGray.opacity(0.5))
                    .clipShape(Circle())
            }
            .foregroundStyle(Color.darkGreen)
            .frame(maxWidth: .infinity)
            .frame(height: 35)
            .padding(10)
            .padding(.leading, 20)
            .background(Color.glassWhite)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            
        }
    }
}

#Preview {
    StartingScreen()
}
