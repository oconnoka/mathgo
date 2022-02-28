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
    
    fileprivate let locationManager = CLLocationManager()
    
    let MIN_DISTANCE: CLLocationDegrees = 0.0005 // approximately 50 meters
    let MAX_DISTANCE: CLLocationDegrees = 0.005 // approximately 500 meters
    let SPAWN_INVERTAL: TimeInterval = 15 // spawn Beasties every 15 seconds
    let MAX_BEASTIES: Int = 5 // maximum number of Beasties on Map at a time
    
    var thumbnailImageByAnnotation = [NSValue : UIImage]() // TODO - is this necessary?
    var annotationView: MKAnnotationView? // TODO - is this necessary?
    
    var userLocation: CLLocation?
    var avatarAnnotationView: MKAnnotationView?
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBSegueAction func showInventory(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: InventoryTabView().environmentObject(appDelegate.player))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        spawnBeasties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Display Start Screen if no player exists
        let playerExists = UserDefaults.standard.bool(forKey: "playerExists")
        if (!playerExists) {
            showStartScreen()
        } else {
            // Make sure player avatar is up-to-date
            avatarAnnotationView?.image = scaledAvatar()
        }
    }
    
    private func showStartScreen() {
        appDelegate.player = Player()
        let startVC = UIHostingController(rootView: StartView().environmentObject(appDelegate.player))
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: false)
    }
    
    // Spawns Beastie images onto Map. Checks every SPAWN_INTERVAL seconds whether there are 5 Beasties on the map
    func spawnBeasties() {
        let maxAnnotations = MAX_BEASTIES + 1 // +1 because one is player avatar
        
        // First time: wait for location to be available and then spawn all 5 Beasties
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            if userLocation != nil && mapView.annotations.count < maxAnnotations {
                for _ in 0...5 {
                    addBeastieAnnotation()
                }
                timer.invalidate()
            }
        }
        
        // Maintain 5 Beasties by checking every time interval
        Timer.scheduledTimer(withTimeInterval: SPAWN_INVERTAL, repeats: true) { [self] timer in
            // Add a Beastie if fewer than 5
            if userLocation != nil && mapView.annotations.count < maxAnnotations {
                addBeastieAnnotation()
            }
            
            // Remove Beasties if too far away from user location
            if userLocation != nil {
                for anno in mapView.annotations {
                    let annoLocation = CLLocation(latitude: anno.coordinate.latitude, longitude: anno.coordinate.longitude)
                    let distanceMeters = annoLocation.distance(from: userLocation!)
                    if distanceMeters > 900 {
                        mapView.removeAnnotation(anno)
                    }
                }
            }
        }
    }
    
    // Adds a random Beastie annotation to Map near player
    func addBeastieAnnotation() {
        let beastieName = Beastie.allBeasties.randomElement()!
        let randomLocation = randomCoordinate(from: userLocation!, minDelta: MIN_DISTANCE, maxDelta: MAX_DISTANCE)
        let thumbnail = UIImage.scaleImage(imageName: beastieName, size: 100)
        thumbnail.accessibilityLabel = beastieName
        self.addAnnotationWithThumbnailImage(thumbnail: UIImage.scaleImage(imageName: beastieName, size: 100),
                                             myBeastie: beastieName,
                                             myLocation: randomLocation)
    }
    
    // Lets you know annotation has been tapped and then shows the catch beastie screen, beastie disappears once you click on it
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title)")
                if (title != "My Location") {
                    let myBeastie = createBeastie(title, annotation.coordinate)
                    showCatchView(myBeastie)
                    mapView.deselectAnnotation(view.annotation, animated: true)
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    
    // Creates a Beastie with a MathQuestion at the player's level
    func createBeastie(_ beastieName: String, _ beastieLocation: CLLocationCoordinate2D) -> Beastie {
        let player = appDelegate.player!
        let mathLevel = player.mathLevel
        let mathQuestion = MathQuestionGenerator().getQuestion(level: mathLevel)
        let locationCoordinate = Coordinate(latitude: beastieLocation.latitude,
                                            longitude: beastieLocation.longitude)
        let beastie = Beastie(id: player.beasties.count,
                              name: beastieName,
                              mathQuestion: mathQuestion,
                              location: locationCoordinate)
        return beastie
    }
    
    // Use different images for each annotation
    // Source: https://guides.codepath.org/ios/Using-MapKit
    func addAnnotationWithThumbnailImage(thumbnail: UIImage, myBeastie: String, myLocation: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        annotation.title = myBeastie
        thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        print("Does this code ever get called? =============================")
        let annotationImage = thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
        annotationView?.image = annotationImage
        return annotationView
    }
    
    // Returns a random CLLocationCoordinate2D that is within minDelta and maxDelta from location
    func randomCoordinate(from: CLLocation, minDelta: Double, maxDelta: Double) -> CLLocationCoordinate2D {
        let posNeg = [1.0, -1.0]
        let dLatitude = Double.random(in: minDelta...maxDelta) * posNeg.randomElement()!
        let dLongitude = Double.random(in: minDelta...maxDelta) * posNeg.randomElement()!
        return CLLocationCoordinate2D(latitude: from.coordinate.latitude + dLatitude,
                                      longitude: from.coordinate.longitude + dLongitude)
    }

}

/* Displays player avatar instead of the blue dot and displays beastie assets
 Source: https://guides.codepath.org/ios/Using-MapKit */
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        
        if let annotationTitle = annotationView?.annotation?.title {
            if annotationTitle == "My Location" {
                annotationView?.image = scaledAvatar()
                avatarAnnotationView = annotationView
            } else {
                annotationView?.image = UIImage.scaleImage(imageName: annotationTitle!, size: 100)
            }
        }
        
        return annotationView
    }
    
    // Return scaled Avatar image
    func scaledAvatar() -> UIImage {
        return UIImage.scaleImage(imageName: appDelegate.player.avatar, size: 100)
    }
    
    // Display the Catch Beastie Screen
    private func showCatchView(_ beastie: Beastie) {
        print("showCatchView has been called")
        let vc = UIHostingController(rootView: CatchView(beastie: .constant(beastie)).environmentObject(appDelegate.player))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

/* Displays region at specified zoom level
 Source: https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started */
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

/* Delegate method that gets the current location of the user */
extension MapViewController: CLLocationManagerDelegate {
    internal func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Zooms map view to location
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        // Continuously updates user location
        userLocation = locations.last
    }
}

/* Adds Equatable to CLLocationCoordinate2D
 Source: https://gist.github.com/soffes/b085c108f9ad1c804a13 */
extension CLLocationCoordinate2D: Equatable {}
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
