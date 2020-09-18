//
//  Service.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/16/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let RFF_TEMPINFO = DB_REF.child("TemperatureDetails")
let REFF_NOTIFICATION = DB_REF.child("Notifications")


var allNotification = [notificationModel]()



struct Service {
    
    static let shared = Service()


    func getUserUid() ->String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    
    
    func signOut() ->String {
        do {
            try Auth.auth().signOut()
            return "user signOut"
        } catch {
            return "DEBUG: sign out error"
        }
    }
    
    
    
    //Mark: Update user Temperature details
    
    func updateUserTemperture(_ value: [String:Any] )->Int{
            RFF_TEMPINFO.child(getUserUid()).updateChildValues(value){(error, ref) in }
             return 0
    }
    

    //Get user Temperature details
    func getUserTemperatureDetails(completion: @escaping(temperatureModal) -> Void) {
        RFF_TEMPINFO.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let userTemperatureDetails = temperatureModal(dictionary: dictionary)
            completion(userTemperatureDetails)
        })
    }
    
    //post notifications
    func postNotification(_ value: [String:Any])->Int{
        
        guard let key = REFF_NOTIFICATION.childByAutoId().key else { return 1}
        REFF_NOTIFICATION.child(key).updateChildValues(value){(error, ref) in }
        return 0
    }
    
    
    
    
    //Get all notifications
    func getNotifications(completion: @escaping([notificationModel]) -> Void) {
        
        allNotification.removeAll()
        
        REFF_NOTIFICATION.observe(DataEventType.value, with: { (snapshot) in

            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
                let singleData = dataSet.value as? [String:AnyObject]

                let description = singleData?["description"]
                let syncDateTime = singleData?["syncDateTime"]
                let uid = singleData?["uid"]

               let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                allNotification.append(notification)
            }
            
            completion(allNotification)
            
        })
 
    }
    
    
    
    
    
    
    
    func getLastNotification(completion: @escaping([notificationModel]) -> Void) {

        allNotification.removeAll()

        let recentPostsQuery = (REFF_NOTIFICATION.queryLimited(toLast: 1))
        recentPostsQuery.observe(DataEventType.value, with: { (snapshot) in

            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
                let singleData = dataSet.value as? [String:AnyObject]

                let description = singleData?["description"]
                let syncDateTime = singleData?["syncDateTime"]
                let uid = singleData?["uid"]

               let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                allNotification.append(notification)
            }

            completion(allNotification)


        })

    }

}





