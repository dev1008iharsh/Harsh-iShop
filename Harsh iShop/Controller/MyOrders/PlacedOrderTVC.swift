//
//  PlacedOrderTVC.swift
//  E-Commerce Order - OrderDetail
//
//  Created by Harsh iOS Developer on 03/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class PlacedOrderTVC: UITableViewCell {
    
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func configCell2(){
        
        
        
        viewBG.layer.shadowColor = UIColor.darkGray.cgColor
        viewBG.layer.shadowOpacity = 0.5
        viewBG.layer.shadowOffset = .zero
      
    }
    
}
