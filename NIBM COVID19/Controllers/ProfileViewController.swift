//
//  ProfileViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/13/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
 
    @IBOutlet weak var countryTextField: UITextField!
    var seletedCountry:String?
    var listOfCountry = ["Sri Lanka", "USA","Korea","Japan","India","China","Italy","Singapore","Franch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAndSetupPickerView()
        self.dissmissAndClosePicker()
        

    }
    
    
    
    func createAndSetupPickerView(){
        
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        self.countryTextField.inputView = pickerview
        
    }
    
    
    func dissmissAndClosePicker(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.countryTextField.inputAccessoryView = toolBar

    }
    
    @objc func dismissAction(){
        self.view.endEditing((true))
    }
}



extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listOfCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listOfCountry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.seletedCountry = self.listOfCountry[row]
        self.countryTextField.text = self.seletedCountry
    }
    
    
    
}
