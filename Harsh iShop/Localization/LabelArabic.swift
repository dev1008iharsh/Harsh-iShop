//
//  LabelArabic.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 10/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class LabelArabic: UILabel {

  required init?(coder aDecoder: NSCoder) {
         
         super.init(coder: aDecoder)
         
         if LanguageChanger.currentAppleLanguage() == "ar" {
         
             self.textAlignment = .right
         }else{
             self.textAlignment = .left

         }

     }
}
