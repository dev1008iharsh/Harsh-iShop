//
//  btnFullWidthShadow.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 22/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class btnFullWidthShadow: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
//        layer.cornerRadius = 22.5
//        clipsToBounds = true
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.red.cgColor
//        layer.shadowOffset = .zero
//        layer.shadowOpacity = 0.4
//        layer.shadowRadius  = 10
        
        
        layer.cornerRadius = 22.5
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
        
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOffset = .zero
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius  = 10
        
    }
    
}
