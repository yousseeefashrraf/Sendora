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
    
    
    func subscribe(userVM: UserViewModel, alertsVm: AlertsViewModel){
        $item.combineLatest($isUpdateOn)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (value, isUpdated) in
                Task{
                    
                    guard let self = self else {return}
                    do{
                       
                        if let data = try? await value?.loadTransferable(type: Data.self), let dbUser = userVM.dbUser{
                            
                            await MainActor.run{
                                self.image = UIImage(data: data)
                            }
                            
                            guard isUpdated else { return }
                            
                            let url = try await ImageCloudServices.shared.uploadImage(imageData: data)
                            print(url)
                            if let id = userVM.dbUser?.userId{
                                    await try userVM.updateUserProperty(keypath: \.profilePicture, newValue: url, forKey: UserModel.CodingKeys.profilePicture)
                                
                                
                            }
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
