//
//  NotificationTableViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/13/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit



class NotificationTableViewController: UITableViewController {
    
    @IBOutlet var notificationTableView: UITableView!
    var notifications =  [notificationModel]()



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllNotifications()
    }
    
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        cell.notificationLabel.text = notifications[indexPath.row].description
        return cell
    }
    
    
    
    //MARK: Properties
    private var allNotification : [notificationModel]? {
        didSet {
            if allNotification!.count > 0{
                notifications.removeAll()
                notifications = allNotification ?? [notificationModel]()
                notificationTableView.reloadData()
            }
        }
    }
    
    
    
    
    //Mark: API
    
    func getAllNotifications(){
        Service.shared.getNotifications{ (allNotification) in
            self.allNotification = allNotification
            }
    }



 

}
