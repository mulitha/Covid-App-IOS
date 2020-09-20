//
//  MapViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var whereToView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()

    var mapLocations : [MapLocations] = []
    
    var lati: Double = 0
    var long: Double = 0
    var userTemp:Double = 0
    var mLocation : MapMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long))
        pingUserLocations()

    }
    
    
        
      func pingUserLocations(){
        DispatchQueue.main.async {
            Service.shared.getLocationUpdates{ (mapLocation) in
                self.mapLocation = mapLocation
            }
        }
    }
    
    
    
    //MARK: Properties
    private var mapLocation : [MapLocations]? {
        didSet {
            if mapLocation!.count > 0{
                
            for data in mapLocation!{
                    if data.uid != Service.shared.getUserUid(){
                                
                    let coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.log)
                    let pin = MapMarker(coordinate: coordinate)
                    
                    if Int(data.temperature) ?? 0 < 38 {
                         pin.title = "SAFE"
                         
                     } else {
                         pin.title = "RISK"
                     }
                    
                    
                    self.mapView.addAnnotation(pin)
                    
               
                }
                    
                }
  
            }
        }
    }
    
    
    





}



// MARK: - LocationServices


extension MapViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
              locationManager.requestAlwaysAuthorization()
          }
        
    }
}
