//
//  StoriesCVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 13/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class StoriesCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgStories: UIImageView!
    @IBOutlet weak var lblStories: UILabel!
    func viewBGSetup()  {

        //btnFav.isHidden = !UserDefaults.standard.bool(forKey: "isLoggedIn")
          
        
   
        viewBG.layer.shadowRadius = 3.0
        viewBG.clipsToBounds = true
        viewBG.layer.masksToBounds = false
        viewBG.layer.cornerRadius = 40

        imgStories.contentMode = .scaleAspectFill
        
        

    }
}

