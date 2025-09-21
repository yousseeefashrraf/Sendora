//
//  ChatsView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 19/09/2025.
//

import SwiftUI

struct ChatsView: View {
//  @EnvironmentObject var chatsViewModel: ChatsViewModel
  @StateObject var chatsViewModel = ChatsViewModel(isTesting: true)


  var body: some View {
    VStack{
      NavigationStack{
        
        List($chatsViewModel.chats) { chat in
          let content = chatsViewModel.messages[chat.id.wrappedValue ?? ""]?.last
          
          ChatListView(chat: chat, lastMessage: content)
        }
        .listStyle(.inset)
        .frame(maxWidth: .infinity)
        
        .navigationTitle("Chats")
      }
      
    }
  }
}

struct ChatListView: View {
  @Binding var chat: ChatModel
  var lastMessage: MessageModel?
//  @EnvironmentObject var userViewModel: UserViewModel
  var body: some View {
    let colors: [Color] = [.red, .green, .orange, .blue, .purple]
    HStack{
      let colorSelection = chat.id.hashValue % 5
      ProfileImageView(size: 60, uiImage: nil, color: colors[colorSelection])
      
      VStack(alignment: .leading){
        Text("Name")
          .bold()
        HStack{
          
      
        Text("\(lastMessage?.content.isImage == true ? "Image 🏞️" :  lastMessage?.content.content ?? "Start Chatting")")
          
        Spacer()
        if let message = lastMessage{
          Text(message.getAbstractedTime())
        }
        
      }
        .opacity(0.7)
      }
    }
    
    
  }
}

#Preview {
  ChatsView()
}
