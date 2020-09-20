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
import CoreLocation


class SignUpViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    @IBOutlet weak var fNameText: UITextField!
    @IBOutlet weak var lNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var accountTypeSegmentControll: UISegmentedControl!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = false
        //let leftButton =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        //navigationItem.leftBarButtonItem = leftButton

    }
    
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        
        enableLocationServices()

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard let fName = fNameText.text else {return}
        guard let lName = lNameText.text else {return}
        guard let email = emailText.text else {return}
        guard let pwd = passwordText.text else {return}
        let accountType = accountTypeSegmentControll.selectedSegmentIndex
        
        
        if fName == ""{
            self.present(PopupMessages.generateAlert(title: "SignUp", msg: "First name cannot be blank"), animated: false)
             return
        }
        else if lName == ""{
            self.present(PopupMessages.generateAlert(title: "SignUp", msg: "Last name cannot be blank"), animated: false)
             return
        }
        else if email == ""{
            self.present(PopupMessages.generateAlert(title: "SignUp", msg: "Email address cannot be blank"), animated: false)
             return
        }
            
        
         else if (emailPred.evaluate(with: email) == false){
            self.present(PopupMessages.generateAlert(title: "SignUp", msg: "Enter valid email address"), animated: false)
             return
        }
            

        else if pwd == ""{
            self.present(PopupMessages.generateAlert(title: "SignUp", msg: "Password cannot be blank"), animated: false)
             return
        }
  
        
        
        let values = [
        "firstName":fName,
        "lastName":lName,
        "email": email,
        "password":pwd,
        "accountType": accountType
        ] as [String : Any]
        
        
        Auth.auth().createUser(withEmail: email, password: pwd) { (result, error) in
            
            if let error = error {
                self.present(PopupMessages.generateAlert(title: "SignUp", msg: error.localizedDescription), animated: false)
                return
            }
                        
            Service.shared.userCreation(values)
            LocationHandler.shared.syncUserLocation()
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)


            
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    


    
    
    
    

}



extension SignUpViewController : CLLocationManagerDelegate{


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
