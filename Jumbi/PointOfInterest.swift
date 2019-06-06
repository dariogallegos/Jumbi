//
//  PointOfInterest.swift
//  Jumbi
//
//  Created by Dev2 on 05/06/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit
import MapKit

class PointOfInterest: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let image = "salchicha"
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
