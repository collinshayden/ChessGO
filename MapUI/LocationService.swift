
// https://www.abstractapi.com/guides/ip-geolocation/swift-geolocation
// TODO: This code is still messy from Jason's example, I need to remove some parts that don't do anything.

import CoreLocation
import SwiftUI
import MapKit

enum CheckServiceResult {
  case notChecked
  case notAvailable
  case available
}

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject  {
  var locationManager: CLLocationManager?
  @Published var serviceAvailable = false
  @Published var checkServiceResult: CheckServiceResult = .notChecked
    @Published var currentLoc: CLLocationCoordinate2D?
    @Published var currentRegion: MKCoordinateRegion?
    @Published var currentCameraPos: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    
  // just for demonstration purposes
  var postResult: ((_: CLLocation) -> Void)?

  override init() {
    super.init()
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    // set distance filter to zero to receive ALL updates
    locationManager?.distanceFilter = 0
    locationManager?.requestWhenInUseAuthorization()
    
  }
  
  func setCallback(postResult: @escaping (_: CLLocation) -> Void) {
    self.postResult = postResult
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let latestLocation = locations.last!
    print("#locations in array = \(locations.count)")
    print("location: \(latestLocation.coordinate)")
    print("altitude: \(latestLocation.altitude) +/- \(latestLocation.horizontalAccuracy) m")
    // TODO: This is where the location is being actively updated when startLocationUpdates is called
      // TODO: It still looks a little clunky when the update resets the camera position, so once we figure out what type of interaction we allow the user to do, we can adjust this.
      currentLoc = latestLocation.coordinate
      currentRegion = MKCoordinateRegion (
          center: currentLoc!,
          span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
      )
      currentCameraPos = MapCameraPosition.region(currentRegion!)
      // demo showing how to provide info asynchronously back to the main thread
      if let postResult = postResult {
        DispatchQueue.main.async {
          postResult(latestLocation)
        }
      }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
      serviceAvailable = true
      print("Location services available")
      checkServiceResult = .available
    } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .notDetermined {
      print("Location services not enabled")
      checkServiceResult = .notAvailable
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
    print("locationManager failed: \(didFailWithError)")
  }
  
  func startRecording(name: String) async {
    if serviceAvailable {
      locationManager?.startUpdatingLocation()
    }
  }
  
  func stopRecording() async {
    if serviceAvailable {
      locationManager?.stopUpdatingLocation()
    }
  }
}
