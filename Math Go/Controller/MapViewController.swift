//
//  ViewController.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 1/19/22.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

/* Notifies the locationManager when it has updated the position of the device
 Source: https://www.raywenderlich.com/764-augmented-reality-ios-tutorial-location-based */
class MapViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var annotationView: MKAnnotationView? // for Avatar image on map, see extension
    var targets = [ARItem]() // Property for storing targets
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBAction func inventory(_ sender: Any) {
        let inventoryVC = UIHostingController(rootView: InventoryView().environmentObject(appDelegate.player))
        inventoryVC.modalPresentationStyle = .fullScreen
        self.present(inventoryVC, animated: true)
    }
    
    @IBSegueAction func showCatchView(_ coder: NSCoder) -> UIViewController? {
        // Create MathQuestion and Beastie
        let player = appDelegate.player!
        let mathLevel = player.mathLevel
        let mathQuestion = MathQuestionGenerator().getQuestion(level: mathLevel)
        let beastie = Beastie(id: player.beasties.count, name: Beastie.allBeasties.randomElement()!, mathQuestion: mathQuestion)
        // Catch Beastie Screen
        return CatchHostingController(coder: coder, beastie: beastie)
    }
    
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
        mapView.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        setupLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Display Start Screen if no player exists
        if (!appDelegate.playerExists) {
            showStartScreen()
        } else {
            annotationView?.image = scaledAvatar()
        }
    }
    
    private func showStartScreen() {
        appDelegate.setPlayerExists(value: true)
        appDelegate.player = Player()
        let startVC = UIHostingController(rootView: StartView().environmentObject(appDelegate.player))
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: false)
    }
    
    func setupLocations() {
      let firstTarget = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 37.7856479, longitude: -122.4196999))
      targets.append(firstTarget)
        
      let secondTarget = ARItem(itemDescription: "bear", location: CLLocation(latitude: 37.7850798, longitude: -122.4055807))
      targets.append(secondTarget)
        
      let thirdTarget = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 37.7850798, longitude: -122.4055807))
      targets.append(thirdTarget)
        
        for item in targets {
          let annotation = MapAnnotation(location: item.location.coordinate, item: item)
          self.mapView.addAnnotation(annotation)
        }
    }
}

/* Displays player avatar instead of the blue dot
 Source: https://guides.codepath.org/ios/Using-MapKit */
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        
        annotationView?.image = scaledAvatar()
        
        return annotationView
    }
    
    // Return scaled Avatar image
    func scaledAvatar() -> UIImage {
        return UIImage.scaleImage(imageName: appDelegate.player.avatar, size: 100)
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
extension MapViewController: CLLocationManagerDelegate {
    internal func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}
