//
//  RootView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 28/07/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject var routerViewModel = RouterViewModel()
    var body: some View {
        VStack{
            VStack{
                switch routerViewModel.selectedTab {
                case .signIn:
                    LoginView()
                        .transition(.push(from: .bottom))

                        
                case .signUp:
                    SignUpView()
                        .transition(.push(from: .bottom))

                case .entry:
                    StartingScreen()
                        .transition(.symbolEffect)

                case .home:
                    VStack{}
                    //
                }
            }
            .animation(.easeInOut(duration: 0.5))

            
        } .environmentObject(routerViewModel)

    }
}

#Preview {
    RootView()
}
