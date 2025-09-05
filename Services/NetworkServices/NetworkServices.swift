import UIKit
import Foundation


class NetworkServices{
    static let shared = NetworkServices()
    private init(){}
    
    func getImageFromInternet(url: URL) async -> UIImage?{
        guard let (data, response) = try? await URLSession.shared.data(from: url) else {return nil}
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            return nil
        }
        return UIImage(data: data)
        
        
    }
}

