//
//  btnCorner.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class btnCorner: UIButton {

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

       
        layer.cornerRadius = 18
        clipsToBounds = true
      
    }

}
