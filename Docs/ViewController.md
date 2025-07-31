# 📱 iOS View Controller Hierarchy & `getTopViewController()` Cheat Sheet

This cheat sheet breaks down how the `getTopViewController()` function works in UIKit/SwiftUI iOS apps and clarifies the concepts of scenes, windows, and view controller hierarchies.

---

## 🧠 Key Concepts

### 1. **Scene**

* A **scene** (`UIScene`) represents one instance of your app's UI.
* Since iOS 13, apps can have **multiple scenes** (e.g., multiple windows on iPad).

### 2. **UIWindowScene**

* A type of scene that manages **windows**.
* A window is where the app’s views are displayed.

### 3. **Key Window**

* The **main active window** receiving user input.
* There may be multiple windows, but only one is the key window at a time.

### 4. **Root View Controller**

* The **first view controller** attached to a window.
* Usually a `UIHostingController` in SwiftUI apps.

### 5. **Presented View Controllers**

* When one view controller **presents another** (e.g., modals, alerts), it builds a stack.
* You may need to get the **last presented view controller** to interact with it.

---

## 🔍 The Function: `getTopViewController()`

```swift
import UIKit

func getTopViewController() -> UIViewController? {
    guard let root = UIApplication
        .shared
        .connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?
        .rootViewController else {
            return nil
    }

    var top = root
    while let presented = top.presentedViewController {
        top = presented
    }

    return top
}
```

---

## 🔁 Step-by-Step Breakdown

| Step | Description                                                                   |
| ---- | ----------------------------------------------------------------------------- |
| 1.   | `UIApplication.shared`: Access the app instance.                              |
| 2.   | `.connectedScenes`: Get all active scenes (windows, external displays, etc.). |
| 3.   | `compactMap`: Filters for `UIWindowScene`, then gets the `keyWindow`.         |
| 4.   | `.first?.rootViewController`: Gets the root controller from the main window.  |
| 5.   | `while let presented = ...`: Walks the stack of presented view controllers.   |
| 6.   | `return top`: Returns the top-most visible controller.                        |

---

## 🧱 Example Hierarchy

```
UIApplication
└── UIWindowScene
    └── UIWindow (keyWindow)
        └── rootViewController (e.g., UIHostingController)
            └── presentedViewController (e.g., SafariViewController)
                └── presentedViewController (e.g., Alert or Sheet)
```

✅ The function climbs from root down the `presentedViewController` chain until it finds the top-most one.

---

## 🛠️ Usage Example

You might use this when you want to present something from anywhere in your app:

```swift
if let topVC = getTopViewController() {
    topVC.present(MyModalViewController(), animated: true)
}
```

---

## 📦 SwiftUI Note

Even in SwiftUI, `UIHostingController` is still the root controller behind the scenes. This function still works to get the active screen.

---

## ✅ Summary

* Scenes: Multiple instances of UI since iOS 13.
* Windows: Containers for your UI.
* Root VC: First screen set for the window.
* Top VC: The last modally presented screen.

This function is safe, clean, and works in both UIKit and SwiftUI contexts.



# 📱 UIScene vs UIWindowScene Cheat Sheet

Understanding the difference between `UIScene` and `UIWindowScene` is essential when working with multi-window apps on iOS, iPadOS, or macOS.

---

## 🧱 Summary: UIScene vs UIWindowScene

| Concept        | `UIScene`                            | `UIWindowScene`                             |
|----------------|--------------------------------------|---------------------------------------------|
| ✅ What it is   | The **base class** for all scenes    | A **subclass** of `UIScene` for **UI**      |
| 🎯 Purpose     | General interface for any scene       | Specifically handles scenes with **windows** |
| 📱 Used for    | Scene lifecycle                       | Manages **orientation**, **traits**, **windows** |
| 🧬 Inheritance | `NSObject → UIResponder → UIScene`   | `UIScene → UIWindowScene`                  |
| 🪟 Can hold windows? | ❌ No                         | ✅ Yes (`var windows: [UIWindow]`)          |
| 👀 Example usage | Used in `UIApplication.shared.connectedScenes` | Used when casting to access UI            |

---

## 🧠 Hierarchy Visualization

```text
UIScene
 └── UIWindowScene (used for app UI)
     └── UIWindow(s)
         └── rootViewController (your app UI)
