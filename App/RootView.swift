//
//  RootView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 28/07/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var coreDataManager: CoreDataManager
    @EnvironmentObject var syncManager: SyncManager

   
    
    var body: some View {
        if routerViewModel.isInitializing{
            LoadingView()
        } else {
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
        

    }
    
    





#Preview {
    RootView()
}
