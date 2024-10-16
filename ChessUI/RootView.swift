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
                //try await fireBaseService.signIn(UserDefaults.standard.value(forKey: "username") as! String)
                MapView()
            }
            else{
                LoginView()
            }
        }
    }
}

#Preview{
    RootView().environmentObject(FireBaseService())
}
