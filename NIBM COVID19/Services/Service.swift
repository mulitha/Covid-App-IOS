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
let REF_SURVEY = DB_REF.child("survey")





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
    

    
    func getUserById(completion: @escaping(UserModel) -> Void) {
        
        REF_USERS.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            let firstName = values?["firstName"] as? String ?? ""
            let lastName = values?["lastName"] as? String ?? ""
            let email = values?["email"] as? String ?? ""
            let password = values?["password"] as? String ?? ""
            let accountType = values?["accountType"] as? Int ?? 0
            let country = values?["country"] as? String ?? ""
            let imageUrl = values?["imageUrl"] as? String ?? ""
                        
            let user = UserModel(firstName:firstName as String?, lastName:lastName as String?, email:email as String?, password: password as String?, accountType: accountType as Int?, country: country as String?, imageUrl: imageUrl as String?)
            
            completion(user)
        })
    }
    
    
    func getUserBySpecificId(_ uid :String,completion: @escaping(UserModel) -> Void) {
        
        REF_USERS.child(uid).observe(DataEventType.value, with : { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            let firstName = values?["firstName"] as? String ?? ""
            let lastName = values?["lastName"] as? String ?? ""
            let email = values?["email"] as? String ?? ""
            let password = values?["password"] as? String ?? ""
            let accountType = values?["accountType"] as? Int ?? 0
            let country = values?["country"] as? String ?? ""
            let imageUrl = values?["imageUrl"] as? String ?? ""
                        
            let user = UserModel(firstName:firstName as String?, lastName:lastName as String?, email:email as String?, password: password as String?, accountType: accountType as Int?, country: country as String?, imageUrl: imageUrl as String?)
            
            completion(user)
        })
    }
    
    
    
    
    //Mark: Update user Temperature details
    
    func updateUserTemperture(_ value: [String:Any] )->Int{
            REF_USERLOCATIONS.child(getUserUid()).updateChildValues(value){(error, ref) in }
             return 0
    }
    

    //Get user Temperature details
    func getUserTemperatureDetails(completion: @escaping(MapLocations) -> Void) {
        REF_USERLOCATIONS.child(getUserUid()).observe(DataEventType.value, with : { (snapshot) in

            if let directory = snapshot.value as? [String: Any] {

            for (_, val) in directory{
                   guard let singleData = val as? [String: Any] else {
                       continue
                   }
                                 
               let lat = singleData["lat"]
               let log = singleData["log"]
               let uid = singleData["uid"]
               let temperature = singleData["temperature"] ?? ""
               let syncDateTime = singleData["syncDateTime"] ?? ""
                
                
                completion(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String, temperature:temperature as! String))
                
            }
         
                  
                
                                    
            }
            
            
//                  let singleData = snapshot.value as? [String:AnyObject]
//
//                  let lat = singleData?["lat"]
//                  let log = singleData?["log"]
//                  let uid = singleData?["uid"]
//                  let temperature = singleData?["temperature"] ?? ""
//                  let syncDateTime = singleData?["syncDateTime"] ?? ""
//
//                 let  userTemperatureDetails = (MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String, temperature:temperature as! String))
//
//                 completion(userTemperatureDetails)
//
        
        })
    }
    
    

    
    
    
   
    
    
    
    //post notifications
    func postNotification(_ value: [String:Any])->Int{
        
        guard let key = REFF_NOTIFICATION.childByAutoId().key else { return 1}
        REFF_NOTIFICATION.child(key).updateChildValues(value){(error, ref) in }
        return 0
    }
    
    
    
    func updateUserProfileImage(_ imageurl: String){
        let values = [
          "imageUrl":imageurl
              ]as [String : Any]

        REF_USERS.child(getUserUid()).updateChildValues(values) { (error, ref) in
            print("Successfuly updated user profile image")
        }
    }
    
    
    
    
    //Get all notifications
    func getNotifications(completion: @escaping([notificationModel]) -> Void) {
        var allNotifications = [notificationModel]()
        
        REFF_NOTIFICATION.observe(.childChanged , with: {
            (snapshot) in
            
            REFF_NOTIFICATION.observeSingleEvent(of: .value, with: { snapshot in
                allNotifications.removeAll()
                
                if let directory = snapshot.value as? [String: Any] {
                    for location in directory{
                        guard let singleData = location.value as? [String: Any] else {
                            continue
                        }


                    let description = singleData["description"]
                    let syncDateTime = singleData["syncDateTime"]
                    let uid = singleData["uid"]

                   let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                   allNotifications.append(notification)
                
                    }
                completion(allNotifications)

            
                }
            })
        })
        
            REFF_NOTIFICATION.observeSingleEvent(of: .value, with: { snapshot in
                
                if let directory = snapshot.value as? [String: Any] {
                    for(_, val) in directory{
                        guard let singleData = val as? [String: Any] else {
                            continue
                        }


                    let description = singleData["description"]
                    let syncDateTime = singleData["syncDateTime"]
                    let uid = singleData["uid"]

                   let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                   allNotifications.append(notification)
                
                    }
                completion(allNotifications)

                }
            
            })
   
    }
    
    
    
    
    
    
    
    func getLastNotification(completion: @escaping([notificationModel]) -> Void) {

        var allNotifications = [notificationModel]()
             
            let recentPostsQuery = (REFF_NOTIFICATION.queryLimited(toLast: 1))
        
        
             recentPostsQuery.observe(.childChanged , with: {
                 (snapshot) in
                 
                recentPostsQuery.observeSingleEvent(of: .value, with: { snapshot in
                     allNotifications.removeAll()
                     
                     if let directory = snapshot.value as? [String: Any] {
                         for location in directory{
                             guard let singleData = location.value as? [String: Any] else {
                                 continue
                             }


                         let description = singleData["description"]
                         let syncDateTime = singleData["syncDateTime"]
                         let uid = singleData["uid"]

                        let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                        allNotifications.append(notification)
                     
                         }
                     completion(allNotifications)

                 
                     }
                 })
             })
             
        
                 recentPostsQuery.observeSingleEvent(of: .value, with: { snapshot in
                     
                     if let directory = snapshot.value as? [String: Any] {
                         for(_, val) in directory{
                             guard let singleData = val as? [String: Any] else {
                                 continue
                             }


                         let description = singleData["description"]
                         let syncDateTime = singleData["syncDateTime"]
                         let uid = singleData["uid"]

                        let notification = notificationModel(description:description as! String?, syncDateTime:syncDateTime as! String? , uid:uid as! String?)
                        allNotifications.append(notification)
                     
                         }
                     completion(allNotifications)

                     }
                 
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
        
        REF_USERLOCATIONS.observe(.childChanged , with: {
            (snapshot) in
            
            REF_USERLOCATIONS.observeSingleEvent(of: .value, with: { snapshot in
                mapLocation.removeAll()
                
                if let directory = snapshot.value as? [String: Any] {
                    for loc in directory{
                        guard let singleData = loc.value as? [String: Any] else {
                            continue
                        }
                                                                
                                      
                    let lat = singleData["lat"]
                    let log = singleData["log"]
                    let uid = singleData["uid"]
                    let temperature = singleData["temperature"]
                    let syncDateTime = singleData["syncDateTime"]
                     
                     
                    mapLocation.append(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String, temperature:temperature as! String))
                    
                    completion(mapLocation)
                                    
                                    
                
                    }
                }
            })
        })
        
        
            REF_USERLOCATIONS.observeSingleEvent(of: .value, with: { snapshot in
                
                if let directory = snapshot.value as? [String: Any] {
                    for (_, val) in directory{
                        guard let singleData = val as? [String: Any] else {
                            continue
                        }
                                      
                    let lat = singleData["lat"]
                    let log = singleData["log"]
                    let uid = singleData["uid"]
                    let temperature = singleData["temperature"] ?? ""
                    let syncDateTime = singleData["syncDateTime"] ?? ""
                     
                    mapLocation.append(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String, temperature:temperature as! String))
                    
                    completion(mapLocation)
                                    
                    }
                }
            })
        
                
        
    }

            
            

