import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var fireBaseService : FireBaseService
    @EnvironmentObject var puzzleStore: PuzzleStore
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var profile: Profile
    var motionService = MotionService()
    
    @State private var name = ""
    // TODO: These states should be in the main view and set as binding here to update what view is shown there
    @State private var showMap = true
    @State private var showChess = false
    @State private var showHome = false
    @State private var gradientOffset = UIScreen.main.bounds.height
    @State private var curPuzzle = Puzzle()
    @State private var currentHeading: CLLocationDirection = 0
        
    
    func manualLocUpdate() {
        locationService.currentRegion = MKCoordinateRegion (
            center: locationService.currentLoc!,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
        locationService.currentCameraPos = MapCameraPosition.camera(MapCamera(centerCoordinate: locationService.currentRegion!.center, distance:1000, heading: currentHeading, pitch: 40.0))
    }
  func printResult(location: CLLocation) {
    print("location received: \(location)")
  }
  
  func startRecording() {
    // this is just a hack to show a callback
    locationService.setCallback(postResult: printResult)
      // Asyncronously call the locationService while running this main thread
    Task {
      await locationService.startRecording(name: name)
        //        motionService.startMagnetometer()

                motionService.startGyros()
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
          HomeButtonView().environmentObject(settings).environmentObject(profile).environmentObject(locationService)
                  }
        if showMap {
            ZStack{
                Map (position: $locationService.currentCameraPos,
                     interactionModes: []) {
                    if let userLoc = locationService.currentLoc {
                        ForEach(0..<puzzleStore.allPuzzles.count, id: \.self) { puzzle in
                            if(!puzzleStore.allPuzzles[puzzle].isSet && !puzzleStore.allPuzzles[puzzle].isSolved){
                                Annotation("", coordinate:CLLocationCoordinate2D(latitude: userLoc.latitude + puzzleStore.allPuzzles[puzzle].locOffset.latitude, longitude: userLoc.longitude + puzzleStore.allPuzzles[puzzle].locOffset.longitude)) {
                                    PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle].val,
                                                         puzzle: $puzzleStore.allPuzzles[puzzle], curPuzzle: $curPuzzle).environmentObject(locationService)
                                        }
                                    }
                            else if !puzzleStore.allPuzzles[puzzle].isSolved {
                                // This puzzle has already been placed relative to user location and shouldn't be moved
                                Annotation("", coordinate:CLLocationCoordinate2D(latitude:  puzzleStore.allPuzzles[puzzle].finalLoc.latitude, longitude: puzzleStore.allPuzzles[puzzle].finalLoc.longitude)) {
                                    PuzzleAnnotationView(showMap:$showMap, showChess:$showChess, val: $puzzleStore.allPuzzles[puzzle].val,
                                                         puzzle: $puzzleStore.allPuzzles[puzzle], curPuzzle: $curPuzzle).environmentObject(locationService)
                                }
                            }
                        }
                        Annotation("", coordinate:userLoc){
                            VStack{
                                ZStack {
                                    profile.pieces[profile.pieceChoice].resizable().frame(width:80, height:80)
                                }
                            }
                        }
                        // Hide initial label so we can style the text
                        .annotationTitles(.hidden)
                    }
                }.ignoresSafeArea().animation(Animation.easeInOut(duration: 0.1), value:locationService.currentHeading)
                
                VStack{
                    ZStack{
                        colors.darkGreen
                        .frame(height: 110)
                        HStack
                        {
                            Text(" \(userService.username)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
                            Spacer()
                            Text(" \(userService.elo.last ?? 0)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
                        }.padding([.horizontal,.top], 60)
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
                // Uncomment this for arrow keys to move user
    //            /**
                HStack{
                    VStack{
                        Button( action: {
                            print("moving forward")
                            locationService.currentLoc?.latitude = (locationService.currentLoc?.latitude ?? 0.0) + 0.0003
                            manualLocUpdate()

                        }, label: {
                            Image(systemName: "arrow.up").imageScale(.large).foregroundColor(.white).background(.blue).cornerRadius(3)
                        })
                        HStack{
                            Button( action: {
                                print("moving left")
                                locationService.currentLoc?.longitude = (locationService.currentLoc?.longitude ?? 0.0) - 0.0003
                                manualLocUpdate()
                            }, label: {
                                Image(systemName: "arrow.left").imageScale(.large).foregroundColor(.white).background(.blue).cornerRadius(3)
                            })
                            Button( action: {
                                print("moving right")
                                locationService.currentLoc?.longitude = (locationService.currentLoc?.longitude ?? 0.0) + 0.0003
                                manualLocUpdate()
                            }, label: {
                                Image(systemName: "arrow.right").imageScale(.large).foregroundColor(.white).background(.blue).cornerRadius(3)
                            })
                        }
                        Button( action: {
                            print("moving back")
                            locationService.currentLoc?.latitude = (locationService.currentLoc?.latitude ?? 0.0) - 0.0003
                            manualLocUpdate()
                        }, label: {
                            Image(systemName: "arrow.down").imageScale(.large).foregroundColor(.white).background(.blue).cornerRadius(3)
                        })
                    }
                    Spacer()
                }.padding()
//                */
                
            }.onAppear{
                Task{
                    let info = await fireBaseService.getUser()
                    userService.updateUser(username: info.0, elo: info.1, correct: info.2, incorrect: info.3, themes: info.4, k: info.5)
                    let puzzleList = await fireBaseService.getPuzzle(userElo: userService.elo.last!, difficulty: settings.puzzleDifficulty, quantity: puzzleStore.allPuzzles.count)
                    for (index, puzzle) in puzzleList.enumerated() {
                        puzzleStore.allPuzzles[index].puzzle = puzzle
                    }
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


