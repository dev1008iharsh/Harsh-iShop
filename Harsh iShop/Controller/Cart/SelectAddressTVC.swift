//
//  SelectAddressTVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 20/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class SelectAddressTVC: UITableViewCell {

    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    func viewBGsetup(){

        viewBG.layer.borderColor = UIColor.init(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        viewBG.layer.borderWidth = 1.0
        viewBG.layer.cornerRadius = 15
        viewBG.clipsToBounds = true
        viewBG.layer.masksToBounds = false

    }

}
