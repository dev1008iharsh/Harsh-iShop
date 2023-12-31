//
//  viewShadow.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class viewShadow: UIButton {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        
        layer.cornerRadius = 10
        //        layer.borderWidth = 0.0
        //        layer.borderColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).cgColor
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10.0
        
        /*
         
         layer.borderWidth = 1
         layer.shadowColor = helper.color_border?.cgColor
         layer.shadowOffset = .zero
         layer.borderColor = UIColor(red: 182/255, green: 183/255, blue: 186/255, alpha: 1.0).cgColor
         layer.shadowOpacity = 0.2
         layer.shadowRadius = 10.0
         
         */
    }
    
    
}
