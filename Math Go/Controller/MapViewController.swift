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
    
    var annotationView: MKAnnotationView?
    
    var thumbnailImageByAnnotation = [NSValue : UIImage]()
    
    //var userLocation: CLLocation?
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBSegueAction func showInventory(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: InventoryTabView().environmentObject(appDelegate.player))
    }
    
    @IBSegueAction func showCatchView(_ coder: NSCoder) -> UIViewController? {
        // Create MathQuestion and Beastie
        let player = appDelegate.player!
        let mathLevel = player.mathLevel
        let mathQuestion = MathQuestionGenerator().getQuestion(level: mathLevel)
        let beastie = Beastie(id: player.beasties.count,
                              name: Beastie.allBeasties.randomElement()!,
                              mathQuestion: mathQuestion,
                              location: coordinateOne)
        
        // Catch Beastie Screen
        return CatchHostingController(coder: coder, beastie: beastie)
    }
    
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        var locationsSFRandom = [CLLocationCoordinate2DMake(37.7856479, -122.4196999),
                                 CLLocationCoordinate2DMake(37.793836, -122.4109757),
                                 CLLocationCoordinate2DMake(37.7799909, -122.4132483),
                                 CLLocationCoordinate2DMake(37.78235, -122.4079104),
                                 CLLocationCoordinate2DMake(37.7951775, -122.4049674)]
        
        var num = 0
        while num != 5 {
            num += 1
            let myBeastie = Beastie.allBeasties.randomElement()!
            print(myBeastie)
            let randomLocation = locationsSFRandom.randomElement()!
            self.addAnnotationWithThumbnailImage(thumbnail: UIImage.scaleImage(imageName: myBeastie, size: 100),
                                                 myBeastie: myBeastie,
                                                 myLocation: randomLocation)
            
            if let index = locationsSFRandom.firstIndex(of: randomLocation) {
                locationsSFRandom.remove(at: index)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Display Start Screen if no player exists
        let playerExists = UserDefaults.standard.bool(forKey: "playerExists")
        if (!playerExists) {
            showStartScreen()
//            if (annotationView?.annotation?.coordinate == mapView.userLocation.coordinate){
//                annotationView?.image = scaledAvatar()
//            }
        } else {
            if annotationView?.annotation?.title == "My Location"{
                annotationView?.image = scaledAvatar()
            }
//            if (annotationView?.annotation?.coordinate == mapView.userLocation.coordinate){
//                annotationView?.image = scaledAvatar()
//            }
        }
    }
    
    private func showStartScreen() {
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
        let locationCoordinate = Coordinate(latitude: beastieLocation.latitude,
                                            longitude: beastieLocation.longitude)
        let beastie = Beastie(id: player.beasties.count,
                              name: beastieName,
                              mathQuestion: mathQuestion,
                              location: locationCoordinate)
        return beastie
    }
    
    // Lets you know annotation has been tapped and then shows the catch beastie screen, beastie disappears once you click on it
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title)")
                if (title != "My Location") {
                    let myBeastie = addBeastie(title, annotation.coordinate)
                    showCatchView(myBeastie)
                    mapView.deselectAnnotation(view.annotation, animated: true)
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    
    // Use different images for each annotation
    // Source: https://guides.codepath.org/ios/Using-MapKit
    func addAnnotationWithThumbnailImage(thumbnail: UIImage, myBeastie: String, myLocation: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = myLocation
        //print(CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude))
        annotation.coordinate = locationCoordinate
        annotation.title = myBeastie
        thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
        mapView.addAnnotation(annotation)
    }

    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        annotationView?.image = getOurThumbnailForAnnotation(annotation: annotation)
        return annotationView
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
        
        if let annotationTitle = annotationView?.annotation?.title {
            if annotationTitle == "My Location" {
                annotationView?.image = scaledAvatar()
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
        
        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        //userLocation = locations.last!
    }
}

/* Adds Equatable to CLLocationCoordinate2D
 Source: https://gist.github.com/soffes/b085c108f9ad1c804a13 */
extension CLLocationCoordinate2D: Equatable {}
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
