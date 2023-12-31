//
//  btnLng.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class btnLng: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        layer.cornerRadius = 25
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.lightGray.cgColor
        
        
        
    }
    
    
}
