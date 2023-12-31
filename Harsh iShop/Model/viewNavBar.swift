//
//  viewNavBar.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class viewNavBar: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 8)
        layer.shadowOpacity = 0.3
        layer.shadowRadius  = 5
        layer.cornerRadius = 33.33
        clipsToBounds = true
        layer.masksToBounds = false
        
        
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            layer.maskedCorners = [.layerMinXMaxYCorner]
        }else{
            layer.maskedCorners = [.layerMinXMaxYCorner]
            
        }
    }
    
}
