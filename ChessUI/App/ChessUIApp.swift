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
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
            .environmentObject(FireBaseService())
            .environmentObject(LocationService())
            .environmentObject(UserService())
            .environmentObject(PuzzleStore())
        }
    }
}
