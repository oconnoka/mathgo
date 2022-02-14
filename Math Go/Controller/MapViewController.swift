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
    }

    override func viewWillAppear(_ animated: Bool) {
        // Display Start Screen if no player exists
        if (!appDelegate.playerExists) {
            showStartScreen()
        }
    }

    private func showStartScreen() {
        appDelegate.setPlayerExists(value: true)
        appDelegate.player = Player()
        let startVC = UIHostingController(rootView: StartView().environmentObject(appDelegate.player))
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: false)
    }
}

/* Displays player avatar instead of the blue dot
 Source: https://guides.codepath.org/ios/Using-MapKit */
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        
        // TO DO - Get selected avatar to appear here, for now it is just a static avatar
        let pinImage = UIImage(named: "Avatar5")
        let targetSize = CGSize(width: 100, height: 100)
        let scaledImage = pinImage?.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        annotationView?.image = scaledImage

        return annotationView
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


/* Resizes UIImage without scretching
 Source: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/ */
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
