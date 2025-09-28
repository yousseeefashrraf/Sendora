# 💬 Sendora — iOS Messaging & Payments App

Sendora is a modern iOS messaging app built with **SwiftUI**, combining **real-time chat** with **integrated payment capabilities**.  
It features a **glass-morphism UI**, secure authentication, and seamless data synchronization for a smooth messaging experience.

![Group 1](https://github.com/user-attachments/assets/97e5da0a-21bb-49d5-a115-04bc7afc6b85)

---

## 📱 Features

- 🔐 **Authentication & Security**
  - Email/Password with Firebase Auth
  - Google Sign-In + email verification
  - Biometric authentication
  - Secure password validation

- 💬 **Messaging**
  - Real-time conversations
  - Read/unread status tracking
  - Image sharing
  - Pin, archive, mute chats
  - Group conversations

- 🎨 **User Experience**
  - Glass-morphism UI
  - Dark/Light mode
  - Smooth animations & transitions
  - Profile editing (bio + avatar)
  - Tab-based navigation

- 🔄 **Data Management**
  - Core Data (local) + Firestore (cloud)
  - NSCache + disk image persistence
  - Cloudinary for media uploads
  - Offline-first sync

---

## 🛠 Tech Stack

- **Language:** Swift 5.0+  
- **UI:** SwiftUI + MVVM  
- **Backend:** Firebase (Auth + Firestore)  
- **Media:** Cloudinary  
- **Local Storage:** Core Data + CloudKit  
- **Concurrency:** Combine + async/await  

---

## 📁 Project Structure

```text
Sendora/
├── App/                    # App entry points and root views
├── Features/               # Feature modules
│   ├── Authentication/     # Login, Signup flows
│   ├── Chats/              # Messaging interface
│   ├── Alerts/             # Notification system
│   ├── Information/        # User profile management
│   └── Screens/            # Main app screens
├── Models/                 # Data models and Core Data
├── Services/               # Business logic and APIs
│   ├── Authentication/
│   ├── Database/
│   ├── CloudServices/
│   └── MemoryManagement/
├── ViewModels/             # Business logic for views
├── Routing/                # Navigation management
├── Helpers/                # Utilities and extensions
└── Resources/              # Assets, colors, fonts
```
---

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 16.0+
- CocoaPods
- Firebase project + Cloudinary account

### Installation
1. Clone repo  
2. `pod install`  
3. Add `GoogleService-Info.plist`  
4. Set up Firestore + Auth in Firebase  
5. Add Cloudinary credentials  
6. Build & run 🚀  

---

## 📸 Screenshots
| Launch | Splash Screen | Auth | Chats | Messages | Profile |
|--------|---------------|------|-------|----------|---------|
| <img width="310" alt="Launch" src="https://github.com/user-attachments/assets/548ce553-de7e-428a-b9e4-5670c901282d" /> | <img width="310" alt="Splash" src="https://github.com/user-attachments/assets/553e2064-74f1-4c59-b3d2-f302cdcab429" /> | <img width="310" alt="Auth1" src="https://github.com/user-attachments/assets/e9b29442-7eb9-4a50-9cd5-b9da55b20a5d" /><br><img width="310" alt="Auth2" src="https://github.com/user-attachments/assets/3440fea6-d409-42ce-8896-f2a0acc0ccb4" /> | <img width="310" alt="Chats" src="https://github.com/user-attachments/assets/62dca54e-3530-4d41-ad45-e8664163dcc8" /> | Coming Soon | <img width="310" alt="Profile" src="https://github.com/user-attachments/assets/8748ea3d-be36-4a09-8fb8-c6ab0c353812" /> |


---

## 📈 Performance & Security

- Multi-layer image caching (NSCache + disk)  
- Lazy loading for efficiency  
- Background sync (non-blocking UI)  
- Encrypted data (in transit + at rest)  
- Secure token + credential management  

---

## 🧠 What I Learned

- Building a **full-stack iOS app** with Firebase + Core Data  
- Designing **offline-first data sync**  
- Implementing **glass-morphism UI** in SwiftUI  
- Managing **state-driven navigation** in a modular app  
- Handling **authentication flows** with multiple providers  

---

## 📈 Next Features (Planned)

- In-app payment transfers  
- Push notifications for new messages  
- Rich media (videos, voice notes)  
- Group management features  
- Advanced search & filters  

---

## 👨‍💻 Author

**Youssef Ashraf**  
iOS Developer | Computer Science Student  
[GitHub](https://github.com/yousseeefashrraf) · [YouTube](https://youtube.com/@YooussefAshraf)  

---

## ⚠️ Disclaimer

This project is a personal project for learning and portfolio purposes.  
