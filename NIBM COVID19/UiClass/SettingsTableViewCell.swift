//
//  SettingsTableViewCell.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/17/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

protocol OptionButtonsDelegate{
    func closeFriendsTapped(at index:IndexPath)
}

class SettingsTableViewCell: UITableViewCell {
    
    
    var delegate:OptionButtonsDelegate!
    @IBOutlet weak var closeFriendsBtn: UIButton!
    var indexPath:IndexPath!
    @IBAction func closeFriendsAction(_ sender: UIButton) {
        self.delegate?.closeFriendsTapped(at: indexPath)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}



