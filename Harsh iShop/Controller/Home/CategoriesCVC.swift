//
//  CategoriesCVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 13/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class CategoriesCVC: UICollectionViewCell {
    @IBOutlet weak var viewBGCategories: UIView!
    
    @IBOutlet weak var imgCategories: UIImageView!
    @IBOutlet weak var lblCategories: UILabel!
    func viewBGCategoriesShadow()  {
        
    
        viewBGCategories.layer.shadowRadius = 3.0
        viewBGCategories.layer.cornerRadius = 10.0
        
    }
}

