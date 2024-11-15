//
//  RootView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/16/24.
//
import SwiftUI


struct RootView : View {
    @EnvironmentObject var fireBaseService : FireBaseService
    @EnvironmentObject var userService : UserService
    @EnvironmentObject var locationService : LocationService
    @EnvironmentObject var puzzleStore: PuzzleStore
    @EnvironmentObject var puzzleRushStore: PuzzleRushStore
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var profile: Profile
    
    
    
    var body: some View {
        VStack {
            if(fireBaseService.isLoggedIn){
                MapView()
            }
            else{
                LoginView()
            }
        }.onAppear {
            if fireBaseService.isLoggedIn {
                Task {
                    if let username = UserDefaults.standard.value(forKey: "username") as? String {
                        try await fireBaseService.signIn(username)
                    }
                }
            }
            Task {
                puzzleRushStore.puzzles = await fireBaseService.getPuzzleRushPuzzles()
            }
        }
    }
}

#Preview{
    RootView().environmentObject(FireBaseService())
        .environmentObject(LocationService())
        .environmentObject(UserService())
}
