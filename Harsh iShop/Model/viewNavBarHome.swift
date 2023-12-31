//
//  viewNavBarHome.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class viewNavBarHome: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        layer.cornerRadius = 25
        
       
        layer.shadowRadius  = 5
        layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            layer.maskedCorners = [.layerMaxXMaxYCorner]
        }else{
            layer.maskedCorners = [.layerMinXMaxYCorner]
            
        }
    }
}
