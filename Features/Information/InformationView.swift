//
//  InformationView.swift
//  Sendora
//
//  Created by Youssef Ashraf on 29/07/2025.
//

import SwiftUI
import Foundation
import PhotosUI

enum InformationTabs{
    case name, bio, email, profilePicture
}

enum PhotoPickerSaveOn{
    case onSubmit, onSelect
}

struct EditorView: View{
    var sectionName: String
    var keyPath: WritableKeyPath<UserModel, String?>
    @State var text = ""
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var routerViewModel: RouterViewModel
    @Environment(\.dismiss) var dismiss
    var key: CodingKey
    var body: some View{
        
        ZStack{
            Color.black
                .opacity(0.08)
                .ignoresSafeArea()
            
            VStack(alignment: .leading){
                
                HStack{
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                        
                    }
                    
                    
                    Spacer()
                    Button {
                        if(!text.isEmpty){
                            Task{
                                do{
                                    try await userViewModel.updateUserProperty(keypath: keyPath, newValue: text, forKey: key)
                                } catch{
                                    //use alert model here
                                }
                            }
                           
                           
                            dismiss.callAsFunction()
                        }
                    } label: {
                        Text("Save")
                            .foregroundStyle(.blue.opacity(text.isEmpty ? 0.8 : 1))
                            
                         
                        
                    }
                    .disabled(text.isEmpty)

                }
                
                Section(sectionName) {
                    
                GlassyEffectView {
                    VStack{
                        TextField("", text: $text)
                            .padding(4)
                           
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .opacity(0.5)
                
                    
                   
                   
                }
                Text("Your \(sectionName.lowercased()) will be public for everyone to see.")
                    .padding(.top, 10)
                
                Spacer()
              
                
            }
            .foregroundStyle(.black.opacity(0.6))
            .padding()
            
        }
        .onAppear{
            text = userViewModel.dbUser?[keyPath: keyPath] ?? ""
        }
        
        
        
    }
}

struct GlassyEffectView<Content: View>: View{
    
    let content: () -> Content
    
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
            
                .fill(.white)
                .opacity(0.7)
                .shadow(color: .glassWhite,radius: 10.0)
            
            content()
        }
    }
}

struct EditorPreviewView: View{
    var sectionName: String
    var isEditable: Bool = true
    var keyPath: WritableKeyPath<UserModel, String?>
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View{
        
        
        let text = userViewModel.dbUser?[keyPath: keyPath] ?? "No \(sectionName.lowercased()) yet."
        
        VStack(alignment: .leading){
            Section(sectionName) {
                GlassyEffectView{
                    HStack(){
                        Text("\(text)")
                            .padding()
                        if (isEditable){
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .padding(20)
                                .blur(radius: 0.6)
                            
                            
                        }
                        
                    }
                   
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 57)
                .background(.ultraThinMaterial)
                .foregroundStyle(.gray.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            
            
        }
        
    }
}

struct ProfileImageView: View{
    var size: CGFloat
    var uiImage: UIImage?
  var color = Color.blue
    var body: some View{
        
            ZStack{
              color
                    .opacity(0.7)
                    .blur(radius: 20)
                GlassyEffectView{
                    VStack{

                        if let uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                                .foregroundStyle(color.opacity(0.2))
                                
                        }
                        
                    }
                    
                    
                    
                }
                .background(.thickMaterial)
                .blur(radius: 0.1)
                
            }
            
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(color: .white,radius: 2)}
        

    
}

struct SignUpInformationView: View{
    @StateObject var photosPickerViewModel = PhotosPickerViewModel()
    @StateObject var alertsViewModel = AlertsViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var imageCloudServices: ImageCloudServices

    var body: some View{
        
        let dbUser = userViewModel.dbUser
        let isReady =
        (!(userViewModel.dbUser?.bio?.isEmpty ?? true)) &&
        (!(userViewModel.dbUser?.username?.isEmpty ?? true)) &&
        ((((userViewModel.dbUser?.profilePicture != nil)) &&
          ((userViewModel.dbUser?.profilePicture != ""))) || photosPickerViewModel.item != nil)
        ZStack{
            Color.black
                .opacity(0.08)
                .ignoresSafeArea()
            
            VStack{
                InformationView(alertsViewModel: alertsViewModel,photosPickerViewModel: photosPickerViewModel, saveOn: .onSubmit)
                
                
                
                Button(){
                    photosPickerViewModel.isUpdateOn = true
                } label:{
                    ZStack{
                        Color(.blue)
                        
                        Text("Continue")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 65)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(isReady ? 1 : 0.5)
                }
                .disabled(!isReady)
                
                
                
                .foregroundStyle(.white)
                
                
            }
            .padding()
            .padding(.top, 20)
            
            
            
            
            
            ImageLoadingView(loadingPercentage: imageCloudServices.progress)
                .blur(radius: imageCloudServices.progress == 1 ? 40 : 0)
            
        }
    }
           


            
}

struct InformationView: View {
    @ObservedObject var alertsViewModel: AlertsViewModel
    @EnvironmentObject var routerViewModel: RouterViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var photosPickerViewModel: PhotosPickerViewModel
    @EnvironmentObject var imageCloudServices: ImageCloudServices
    @State var uiProfilePic: UIImage?
    var saveOn: PhotoPickerSaveOn
    var body: some View {
          
            VStack(alignment: .center,spacing: 25){
                PhotosPicker(selection: $photosPickerViewModel.item) {
                    
                    VStack(spacing: 15){
                        
                        ProfileImageView(size: 125,uiImage: photosPickerViewModel.image ?? uiProfilePic)
                            .task {
                               let image = await CacheManagerServices.shared.getProfileImage(forString: userViewModel.dbUser?.profilePicture ?? "")
                                await MainActor.run {
                                    uiProfilePic = image
                                    
                                   
                                   
                                }
                                
                            }
                        Text("Choose Picture")
                    }
                }
               

                
               
                    .foregroundStyle(.black.opacity(0.25))
                EditorPreviewView(sectionName: "Name", keyPath: \.username)
                    .onTapGesture {
                        routerViewModel.activeSheet = .editorSheet(.nameEditor)
                    }
                EditorPreviewView(sectionName: "Bio",keyPath:  \.bio)
                    .onTapGesture {
                        routerViewModel.activeSheet = .editorSheet(.bioEditor)
                    }
                EditorPreviewView(sectionName: "Email", keyPath:  \.email)
                
                Spacer()
                
            }
          
        
        .onAppear {
            if photosPickerViewModel.item == nil{
                photosPickerViewModel.subscribe(userVM: userViewModel, alertsVm: alertsViewModel, imageCloudServices: imageCloudServices)
            }
            }
        
    }
}



#Preview {
    
    
    SignUpInformationView()
        .environmentObject(UserViewModel())
        .environmentObject(RouterViewModel())
}
