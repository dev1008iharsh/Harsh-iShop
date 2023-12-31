//
//  NotificationTVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 27/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
