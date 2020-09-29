//
//  InfoUpdateViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/15/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase



class InfoUpdateViewController: UIViewController {
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempLastUpdateTimeLabel: UILabel!
    @IBOutlet weak var tempSlider: UISlider!
    
    @IBOutlet weak var CreateNotificationView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageVaigationControll(isVisible:false)
            

            
            
        checkIsUserLoginIn()

    }
    
    
    @IBAction func onSliderChange(_ sender: Any) {
        tempLabel.text = String(Int(tempSlider.value))
    }
    
    
    @IBAction func onClickNewSurvey(_ sender: Any) {
    
               let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
                guard let surveyOneVC = mianStorybord.instantiateViewController(withIdentifier: "SurveyOnesViewController") as?
                    SurveyOnesViewController else{
                        return
                }

                surveyOneVC.modalPresentationStyle = .fullScreen
                self.present(surveyOneVC, animated: true, completion: nil)
    }
    
    

    
    @IBAction func onClickUpdate(_ sender: Any) {
        
                
        let userTemperatureInfoArray = [
            "temperature": tempLabel.text ?? "",
            "syncDateTime": DateConvertion.shared.stringFromDate(Date()),
            "uid":Service.shared.getUserUid()
        ]as [String : Any]
        
        
       let usertempartureStatus = Service.shared.updateUserTemperture(userTemperatureInfoArray)
       print(usertempartureStatus)
        

    }
    
    
    
    
    
    //MARK: Properties

    private var userTemperatureDetails: MapLocations? {
        didSet {
            
            let Days = DateConvertion.shared.dateFromString(userTemperatureDetails!.syncDateTime)
            
            if Days != ""{
                tempLabel.text = userTemperatureDetails?.temperature
                tempSlider.value = Float(tempLabel.text ?? "0") ?? 0
                tempLastUpdateTimeLabel.text = ("Last updated on " + Days )
            }

        }
    }
 
    
    
    
    //MARK: API
    
    func checkIsUserLoginIn(){
        
        if(Service.shared.getUserUid() == "") {

            DispatchQueue.main.async {
                                        
                let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
                guard let signInVC = mianStorybord.instantiateViewController(withIdentifier: "LoginViewController") as?
                    LoginViewController else{
                        return
                }
                
                signInVC.callbackClosure = { [weak self] in
                    
                    DispatchQueue.main.async {
                        
                        if Service.shared.getUserUid() != "" {
                            self!.getUserTemperatureDetails()
                            self!.getUserData()
                        }
                        

                        
                    }
                }
                
                let navigation = UINavigationController(rootViewController: signInVC)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation,animated: true,completion: nil)

            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.getUserTemperatureDetails()
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
            if user?.accountType == 0{
                CreateNotificationView.isHidden = true
            }
           }
       }
    
    
    
    func getUserTemperatureDetails() {
            Service.shared.getUserTemperatureDetails { (userTemperatureDetails) in
                self.userTemperatureDetails = userTemperatureDetails
            }
    }
    
    

    
    

    //Mark: Helping function
        
    func manageVaigationControll(isVisible visible:Bool){
            self.navigationController?.navigationBar.isHidden = visible
    }
    

    

    
 
    


}
