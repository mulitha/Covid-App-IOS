//
//  DateConvertion.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/16/20.
//  Copyright © 2020 mulitha. All rights reserved.
//
import UIKit

struct DateConvertion {
    
    static let shared = DateConvertion()
    let formatter = DateFormatter()



    func stringFromDate(_ date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    
    func dateFromString(_ date: String) -> String{
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateFrom =  formatter.date(from: date)!
        let timeIntervalInSeconds = Date().timeIntervalSince(dateFrom)
        
        let secondsInAMinute = 60;
        let secondsInAnHour  = 60 *  secondsInAMinute;
        let secondsInADay    = 24 * secondsInAnHour;

        // extract days
        let days = timeIntervalInSeconds/Double(secondsInADay)
        let hours = Int(timeIntervalInSeconds / 3600)
        let minitues = Int(timeIntervalInSeconds / Double(secondsInAMinute))
        
        
        if Int(days) > 0{
            return String(Int(days)) + " Days ago"
        }
        else if hours > 0{
            return String(hours)  + " Hours ago"
        }
        else if minitues > 0{
            return String(minitues)  + " Minutes ago"
        }
        else {return " Gust now"}
        

    }
    
    
}
