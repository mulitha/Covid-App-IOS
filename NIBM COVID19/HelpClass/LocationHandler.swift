//
//  LocationHandler.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/18/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    

    
    func syncUserLocation(){
        
        guard let location = self.locationManager?.location else { return }
         let userLocation = [
         
             "lat":location.coordinate.latitude,
             "log":location.coordinate.longitude,
             "syncDateTime":DateConvertion.shared.stringFromDate(Date()),
             "uid":Service.shared.getUserUid()
             
         ]as [String:Any]
         
         Service.shared.syncUserLocation(userLocation)

    }
    
}
