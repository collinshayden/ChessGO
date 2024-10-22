//
//  ChessUIApp.swift
//  ChessUI
//
//  Created by James Birmingham on 9/26/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Uncomment the following line to clear UserDefaults every launch (for debugging purposes only)
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    FirebaseApp.configure()

    return true
  }
}

@main
struct ChessUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
            .environmentObject(FireBaseService())
            .environmentObject(LocationService())
        }
    }
}
