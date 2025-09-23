//
//  HomeScreen.swift
//  Sendora
//
//  Created by Youssef Ashraf on 21/09/2025.
//

import SwiftUI



struct HomeScreenTabView: View {
  @EnvironmentObject var router: RouterViewModel
  var body: some View {
    if case .home(_) = router.selectedTab {
      TabView(selection: $router.homeIndex) {
        
        ForEach(HomeTab.allCases, id: \.rawValue) { tab in
          Tab(value: tab.rawValue) {
            ChatsView()
          } label: {
            VStack{
              Image(systemName: tab.details.image)
              
              
            }
        }
        
        
   
       
        }
 
      }
      .tint(.green.opacity(0.8))
      

    }
    }
}


#Preview {

  HomeScreenTabView()

    
}
