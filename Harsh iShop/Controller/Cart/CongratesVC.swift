//
//  CongratesVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 24/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftGifOrigin

class CongratesVC: UIViewController {

    @IBOutlet weak var imgGif: UIImageView!
    @IBOutlet weak var lblYourOrderId: UILabel!
    
    var strOrderId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblYourOrderId.text = "#\(strOrderId)"
        imgGif.loadGif(name: "congrats")
        
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
         
        self.navigationController?.pushViewController(nextVC, animated: true)
      
    }
    

}
 
