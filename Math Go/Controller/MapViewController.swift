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
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBSegueAction func showInventory(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: InventoryTabView().environmentObject(appDelegate.player))
    }
    
    @IBSegueAction func showCatchView(_ coder: NSCoder) -> UIViewController? {
        // Create MathQuestion and Beastie
        let player = appDelegate.player!
        let mathLevel = player.mathLevel
        let mathQuestion = MathQuestionGenerator().getQuestion(level: mathLevel)
        let beastie = Beastie(id: player.beasties.count, name: Beastie.allBeasties.randomElement()!, mathQuestion: mathQuestion, location: coordinateOne)
        // Catch Beastie Screen
        return CatchHostingController(coder: coder, beastie: beastie)
    }
    
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set initial location to Tampa
        //let initialLocation = CLLocation(latitude: 27.9506, longitude: -82.4572)
        //mapView.centerToLocation(initialLocation)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        let myBeastie = Beastie.allBeasties.randomElement()!
        addPin(myBeastie)
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
    
    // Create Math Question and Beastie
    func addBeastie(_ beastieName: String, _ beastieLocation: CLLocationCoordinate2D) -> Beastie {
        let player = appDelegate.player!
        let mathLevel = player.mathLevel
        let mathQuestion = MathQuestionGenerator().getQuestion(level: mathLevel)
        let locationCoordinate = Coordinate(latitude: beastieLocation.latitude, longitude: beastieLocation.longitude)
        let beastie = Beastie(id: player.beasties.count, name: beastieName, mathQuestion: mathQuestion, location: locationCoordinate)
        return beastie
    }
    
    // Lets you know annotation has been tapped and then shows the catch beastie screen
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title)")
                if (title != "My Location") {
                    let myBeastie = addBeastie(title, annotation.coordinate)
                    showCatchView(myBeastie)
                    //TODO: Need to make it so that Beastie disappears from Map once it is caught
                }
            }
        }
    }
}

/* Displays player avatar instead of the blue dot and displays beastie assets
 Source: https://guides.codepath.org/ios/Using-MapKit */
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        
        // Return scaled beastie image matching the title of the annotation
        switch annotationView?.annotation?.title {
            case "My Location":
                annotationView?.image = scaledAvatar()
            case "AntBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "AntBeastie", size: 100)
            case "BatBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "BatBeastie", size: 100)
            case "DarkBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "DarkBeastie", size: 100)
            case "DragonBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "DragonBeastie", size: 100)
            case "GreenBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "GreenBeastie", size: 100)
            case "GroundBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "GroundBeastie", size: 100)
            case "IceBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "IceBeastie", size: 100)
            case "MarshieBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "MarshieBeastie", size: 100)
            case "PlantBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "PlantBeastie", size: 100)
            case "RockBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "RockBeastie", size: 100)
            case "UFOBeastie":
                annotationView?.image = UIImage.scaleImage(imageName: "UFOBeastie", size: 100)
            default:
                annotationView?.image = UIImage(named: "pin")
        }
        return annotationView
    }
    
    // Return scaled Avatar image
    func scaledAvatar() -> UIImage {
        return UIImage.scaleImage(imageName: appDelegate.player.avatar, size: 100)
    }
    
    // Add pin for beastie to specified location
    func addPin(_ beastieName: String) {
        print("addPin has been called")
        let annotation = MKPointAnnotation()
        // TODO: Create function that randomly generates coordinates within certain radius of user's location where beastie pins will be displayed
        // TODO: Create timer that will time the appearance and disappearance of multiple beastie pins to the map
        let locationCoordinate = CLLocationCoordinate2D(latitude: 37.7856479, longitude: -122.4196999)
        annotation.coordinate = locationCoordinate
        annotation.title = beastieName
        mapView.addAnnotation(annotation)
    }
    
    // Display the Catch Beastie Screen
    private func showCatchView(_ beastie: Beastie) {
        print("showCatchView has been called")
        let vc = UIHostingController(rootView: CatchView(beastie: beastie).environmentObject(appDelegate.player))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
