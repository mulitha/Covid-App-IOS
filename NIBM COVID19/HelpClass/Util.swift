//
//  Util.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/26/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit


fileprivate var activityView : UIView?

extension UIViewController{
    
    func showSpinner(){
        
         activityView = UIView(frame:self.view.bounds)
         activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
        
        
    }
    
    
    func removeSpinner(){
        activityView?.removeFromSuperview()
        activityView = nil
        
    }
    
}
