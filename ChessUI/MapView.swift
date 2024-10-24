import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
  @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var puzzleStore: PuzzleStore
    @EnvironmentObject var firebaseService: FireBaseService
  @State private var name = ""
    // TODO: These states should be in the main view and set as binding here to update what view is shown there
    @State private var showMap = false
    @State private var showChess = false
    let test = [1,2,3,4]
  
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
        if showChess{
            PuzzleView()
        }
        if (!showMap && !showChess) {
            Button("showMap", action: {
                startRecording()
                showMap = true
            })
        }
        if showMap {
            // TODO: What do we want the user to be able to do? Pan, Pitch, Rotate, Zoom are the options
            Map (position: $locationService.currentCameraPos,
                 interactionModes: [.rotate, .zoom, .pitch]) {
//                for puzzle in puzzleStore.allPuzzles{
//                    
//                }
//                for _ in 0...5{
//                    Annotation("test", coordinate:CLLocationCoordinate2D(latitude: 37.3358, longitude: -122.008)){
//                        PuzzleAnnotationView(showMap:$showMap, showChess:$showChess)
//                    }
//                }
                ForEach(0..<puzzleStore.allPuzzles.count, id: \.self) { puzzle in
                    Annotation("Puzzle " + String(puzzleStore.allPuzzles[puzzle].val), coordinate:CLLocationCoordinate2D(latitude: puzzleStore.allPuzzles[puzzle].loc.latitude, longitude: puzzleStore.allPuzzles[puzzle].loc.longitude)) {
                        PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle].val,
                                             puzzle: $puzzleStore.allPuzzles[puzzle])
                    }
//                    Annotation(String(puzzle), coordinate:CLLocationCoordinate2D(latitude: 37.335855, longitude: -122.0089189)) {
//                        PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle])
//                    }
                    
                }
//                TODO: THIS IS THE WORKING ONE
//                Annotation("test", coordinate: CLLocationCoordinate2D(latitude: 37.335855, longitude: -122.0089189)) {
//                    PuzzleAnnotationView(showMap:$showMap, showChess:$showChess)
//                }
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
//                    Annotation("puzzleObj", coordinate: userLoc) {
//                        PuzzleAnnotationView(showMap:$showMap, showChess:$showChess)
//                    }
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
    .environmentObject(PuzzleStore())
    .environmentObject(FireBaseService())
}


