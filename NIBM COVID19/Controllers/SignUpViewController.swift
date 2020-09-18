//
//  SignUpViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/14/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
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
            guard let uid = result?.user.uid else { return }
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                print("Successfuly Registerd and save data..")
            }
            
        }
        
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
