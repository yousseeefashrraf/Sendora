//
//  ChatsView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 19/09/2025.
//

import SwiftUI

struct ChatsView: View {
//  @EnvironmentObject var chatsViewModel: ChatsViewModel
  @StateObject var chatsViewModel = ChatsViewModel()
  @EnvironmentObject var userViewModel: UserViewModel
  @EnvironmentObject var coreDataManager: CoreDataManager


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
    .environmentObject(chatsViewModel)
    .onAppear{
      chatsViewModel.getChatsAndUseres(userVm: userViewModel, coreManager: coreDataManager)
      
    }
  }
}

struct ChatListView: View {
  @Binding var chat: ChatModel
  var lastMessage: MessageModel?
  @EnvironmentObject var userViewModel: UserViewModel
  @EnvironmentObject var chatsViewModel: ChatsViewModel
  @State var image: UIImage?
  @State var name: String?

//  @EnvironmentObject var userViewModel: UserViewModel
  var body: some View {
    let colors: [Color] = [.red, .green, .orange, .blue, .purple]
    HStack{
      let colorSelection = (chat.id?.first?.wholeNumberValue ?? 0)
      % colors.count
      ProfileImageView(size: 60, uiImage: image, color: colors[colorSelection])
      
      VStack(alignment: .leading){
        Text("\(name ?? "Unknown")")
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
    .task {
      if let userId = userViewModel.dbUser?.userId, chat.participantsIds.count == 2 {
        let userIdIndex = chat.participantsIds.firstIndex(of: userId) ?? 0
        let reciverId = chat.participantsIds[1-userIdIndex]
        let reciver = chatsViewModel.fetchedUsers.filter { $0.userId == reciverId }
        name = reciver.first?.username
        image = await reciver.isEmpty ? nil : CacheManagerServices.shared.getProfileImage(forString: reciver.first?.profilePicture ?? "")

      }
    }
    
  }
}

#Preview {
  ChatsView()
}