//             for dataSet in snapshot.children.allObjects as![DataSnapshot]{
//                 let singleData = dataSet.value as? [String:AnyObject]
//
//                 let lat = singleData?["lat"]
//                 let log = singleData?["log"]
//                 let uid = singleData?["uid"]
//                 let temperature = singleData?["temperature"]
//                 let syncDateTime = singleData?["syncDateTime"]
//
//                mapLocation.append(MapLocations(lat: lat as! Double, log: log as! Double, uid: uid as! String, syncDateTime: syncDateTime as! String, temperature:temperature as! String))
//
//             }
//
//             completion(mapLocation)
//
//         })
//
        
        


    
    
    
     
    
    

    
    func getSurveyDetails(completion : @escaping([SurveyModel]) ->Void){
        
        var surveyDetails : [SurveyModel] = []
        
        REF_SURVEY.observe(DataEventType.value, with: { (snapshot) in

            for dataSet in snapshot.children.allObjects as![DataSnapshot]{
                let singleData = dataSet.value as? [String:AnyObject]

                let surveyOneAnswer = singleData?["surveyOneAnswer"] as? Int ?? 0
                let surveyTwoAnswer = singleData?["surveyTwoAnswer"] as? Int ?? 0
                let surveyThreeAnswer = singleData?["surveyThreeAnswer"] as? Int ?? 0
                let surveyFourAnswer = singleData?["surveyFourAnswer"] as? Int ?? 0
                let uid = singleData?["uid"] as? String ?? ""


                surveyDetails.append(SurveyModel(surveyOneAnswer: surveyOneAnswer as Int?, surveyTwoAnswer: surveyTwoAnswer as Int?, surveyThreeAnswer: surveyThreeAnswer as Int?, surveyFourAnswer: surveyFourAnswer as Int?, uid:uid as String? ))
               
            }
            completion(surveyDetails)
        })
    }
    
    
    
    
    
    
}





