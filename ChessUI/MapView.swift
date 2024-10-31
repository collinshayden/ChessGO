import SwiftUI
import MapKit
import CoreLocation // just for the printResult()

struct MapView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var fireBaseService : FireBaseService
    @State private var name = ""
    // TODO: These states should be in the main view and set as binding here to update what view is shown there
    @State private var showMap = true
    @State private var showChess = false
    @State private var showHome = false
    @State private var gradientOffset = UIScreen.main.bounds.height
  
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
                    ZStack{
                        colors.darkGreen
                        .frame(height: 110)
                        HStack
                        {
                            Text(" \(userService.username)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
                            Spacer()
                            Text(" \(userService.elo)").foregroundColor(.white).font(.custom("League Spartan", size: 32))
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
                    userService.updateUser(username: info.0, elo: info.1, correct: info.2, incorrect: info.3, themes: info.4)
                }
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
    .environmentObject(UserService())
    .environmentObject(FireBaseService())
}


