import Foundation
import SwiftUI
import Cloudinary
import Combine

class ImageCloudServices: NSObject,ObservableObject{
   
    let cloudinary: CLDCloudinary
    @Published var progress = 0.0
    override init(){
        
        let config = CLDConfiguration(cloudName: "dcznvee1s", secure: true)
        self.cloudinary = CLDCloudinary(configuration: config)
        super.init()
    }
    
    func updateProgress(newValue: Double,animation: Animation = .spring){
        Task{
            await MainActor.run { [weak self] in
            withAnimation(animation) {
                    self?.progress =  newValue
                }

            }
        }
    }
    func uploadImage(imageData: Data) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            cloudinary.createUploader().upload(
                data: imageData,
                uploadPreset: "ios_upload", progress: { [weak self] progress in
                    
                    self?.updateProgress(newValue: max(0, progress.fractionCompleted - 0.05))
                    
                    
                }, completionHandler:  {[weak self] result, error in
                    if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        continuation.resume(throwing: UploadError.image)
                    } else if let url = result?.secureUrl {
                        print("Upload succeeded: \(url)")
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: UploadError.image)
                    }
                   
                    
                }
            )
        }
    }
    
    func markAsComplete(){
        withAnimation(.spring) {
            withAnimation(.easeInOut(duration: 1)) {
                progress = 1.0
            }


        }
    }
    
    
    
}
