//
//  Coordinate.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 2/19/22.
//

import SwiftUI
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}
