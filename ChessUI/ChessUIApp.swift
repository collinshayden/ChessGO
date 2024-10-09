//
//  ChessUIApp.swift
//  ChessUI
//
//  Created by James Birmingham on 9/26/24.
//

import SwiftUI

@main
struct ChessUIApp: App {
    @StateObject private var locationService = LocationService()
    var body: some Scene {
        WindowGroup {
            ContentView()
            // TODO: This is the window I used to show the map and bring in the locationService, I commented out ContentView and replaced it with this. Once we set up the tab bar we can navigate into the MapView without starting with it.
//            MapView().environmentObject(locationService)
        }
    }
}
