//
//  SettingsViewController.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/17/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController  {

        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    func navigateToSignUp(){
        
        DispatchQueue.main.async {
                                    
            let mianStorybord = UIStoryboard(name:"Main", bundle: Bundle.main)
            guard let signInVC = mianStorybord.instantiateViewController(withIdentifier: "LoginViewController") as?
                LoginViewController else{
                    return
            }
            
            let navigation = UINavigationController(rootViewController: signInVC)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation,animated: true,completion: nil)

        }
        
        
    }
    
    
    
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if(Service.shared.getUserUid() == "") {
                if indexPath.row == 0 {
                    return 0
                }
            }else{
                if indexPath.row == 1 {
                    return 0
                }
            }
        return tableView.rowHeight
    
    }
    
  



}


