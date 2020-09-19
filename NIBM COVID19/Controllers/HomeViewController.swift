//
//  HomeViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/11/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation




class HomeViewController: UIViewController {

    private let locationManager = CLLocationManager()
    @IBOutlet weak var homeMapView: MKMapView!
    @IBOutlet weak var latestNotificationLabel: UILabel!
    
    var mLocation : MapMarker!
    var mapLocations : [MapLocations] = []
    var userTemp:Double = 0
    var lati: Double = 0
    var long: Double = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Service.shared.signOut()

        homeMapView.showsUserLocation = true
        homeMapView.userTrackingMode = .follow
        enableLocationServices()
        getLastNotification()
        syncUserlocation()
        
        mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long))
        getAllTemperatureDetails()
    }
    

    func syncUserlocation(){
        if(Service.shared.getUserUid() != "") {
            DispatchQueue.main.async {
                LocationHandler.shared.syncUserLocation()
            }
        }
    }
    
    
    
    //MARK: Properties
    private var lastNotification : [notificationModel]? {
        didSet {
            if lastNotification?.count ?? 0 > 0{
                latestNotificationLabel.text = lastNotification?[0].description
            }
        }
    }

    
    //Mark: API
    
    func getLastNotification(){
        Service.shared.getLastNotification{ (allNotification) in
            self.lastNotification = allNotification
        }
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
                    
                    self.homeMapView.addAnnotation(pin)

                    }
                }
            }
        }
        
}




// MARK: - LocationServices


extension HomeViewController: CLLocationManagerDelegate {
    
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

