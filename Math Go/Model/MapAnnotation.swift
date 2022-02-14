//
//  MapAnnotation.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 2/13/22.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
  //1
  let coordinate: CLLocationCoordinate2D
  let title: String?
  //2
  let item: ARItem
  //3
  init(location: CLLocationCoordinate2D, item: ARItem) {
    self.coordinate = location
    self.item = item
    self.title = item.itemDescription
    
    super.init()
  }
}
