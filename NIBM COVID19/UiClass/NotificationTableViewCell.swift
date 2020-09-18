//
//  NotificationTableViewCell.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/13/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

        
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
