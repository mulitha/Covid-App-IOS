//
//  ButtonUi.swift
//  NIBM COVID19
//
//  Created by mulitha on 9/11/20.
//  Copyright © 2020 mulitha. All rights reserved.
//

import UIKit

class ButtonUi : UIButton{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        layer.cornerRadius  = frame.size.height/2
    }
    
    
    
}
