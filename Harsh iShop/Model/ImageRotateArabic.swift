//
//  ImageRotateArabic.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 31/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class ImageRotateArabic: UIImageView {

    required init?(coder aDecoder: NSCoder) {
           
           super.init(coder: aDecoder)
           
           if LanguageChanger.currentAppleLanguage() == "ar" {
               
            self.transform = self.transform.rotated(by: CGFloat(Double.pi))
               
           }
           
       }

}
