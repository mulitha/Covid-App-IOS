//
//  SurveyTwoViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/16/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import  Firebase

class SurveyTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func onClickIsYes(_ sender: Any) {
        postData(setSurveyStatus: 1)
        navigateToNext()
    }
    
    @IBAction func onClickIsNope(_ sender: Any) {
        postData(setSurveyStatus: 0)
        navigateToNext()
        
    }
    
    func navigateToNext(){ //navigate without navigation controll

        let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
         guard let surveyTwoVC = mianStorybord.instantiateViewController(withIdentifier: "SurveyThreeViewController") as?
             SurveyThreeViewController else{
                 return
         }

         surveyTwoVC.modalPresentationStyle = .fullScreen
         self.present(surveyTwoVC, animated: true, completion: nil)

    }
    
    
    func postData(setSurveyStatus surveyStatus:Int){
      
      let values = [
        "surveyTwoAnswer":surveyStatus
            ]as [String : Any]
    
          
      let user = Auth.auth().currentUser
      guard let uid = user?.uid else { return }

      Database.database().reference().child("survey").child(uid).updateChildValues(values) { (error, ref) in
          print("Successfuly save data..")
      }

          
    }
    
    
    

}
