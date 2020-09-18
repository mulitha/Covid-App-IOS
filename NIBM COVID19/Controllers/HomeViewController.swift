//
//  HomeViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/11/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
    @IBOutlet weak var latestNotificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastNotification()
        
    }
    

    
    
    
    //MARK: Properties
    private var lastNotification : [notificationModel]? {
        didSet {
            if lastNotification?.count ?? 0 > 0{
                latestNotificationLabel.text = lastNotification?[0].description
            }
        }
    }

    
    //Mark: API
    
    func getLastNotification(){
        Service.shared.getLastNotification{ (allNotification) in
            self.lastNotification = allNotification
        }
    }



}
