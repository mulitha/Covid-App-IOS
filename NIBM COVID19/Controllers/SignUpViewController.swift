//
//  SignUpViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase
import MapKit


class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var fNameText: UITextField!
    @IBOutlet weak var lNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var accountTypeSegmentControll: UISegmentedControl!
    
    private let locationManager = LocationHandler.shared.locationManager

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        //let leftButton =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        //navigationItem.leftBarButtonItem = leftButton

    }
    
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        
        enableLocationServices()

        
        
        guard let fName = fNameText.text else {return}
        guard let lName = lNameText.text else {return}
        guard let email = emailText.text else {return}
        guard let pwd = passwordText.text else {return}
        let accountType = accountTypeSegmentControll.selectedSegmentIndex
        
        
        let values = [
        "firstName":fName,
        "lastName":lName,
        "email": email,
        "password":pwd,
        "accountType": accountType
        ] as [String : Any]
        
        
        Auth.auth().createUser(withEmail: email, password: pwd) { (result, error) in
            
            if let error = error {
                print("Faild to register user with error \(error)")
                return
            }
                        
            Service.shared.userCreation(values)
            LocationHandler.shared.syncUserLocation()
            self.dismiss(animated: true, completion: nil)

            
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    


    
    
    
    

}



extension SignUpViewController {

func enableLocationServices() {
    
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
        locationManager?.requestWhenInUseAuthorization()
    case .restricted, .denied:
        break
    case .authorizedWhenInUse:
        locationManager?.requestAlwaysAuthorization()
    case .authorizedAlways:
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    default:
        break
    }
}
}
