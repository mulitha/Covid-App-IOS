//
//  NotificationModel.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/16/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

struct notificationModel {
    
    let description: String?
    let syncDateTime: String?
    let uid: String?

    
    init(description:String? , syncDateTime:String?, uid:String? ) {
        self.description = description;
        self.syncDateTime = syncDateTime;
        self.uid = uid;
    }
}
