
// https://www.abstractapi.com/guides/ip-geolocation/swift-geolocation

import CoreLocation
import SwiftUI
import MapKit

enum CheckServiceResult {
  case notChecked
  case notAvailable
  case available
}

// Class to interact with LocationManager and update user location data in the MapView
class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject  {
  var locationManager: CLLocationManager?
  @Published var serviceAvailable = false
  @Published var checkServiceResult: CheckServiceResult = .notChecked
    @Published var currentLoc: CLLocationCoordinate2D?
    @Published var currentRegion: MKCoordinateRegion?
    @Published var currentHeading: CLLocationDirection = CLLocationDirection()
    @Published var currentCameraPos: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
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
    // This is where the location is being actively updated when startLocationUpdates is called
      currentLoc = latestLocation.coordinate
      print("updating location")
      currentRegion = MKCoordinateRegion (
          center: currentLoc!,
          span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
      )
      if let heading = locationManager?.heading?.magneticHeading{
          currentHeading = heading
          print(currentHeading)
      }
      // This is used to set the pitch at an angle to start so that buildings appear 3D
      currentCameraPos = MapCameraPosition.camera(MapCamera(centerCoordinate: currentRegion!.center, distance:1000, heading: currentHeading, pitch: 40.0))
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
      locationManager?.startUpdatingHeading()
    }
  }
  
  func stopRecording() async {
    if serviceAvailable {
      locationManager?.stopUpdatingLocation()
      locationManager?.stopUpdatingHeading()
    }
  }
}


