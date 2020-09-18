//
//  temperatureModel.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/16/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Firebase



struct temperatureModal {
    let temperature: String
    let syncDate: String
    
    init(dictionary: [String: Any]) {
        self.temperature = dictionary["temperature"] as? String ?? ""
        self.syncDate = dictionary["syncDateTime"] as? String ?? ""
    }
}
