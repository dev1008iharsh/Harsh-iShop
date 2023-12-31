//
//  ProfileImageConfig.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 01/08/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class ProfileImageConfig: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
        
        
    }
    

}
