//
//  UserModel.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/19/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Foundation




struct UserModel {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var accountType: Int?
    var country: String?
    var imageUrl: String?
    
    init(firstName: String?, lastName: String?, email: String?, password: String?, accountType: Int?, country: String?, imageUrl: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.accountType = accountType
        self.country = country
        self.imageUrl = imageUrl
    }
}
