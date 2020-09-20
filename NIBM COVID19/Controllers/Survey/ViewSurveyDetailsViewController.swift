//
//  ViewSurveyDetailsViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/20/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class ViewSurveyDetailsTableViewController: UITableViewController {

    var surveyUser : [SurveyUserModel] = []
    var surveyUserModel : UserModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSurveyDetails()
    }
    


func getSurveyDetails(){
    
    Service.shared.getSurveyDetails{ (surveyDetails) in
        self.surveyDetails = surveyDetails
    }
    
}



private var surveyDetails : [SurveyModel]? {

    didSet {
        
        if surveyDetails!.count > 0{
            
        for data in surveyDetails!{
            
            DispatchQueue.main.async {
                Service.shared.getUserBySpecificId(data.uid ?? "") { (user) in
                  self.user = user
                }
            }
            

            let surveyInfo = SurveyUserModel(surveyOneAnswer: data.surveyOneAnswer , surveyTwoAnswer: data.surveyTwoAnswer, surveyThreeAnswer: data.surveyThreeAnswer, surveyFourAnswer: data.surveyFourAnswer , uid: data.uid, firstName: self.user?.firstName, lastName: self.user?.lastName, email: self.user?.email, password: self.user?.password, accountType: self.user?.accountType, country: self.user?.country, imageUrl: self.user?.country  )
            surveyUser.append(surveyInfo)

            }
            
            
            print(surveyUser)
            
        }

        
    }


}
    
    
    
    
    func getUserData(_ uid:String) {
          Service.shared.getUserBySpecificId(uid) { (user) in
            self.user = user
          }
      }
    
    
    private var user: UserModel? {
          didSet {
              
            self.surveyUserModel?.firstName = user?.firstName
            self.surveyUserModel?.lastName = user?.lastName
            self.surveyUserModel?.accountType = user?.accountType
            self.surveyUserModel?.email = user?.email
            self.surveyUserModel?.imageUrl = user?.imageUrl
       
          }
      }
      
    
    





}
