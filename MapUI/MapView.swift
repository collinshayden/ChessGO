//
//  ContentView.swift
//  LocationTester
//
//  Created by Felix Walberg on 10/1/24.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    static let example = CLLocationCoordinate2D(latitude: 44.48, longitude: -73.2)
}
// Shared state that manages the `CLLocationManager` and `CLBackgroundActivitySession`.
    @MainActor class LocationsHandler: ObservableObject {
    
        static let shared = LocationsHandler()  // Create a single, shared instance of the object.
        private let manager: CLLocationManager
        private var background: CLBackgroundActivitySession?


        @Published var lastLocation:CLLocation? = CLLocation()
        @Published var isStationary = false
        @Published var count = 0
    
        @Published
        var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdatesStarted") {
            didSet { UserDefaults.standard.set(updatesStarted, forKey: "liveUpdatesStarted") }
        }
    
        @Published
        var backgroundActivity: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
            didSet {
                backgroundActivity ? self.background = CLBackgroundActivitySession() : self.background?.invalidate()
                UserDefaults.standard.set(backgroundActivity, forKey: "BGActivitySessionStarted")
            }
        }
    
    
        private init() {
            self.manager = CLLocationManager()  // Creating a location manager instance is safe to call here in `MainActor`.
        }
    
        func startLocationUpdates() {
            if self.manager.authorizationStatus == .notDetermined {
                self.manager.requestWhenInUseAuthorization()
            }
          
            Task() {
                do {
                    self.updatesStarted = true
                    let updates = CLLocationUpdate.liveUpdates()
                    for try await update in updates {
                        if !self.updatesStarted { break }  // End location updates by breaking out of the loop.
                        if let loc = update.location {
                            self.lastLocation = loc
                            self.isStationary = update.isStationary
                            self.count += 1
                            print("Location \(self.count): \(self.lastLocation)")
                        }
                    }
                } catch {
                    print("Could not start location updates")
                }
                return
            }
        }
    
        func stopLocationUpdates() {
            print("Stopping location updates")
            self.updatesStarted = false
            self.updatesStarted = false
        }
    }

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
   
       func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
           let locationsHandler = LocationsHandler.shared
       
           // If location updates were previously active, restart them after the background launch.
           if locationsHandler.updatesStarted {
               locationsHandler.startLocationUpdates()
           }
           // If a background activity session was previously active, reinstantiate it after the background launch.
           if locationsHandler.backgroundActivity {
               locationsHandler.backgroundActivity = true
           }
           return true
       }
   }
struct MapView: View {
    var locaton = LocationsHandler.shared
    var body: some View {
        VStack {
            Map() {
                // TODO: The assets collection within this "MapUI" group is not mapped to it yet.
                Annotation("Example", coordinate: .example){
                    Image("final").foregroundStyle(Color.black,Color.gray).font(.system(size:50))
                    Button("Puzzle", action: {
                                
                                    })
                }
            }.mapStyle(.standard(elevation:.realistic))
        }
    }
}

#Preview {
    MapView()
}
