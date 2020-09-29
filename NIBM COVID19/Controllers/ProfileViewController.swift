//
//  ProfileViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/13/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnUploadImg: UIButton!
    @IBOutlet weak var image: UIImageView!
    private let storage = Storage.storage().reference()
    @IBOutlet weak var countryTextField: UITextField!
    
    
    @IBOutlet weak var FName: UITextField!
    @IBOutlet weak var LName: UITextField!
    @IBOutlet weak var Country: UITextField!
    
    var seletedCountry:String?
    var listOfCountry = ["Sri Lanka", "USA","Korea","Japan","India","China","Italy","Singapore","Franch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAndSetupPickerView()
        self.dissmissAndClosePicker()
        
        image.roundImageView()
        getUserData()
        
    }
    
    
    func getUserData() {
          Service.shared.getUserById { (user) in
              self.user = user
          }
      }
    
    
    private var user: UserModel? {
        didSet {
            
            FName.text = user?.firstName
            LName.text = user?.lastName
            Country.text = user?.country
            
            if let profileImgUrl = user?.imageUrl {
                if let url = URL(string:profileImgUrl){
                    downloadImage(from: url)
                }
            }
        }
    }
    
    

    
    @IBAction func onLogOut(_ sender: Any) {
        
        if (Service.shared.signOut() == 0){
            
            DispatchQueue.main.async {
                                        
                let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
                guard let signInVC = mianStorybord.instantiateViewController(withIdentifier: "LoginViewController") as?
                    LoginViewController else{
                        return
                }
                
                let navigation = UINavigationController(rootViewController: signInVC)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation,animated: true,completion: nil)

            }
            
        }
        
        
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
    
    
    
       @IBAction func onUpdateUser(_ sender: Any) {

            guard let fname = FName.text else {return}
            guard let lname = LName.text else {return}
            guard let country = Country.text else {return}
        
        
        if fname == ""{
            self.present(PopupMessages.generateAlert(title: "Profile", msg: "First name cannot be embty"), animated: false)
            return
        }
        else if lname == ""{
              self.present(PopupMessages.generateAlert(title: "Profile", msg: "Last name cannot be embty"), animated: false)
              return
        }
   
        

            let values = [
            "firstName":fname,
            "lastName":lname,
            "country":country
            ] as [String : Any]

            Service.shared.userCreation(values)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
            picker.dismiss(animated: true, completion: nil)
        }
    
    
    
    

    @IBAction func onBtnUploadImageClick(_ sender: Any) {
        
        let picker = UIImagePickerController()
         picker.sourceType = .photoLibrary
         picker.delegate = self
         picker.allowsEditing = true
         present(picker, animated: true)
        
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.image.image = UIImage(data: data)
                
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
           URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker.dismiss(animated: true, completion: nil)
        self.showSpinner()

        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        
        guard let imageData = image.pngData() else{
            return
        }
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        
        storage.child(uid).child("file.png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            
            self.storage.child(uid).child("file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                
                
                if let urlString : String = url.absoluteString{
                    print("Image URL: \(urlString)")
                    self.downloadImage(from: URL(string:urlString)!)
                    UserDefaults.standard.set(urlString, forKey: "url")
                    
                    Service.shared.updateUserProfileImage(urlString)
                    self.removeSpinner()

                }
            })
        })
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
