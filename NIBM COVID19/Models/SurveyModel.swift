//
//  SurveyModel.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/20/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Foundation

struct SurveyModel {
    
    var surveyOneAnswer: Int?
    var surveyTwoAnswer: Int?
    var surveyThreeAnswer: Int?
    var surveyFourAnswer: Int?
    var uid : String?

    
    init(surveyOneAnswer: Int?, surveyTwoAnswer: Int?, surveyThreeAnswer: Int?, surveyFourAnswer: Int? , uid: String?) {
        self.surveyOneAnswer = surveyOneAnswer
        self.surveyTwoAnswer = surveyTwoAnswer
        self.surveyThreeAnswer = surveyThreeAnswer
        self.surveyFourAnswer = surveyFourAnswer
        self.uid = uid
    }
}



struct SurveyUserModel {
    
    var surveyOneAnswer: Int?
    var surveyTwoAnswer: Int?
    var surveyThreeAnswer: Int?
    var surveyFourAnswer: Int?
    var uid : String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var accountType: Int?
    var country: String?
    var imageUrl: String?

    
    init(surveyOneAnswer: Int?, surveyTwoAnswer: Int?, surveyThreeAnswer: Int?, surveyFourAnswer: Int? , uid: String?, firstName: String?, lastName: String?, email: String?, password: String?, accountType: Int?, country: String?, imageUrl: String?) {
        self.surveyOneAnswer = surveyOneAnswer
        self.surveyTwoAnswer = surveyTwoAnswer
        self.surveyThreeAnswer = surveyThreeAnswer
        self.surveyFourAnswer = surveyFourAnswer
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.accountType = accountType
        self.country = country
        self.imageUrl = imageUrl
    }
}




