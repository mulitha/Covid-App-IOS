//
//  PopupMessage.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/19/20.
//  Copyright © 2020 mulitha. All rights reserved.
//


import UIKit

class PopupMessages {

    static func generateAlert(title: String, msg: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
}
