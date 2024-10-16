import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
  @EnvironmentObject var locationService: LocationService
  @State private var name = ""
    @State private var showMap = false
  
  func printResult(location: CLLocation) {
    print("location received: \(location)")
  }
  
  func startRecording() {
    // this is just a hack to show a callback
    locationService.setCallback(postResult: printResult)
      // Asyncronously call the locationService while running this main thread
    Task {
      await locationService.startRecording(name: name)
    }
      
    let currentDate = Date.now
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M/d/yyyy"
    let formattedDate = dateFormatter.string(from: currentDate)
    print("date is '\(formattedDate)'")
  }
  
  func stopRecording() {
    Task {
      await locationService.stopRecording()
    }
  }
  
  var body: some View {
    VStack(spacing: 50) {
        if !showMap {
            Button("showMap", action: {
                startRecording()
                showMap = true
            })
        }
        if showMap {
            // TODO: What do we want the user to be able to do? Pan, Pitch, Rotate, Zoom are the options
            Map (position: $locationService.currentCameraPos,
                 interactionModes: [.rotate, .zoom]) {
                if let userLoc = locationService.currentLoc {
                    Annotation("user", coordinate:userLoc){
                        ZStack {
                                        Circle()
                                            .fill(.gray)
                                            .opacity(0.3)
                                            .frame(width: 44, height: 44)
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 20, height: 20)
                                        Circle()
                                            .fill(.blue)
                                            .frame(width: 16, height: 16)
                                    }
                    }
                }
            }
        }
        if showMap {
            Button("leave map", action: {
                stopRecording()
                showMap = false
            })
        }
    }.padding()
  }
}

#Preview {
  MapView()
    .environmentObject(LocationService())
}
