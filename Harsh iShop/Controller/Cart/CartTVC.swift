//
//  CartTVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 21/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class CartTVC: UITableViewCell {

    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
