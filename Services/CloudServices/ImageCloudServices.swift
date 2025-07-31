import Foundation
import SwiftUI
import Cloudinary
class ImageCloudServices{
    static let shared = ImageCloudServices()
    let cloudinary: CLDCloudinary
    
    private init(){
        let config = CLDConfiguration(cloudName: "dcznvee1s", secure: true)
        self.cloudinary = CLDCloudinary(configuration: config)
    }
    
     func uploadImage(imageData: Data) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            cloudinary.createUploader().upload(
                data: imageData,
                uploadPreset: "ios_upload", completionHandler:  { result, error in
                    if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        continuation.resume(throwing: UploadError.image)
                    } else if let url = result?.secureUrl {
                        print("Upload succeeded: \(url)")
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: UploadError.image)
                    }
                })
        }
    }
}
