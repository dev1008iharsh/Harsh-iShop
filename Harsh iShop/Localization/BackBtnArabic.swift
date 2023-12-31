//
//  BackBtnArabic.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class BackBtnArabic: UIButton {

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            self.transform = self.transform.rotated(by: .pi)
            
        }else{
            print("")
        }  
    }

}
