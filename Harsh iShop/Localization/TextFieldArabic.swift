//
//  TextFieldArabic.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class TextFieldArabic: UITextField {

     required init?(coder aDecoder: NSCoder) {
           
           super.init(coder: aDecoder)
           
           if LanguageChanger.currentAppleLanguage() == "ar" {
            
               self.textAlignment = .right
            
           }else{
               self.textAlignment = .left
               
           }
           
       }

}
