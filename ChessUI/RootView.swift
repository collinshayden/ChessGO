//
//  RootView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/16/24.
//
import SwiftUI


struct RootView : View {
    @EnvironmentObject var fireBaseService : FireBaseService
    var body: some View {
        VStack {
            if(fireBaseService.isLoggedIn){
                MapView().environmentObject(LocationService()).environmentObject(FireBaseService())
                    .environmentObject(PuzzleStore())
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
        }
    }
}

#Preview{
    RootView().environmentObject(FireBaseService())
        .environmentObject(LocationService())
        .environmentObject(PuzzleStore())
}
