import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var fireBaseService : FireBaseService
    @EnvironmentObject var puzzleStore: PuzzleStore
    @State private var name = ""
    // TODO: These states should be in the main view and set as binding here to update what view is shown there
    @State private var showMap = true
    @State private var showChess = false
    @State private var showHome = false
    @State private var gradientOffset = UIScreen.main.bounds.height
    @State private var curPuzzle = Puzzle()
  
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
          PuzzleView(puzzle: curPuzzle, showChess: $showChess, showMap: $showMap).environmentObject(userService).environmentObject(fireBaseService)
      }
      if showHome {
        HomeButtonView()
                  }
        if showMap {
            ZStack{
                // TODO: What do we want the user to be able to do? Pan, Pitch, Rotate, Zoom are the options
                Map (position: $locationService.currentCameraPos,
                     interactionModes: [.rotate, .zoom, .pitch]) {
                    if let userLoc = locationService.currentLoc {
                        ForEach(0..<puzzleStore.allPuzzles.count, id: \.self) { puzzle in
                            if(!puzzleStore.allPuzzles[puzzle].isSet){
                                Annotation("Puzzle " + String(puzzleStore.allPuzzles[puzzle].val), coordinate:CLLocationCoordinate2D(latitude: userLoc.latitude + puzzleStore.allPuzzles[puzzle].locOffset.latitude, longitude: userLoc.longitude + puzzleStore.allPuzzles[puzzle].locOffset.longitude)) {
                                    PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle].val,
                                                         puzzle: $puzzleStore.allPuzzles[puzzle], curPuzzle: $curPuzzle)
                                        }
                                    }
                            else{
                                // This puzzle has already been placed relative to user location and shouldn't be moved
                                Annotation("Puzzle " + String(puzzleStore.allPuzzles[puzzle].val), coordinate:CLLocationCoordinate2D(latitude:  puzzleStore.allPuzzles[puzzle].finalLoc.latitude, longitude: puzzleStore.allPuzzles[puzzle].finalLoc.longitude)) {
                                    PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle].val,
                                                         puzzle: $puzzleStore.allPuzzles[puzzle], curPuzzle: $curPuzzle)
                                }
                            }
                        }
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
                    ZStack{
                        colors.darkGreen
                        .frame(height: 110)
                        HStack
                        {
                            Text(" \(userService.username)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
                            Spacer()
                            Text(" \(userService.elo.last ?? 0)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
                        }.padding(40)
                    }
                    
                    Spacer()
                    Button(action : {withAnimation(.easeInOut) {
                        showHome = true
                        showMap = false
                        }}) {
                        Image(systemName: "house")
                        .font(.custom("League Spartan", size: 32))
                        .frame(width: 75, height: 75) .foregroundColor(.white) .background(LinearGradient(
                            gradient: Gradient(colors: [
                                colors.vermontGreen,
                                colors.lightGreen
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .cornerRadius(100)
                    }.padding(50)
                }.ignoresSafeArea()
               
            }.onAppear{
                Task{
                    let info = await fireBaseService.getUser()
                    userService.updateUser(username: info.0, elo: info.1, correct: info.2, incorrect: info.3, themes: info.4, k: info.5)
                }
                if showMap {
                    startRecording()
                }
            }
            .onDisappear {
                stopRecording()
            }
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
        }
    }
  }

#Preview {
  MapView()
    .environmentObject(LocationService())
    .environmentObject(UserService())
    .environmentObject(FireBaseService())
    .environmentObject(PuzzleStore())
}


