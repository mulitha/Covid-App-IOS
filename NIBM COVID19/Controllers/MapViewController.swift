//
//  MapViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var whereToView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        enableLocationServices()
        
//        let getstureRecognozer = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
//        getstureRecognozer.numberOfTouchesRequired = 1
//        getstureRecognozer.numberOfTapsRequired = 1
//        whereToView.addGestureRecognizer(getstureRecognozer)
//        whereToView.isUserInteractionEnabled = true
        
        
  
        
    }
    
    @objc func gestureFired(_ gesture:UITapGestureRecognizer){
        //navigateToMapSearchVS()
        print("HELLO")
    }
    
    
    private func navigateToMapSearchVS(){
        let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
        guard let mainNavigationVC = mianStorybord.instantiateViewController(withIdentifier: "MapSearchViewController") as?
            MapSearchViewController else{
                return
        }
        mainNavigationVC.modalPresentationStyle = .fullScreen
        present(mainNavigationVC,animated: true,completion: nil)
    }
    
    



}



// MARK: - LocationServices

extension MapViewController : CLLocationManagerDelegate {
    func enableLocationServices() {
        
        
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
