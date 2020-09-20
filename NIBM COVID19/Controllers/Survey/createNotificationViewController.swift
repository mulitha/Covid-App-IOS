//
//  createNotificationViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/19/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class createNotificationViewController: UIViewController {

    
    @IBOutlet weak var Msg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSendMsg(_ sender: Any) {
        
        guard let msg = Msg.text else {return}
        
        if msg == ""{
            self.present(PopupMessages.generateAlert(title: "Message", msg: "message canot be empty"), animated: false)
            return
        }
        
        let notificationArray = [
        "uid": Service.shared.getUserUid(),
        "description": msg,
        "syncDateTime":DateConvertion.shared.stringFromDate(Date())
        ]as [String:Any]
        
       let status = Service.shared.postNotification(notificationArray)
       print(status)
       Msg.text = nil

        
    }
    

    @IBAction func onClearMsg(_ sender: Any) {
        Msg.text = nil
    }
    
}
