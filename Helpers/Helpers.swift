
import Foundation
import UIKit

/// connectedScenes: returns all scenes currently open in the app
///
///UIWindowScene is a container for your app's windows (UIs) introduced in iOS 13 to support multi-window apps.
///
///🔹 Think of It Like:
///A UIWindowScene = a screen instance showing your app's content.

@MainActor
func getTopViewController() -> UIViewController?{
     let root =
            UIApplication.shared.connectedScenes.compactMap{ scene in
                (scene as? UIWindowScene)?.keyWindow
                }
            .first?.rootViewController
    
    var top = root
    
    while let presented = top?.presentedViewController{
        top = presented
    }
    
    return top
}
