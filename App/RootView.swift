//
//  RootView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 28/07/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject var routerViewModel: RouterViewModel
    @StateObject var userViewModel: UserViewModel
    private var coordinator: UserRouterCoordinator
    
    init(){
        let router = RouterViewModel()
        let userVM = UserViewModel()
        self._routerViewModel = StateObject(wrappedValue: router)
        self._userViewModel = StateObject(wrappedValue: userVM)
        self.coordinator = UserRouterCoordinator(userVM: userVM, routerVM: router)
        
    }
    
    var body: some View {
        ZStack {
            if routerViewModel.selectedTab == .home {
                VStack{}
                    .transition(.move(edge: .top))
            }

            if routerViewModel.selectedTab == .entry {
                StartingScreen()
                    .transition(.opacity)


            }

            if routerViewModel.selectedTab == .signIn {
                LoginView()
                    .transition(.blurReplace)

            }
            
            if routerViewModel.selectedTab == .signUp {
                SignUpView()
                    .transition(.blurReplace)
            }
            
            if routerViewModel.selectedTab == .signUpInfo {
                SignUpInformationView()
                    .transition(.blurReplace)
            }

        }
        .animation(.easeInOut(duration: 0.5), value: routerViewModel.selectedTab)
        .environmentObject(routerViewModel)
        .environmentObject(userViewModel)
        .sheet(item: $routerViewModel.activeSheet){ tab in
            if case .editorSheet(let editor) = tab {
                switch editor{
                    
                case .bioEditor:
                    EditorView(sectionName: "Bio", keyPath: \.bio, key: UserModel.CodingKeys.bio)
                        .environmentObject(routerViewModel)
                                        .environmentObject(userViewModel)
                case .nameEditor:
                    
                    EditorView(sectionName: "Name", keyPath: \.username, key: UserModel.CodingKeys.username)
                        .environmentObject(routerViewModel)
                                        .environmentObject(userViewModel)
                    
                    
                }
            }
        }
        
    }
        

    }
    
    





#Preview {
    RootView()
}
