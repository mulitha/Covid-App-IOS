//
//  MapLocations.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/18/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Foundation

struct MapLocations {
    
    var lat: Double
    var log: Double
    var uid: String
    var syncDateTime: String
    
    init(lat: Double, log: Double, uid: String, syncDateTime: String) {
        self.lat = lat
        self.log = log
        self.uid = uid
        self.syncDateTime = syncDateTime
    }
}
