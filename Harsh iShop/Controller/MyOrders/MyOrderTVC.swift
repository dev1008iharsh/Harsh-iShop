//
//  MyOrderTVC.swift
//  E-Commerce Order - OrderDetail
//
//  Created by Harsh iOS Developer on 03/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class MyOrderTVC: UITableViewCell {
    
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblOrderid: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func configCell1(){
        viewBG.layer.cornerRadius = 10
        viewBG.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
      
        viewBG.layer.shadowOffset = .zero
        viewBG.clipsToBounds = true
      
    }
}
