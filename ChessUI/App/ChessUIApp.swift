//
//  ChessUIApp.swift
//  ChessUI
//
//  Created by James Birmingham on 9/26/24.
//

import SwiftUI
import FirebaseCore

@main
struct ChessUIApp: App {
    
    init() {
        FirebaseApp.configure()
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
            .environmentObject(FireBaseService())
            .environmentObject(LocationService())
            .environmentObject(UserService())
            .environmentObject(PuzzleStore())
            .environmentObject(Settings())
            .environmentObject(Profile())
            .environmentObject(PuzzleRushStore())
        }
    }
}
