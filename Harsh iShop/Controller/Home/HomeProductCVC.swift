//
//  ProductCVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 10/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class HomeProductCVC: UICollectionViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnFav: UIButton!

    
    @IBOutlet weak var viewProductDetail: UIView!
    
    @IBOutlet weak var viewBG: UIView!
    func viewBGShadow()  {

        //btnFav.isHidden = !UserDefaults.standard.bool(forKey: "isLoggedIn")
          
    
        viewBG.layer.shadowOpacity = 0.5
        viewBG.layer.shadowRadius = 3.0
        viewBG.layer.cornerRadius = 10.0
        

    }
}

