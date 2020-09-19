//
//  MapSearchTableViewCell.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/18/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit
import MapKit

class MapSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var placemark: MKPlacemark? {
        didSet {
            locationTitleLabel.text = placemark?.name
//           // addressLabel.text = placemark?.address
           locationAddressLabel.text = placemark?.title
        }
    }

    
}


extension MKPlacemark {
    var address: String? {
        get {
            guard let subThoroughfare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            
            return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea) "
        }
    }
}





