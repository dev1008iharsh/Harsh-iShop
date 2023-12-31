//
//  txtViewShadow.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import Foundation
import UIKit

class txtViewShadow: UIView {
   
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius =  10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius  = 5
    }
    
}


