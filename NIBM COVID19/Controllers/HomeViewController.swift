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
    @IBOutlet weak var userImg: UIImageView!
    
    var mLocation : MapMarker!
    var mapLocations : [MapLocations] = []
    var userTemp:Double = 0
    var lati: Double = 0
    var long: Double = 0
    
    
    @IBOutlet weak var safePeople: UILabel!
    @IBOutlet weak var infectedPeople: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Service.shared.signOut()
        enableLocationServices()
        homeMapView.showsUserLocation = true
        homeMapView.userTrackingMode = .follow
        
        userImg.roundImageView()

        getLastNotification()
        syncUserlocation()
        
        mLocation = MapMarker(coordinate: CLLocationCoordinate2D(latitude: lati, longitude: long))
        pingUserLocations()
        
    }
    

    

    func syncUserlocation(){
        if(Service.shared.getUserUid() != "") {
            DispatchQueue.main.async {
                LocationHandler.shared.syncUserLocation()
                self.getUserData()
            }
        }
    }
    
    func getUserData() {
          Service.shared.getUserById { (user) in
              self.user = user
          }
      }
    
        private var user: UserModel? {
            didSet {
                if let profileImgUrl = user?.imageUrl {
                    if let url = URL(string:profileImgUrl){
                        downloadImage(from: url)
                    }
                }
            }
        }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.userImg.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
           URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
                    
                    var safeCount = 0
                    var infectedCount = 0
                    
                for data in mapLocation!{
                        if data.uid != Service.shared.getUserUid(){
                            
                        let coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.log)
                        let pin = MapMarker(coordinate: coordinate)
                        
                            if Int(data.temperature) ?? 0 < 38 {
                             pin.title = "SAFE"
                            safeCount += 1
                         } else {
                             pin.title = "RISK"
                            infectedCount += 1
                         }
                    
                    self.homeMapView.addAnnotation(pin)
                            
                    }

                    }
                    safePeople.text = String(safeCount)
                    infectedPeople.text = String(infectedCount)
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
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.present(PopupMessages.generateAlert(title: "Location", msg: error.localizedDescription), animated: false)
    }
    
    
}



