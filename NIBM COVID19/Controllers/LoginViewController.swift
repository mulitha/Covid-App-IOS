//
//  LoginViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class LoginViewController: UIViewController {
    
    
    private let locationManager = CLLocationManager()
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var callbackClosure: (() -> Void)?

        override func viewWillDisappear(_ animated: Bool) {
           callbackClosure?()
            }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        enableLocationServices()
        
        
//        let leftButton =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.dismissAction))
//        navigationItem.leftBarButtonItem = leftButton
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
        guard let email = emailText.text else{return}
        guard let pwd = passwordText.text else{return}
        
        if email == ""{
            self.present(PopupMessages.generateAlert(title: "SignIn", msg: "Email cannot be blank"), animated: false)
            return
        }
        else if pwd == ""{
            self.present(PopupMessages.generateAlert(title: "SignIn", msg: "Password cannot be blank"), animated: false)
            return
        }

        Auth.auth().signIn(withEmail: email, password: pwd) { (result, error) in
            if let error = error {
                print("Faild to register user with error \(error)")
                self.present(PopupMessages.generateAlert(title: "SignIn", msg: "Please check your email and password"), animated: false)
                return
            }
            
            DispatchQueue.main.async {
                LocationHandler.shared.syncUserLocation()
                self.dismiss(animated: true, completion: nil)
            }
            

            
        }
    }
    
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
                
        let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
        guard let signUpVC = mianStorybord.instantiateViewController(withIdentifier: "SignUpViewController") as?
            SignUpViewController else{
                return
        }
//        let navigation = UINavigationController(pushView: mainNavigationVC)
//        navigation.modalPresentationStyle = .fullScreen
//        self.present(navigation, animated: true, completion: nil)

       self.navigationController!.pushViewController(signUpVC, animated: true)
        
    }
    
    
    
    
     @objc func dismissAction(){
         self.dismiss(animated: true, completion: nil)
     }
    
}



extension LoginViewController : CLLocationManagerDelegate {


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
