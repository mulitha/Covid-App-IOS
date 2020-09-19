//
//  MapMarker.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/18/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import MapKit

class MapMarker: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
    
}
