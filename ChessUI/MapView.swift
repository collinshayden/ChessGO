import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
  @EnvironmentObject var locationService: LocationService
  @State private var name = ""
    // TODO: These states should be in the main view and set as binding here to update what view is shown there
    @State private var showMap = true
    @State private var showChess = false
    @State private var showHome = false
  
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
        if showChess{
            PuzzleView()
        }
      if showHome {
        HomeButtonView()
        .transition(.move(edge: .bottom))
        .animation(.easeInOut)
                  }
        if showMap {
            ZStack{
                // TODO: What do we want the user to be able to do? Pan, Pitch, Rotate, Zoom are the options
                Map (position: $locationService.currentCameraPos,
                     interactionModes: [.rotate, .zoom, .pitch]) {
                    Annotation("test", coordinate: CLLocationCoordinate2D(latitude: 37.335855, longitude: -122.0089189)) {
                        PuzzleAnnotationView(showMap:$showMap, showChess:$showChess)
                    }
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
                }.ignoresSafeArea()
                
                VStack{
                    Color.white
                    .frame(height: 125)
                    
                    Spacer()
                    DefaultButtonView(buttonImage: "house", action: {
                        withAnimation(.easeInOut) {
                            showHome = true
                            showMap = false
                            }
                    }).padding(20)
                }.ignoresSafeArea()
               
            }.onAppear {
                if showMap {
                    startRecording()
                }
            }
            .onDisappear {
                stopRecording()
            }
        }
    }
    
  }

#Preview {
  MapView()
    .environmentObject(LocationService())
}


