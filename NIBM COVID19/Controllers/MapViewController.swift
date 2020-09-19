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
        getAllTemperatureDetails()
        
    }
    
    func pingUserLocations(){
        Service.shared.getLocationUpdates{ (mapLocation) in
            self.mapLocation = mapLocation
        }
    }
    
    
    func getAllTemperatureDetails() {
            Service.shared.getAllTemperatureDetails { (temperature) in
                self.userTemperatureDetails = temperature
            }
    }
    
    
    private var userTemperatureDetails: [temperatureModal]? {
        didSet {
            pingUserLocations()
        }
    }
    
    
    
    
    
    //MARK: Properties
    private var mapLocation : [MapLocations]? {
        didSet {
            if mapLocation!.count > 0{
                
            for data in mapLocation!{
                    if data.uid == Service.shared.getUserUid(){
                        self.mapView.addAnnotation(mLocation)
                        continue
                    }

                    Service.shared.getSpecificUserTemperatureDetails(data.uid) { (userTemperatureDetails) in
                        self.userTemp = Double(userTemperatureDetails.temperature)!
                    }
                    
                    let coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.log)
                    let pin = MapMarker(coordinate: coordinate)
                    
                    if self.userTemp < 36 {
                         pin.title = "SAFE"
                         
                     } else {
                         pin.title = "RISK"
                     }
                    
                    
                    self.mapView.addAnnotation(pin)
                    
//                    //zooming
//                    let cordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(data.lat, data.log)
//                    let span = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
//                    let region = MKCoordinateRegion(center: cordinate,span: span)
//                    self.mapView.setRegion(region, animated: true)
                    
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
