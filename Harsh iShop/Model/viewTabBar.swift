//
//  viewTabBar.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class viewTabBar: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
         
       layer.cornerRadius = 25
       layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       layer.shadowColor = UIColor.lightGray.cgColor
       layer.shadowOffset = CGSize(width: 0.0, height: -8.0)
       layer.shadowOpacity = 0.5
       layer.shadowRadius  = 5
        
    }
    
    
    
}
