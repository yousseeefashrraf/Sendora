import Foundation
import SwiftUI
import PhotosUI
import Combine

class PhotosPickerViewModel: ObservableObject{
    @Published var image: UIImage?
    @Published var item: PhotosPickerItem?
    @Published var isUpdateOn: Bool = false
    var cancellables = Set<AnyCancellable>()
    init(){
        
    }
    
    
    func subscribe(userVM: UserViewModel, alertsVm: AlertsViewModel, imageCloudServices: ImageCloudServices){
        $item.combineLatest($isUpdateOn)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (value, isUpdated) in
                Task{
                    
                    guard let self = self else {return}
                    do{
                       
                        if let data = try? await value?.loadTransferable(type: Data.self), let _ = userVM.dbUser{
                            
                            await MainActor.run{
                                let compressed = UIImage(data: data)?.jpegData(compressionQuality: 0.6) ?? data
                                self.image = UIImage(data: compressed)
                            }
                            
                            guard isUpdated else { return }
                            
                            
                            let url = try await imageCloudServices.uploadImage(imageData: data)
                            
                            
                            
                            if (userVM.dbUser?.userId) != nil{
                                try await userVM.updateUserProperty(keypath: \.profilePicture, newValue: url, forKey: UserModel.CodingKeys.profilePicture)
                            }
                            
                            await MainActor.run{
                                imageCloudServices.markAsComplete()
                            }
                            try? await Task.sleep(nanoseconds: 1000_500_000)
                                imageCloudServices.updateProgress(newValue: 0, animation: .easeInOut(duration: 0))
                            
                            await MainActor.run{
                                self.item = nil
                                self.isUpdateOn = false
                            }
                            
                          
                            self.cancellables.removeAll()
                            
                            
                            
                        }
                        
                    } catch {
                        if let alert = error as? UploadError {
                            await alertsVm.configureAnAlert(alert: .upload(alert))
                        }
                        
                    }
                    
                }
            }
            .store(in: &cancellables)
        
    }
    
    
}
