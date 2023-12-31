//
//  viewBottomRound.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 22/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class viewBottomRound: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius =  10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}
