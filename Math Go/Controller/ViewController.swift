//
//  ViewController.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 1/19/22.
//

import UIKit
import MapKit
import CoreLocation

/* Notifies the locationManager when it has updated the position of the device
Source: https://www.raywenderlich.com/764-augmented-reality-ios-tutorial-location-based */
class ViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial location to Tampa
        //let initialLocation = CLLocation(latitude: 27.9506, longitude: -82.4572)
        // mapView.centerToLocation(initialLocation)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()

    }


}

/* Displays region at specified zoom level
Source: https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started */
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

/* Delegate method that gets the current location of the user */
extension ViewController: CLLocationManagerDelegate {
    internal func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}


