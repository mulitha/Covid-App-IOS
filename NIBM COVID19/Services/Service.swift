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
let REF_USERLOCATIONS = DB_REF.child("userLocationDetails")


var allNotification = [notificationModel]()



struct Service {
    
    static let shared = Service()


    func getUserUid() ->String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    
    
    func signOut() ->Int {
        do {
            try Auth.auth().signOut()
            return 0
        } catch {
            return 1
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
    
    
    //Get all Temperature details
    func getAllTemperatureDetails(completion: @escaping([temperatureModal]) -> Void) {
        
        var temperature : [temperatureModal] = []
        temperature.removeAll()
        
        
        RFF_TEMPINFO.observe(DataEventType.value, with : { (snapshot) in
            
                for dataSet in snapshot.children.allObjects as![DataSnapshot]{
                    let dictionary = dataSet.value as? [String:AnyObject]

                    let notification = temperatureModal(dictionary:dictionary!)
                    temperature.append(notification)
                    
                }
            
            completion(temperature)
    
        })
    }
    
    
    
    //Get user Temperature details
    func getSpecificUserTemperatureDetails(_ uid :String, completion: @escaping(temperatureModal) -> Void) {
        RFF_TEMPINFO.child(uid).observe(DataEventType.value, with : { (snapshot) in
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
    
    
    func userCreation(_ value: [String:Any] )->Void{
            REF_USERS.child(getUserUid()).updateChildValues(value){(error, ref) in }
    }
    

    func syncUserLocation(_ value: [String:Any] ) ->Void{
        print(getUserUid())
        REF_USERLOCATIONS.child(getUserUid()).updateChildValues(value){(error, ref) in }
    }
    

    func getLocationUpdates(completion: @escaping([MapLocations]) -> Void) {
        var mapLocation : [MapLocations] = []

        mapLocation.removeAll()
         
         REF_USERLOCATIONS.observe(DataEventType.value, with: { (snapshot) in

             for dataSet in snapshot.children.allObjects as![DataSnapshot]{
                 let singleData = dataSet.value as? [String:AnyObject]

                 let lat = singleData?["lat"]
                 let log = singleData?["log"]
                 let uid = singleData?["uid"]
                 let syncDateTime = singleData?["syncDateTime"]
                
                                        
                mapLocation.append(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String))
                
             }
             
             completion(mapLocation)
             
         })
        

        }
    
    
    
    

}





