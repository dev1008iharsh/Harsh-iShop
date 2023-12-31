//
//  Constant.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

let helper = Constant()

class Constant: NSObject {
    
    let baseUrl = "http://dev.tilva-artsoft.com/ecommerce_demo/"
    var alertTitle = "Oops!"
    var alertTryAgain = "Try Again"
    
    var mdictUserDetails : Dictionary<String, JSON> = [:]
    
 
    var mdictProductdetail : Dictionary<String, JSON> = [:]

    var emptyDict: [String: JSON] = [:]

    var emmptyDict: Dictionary = [String: JSON]()
    
    var isSkipped = false
    
//
    
    //*** Colors
    
    let color_red: UIColor = UIColor(red: 0.929, green: 0.110, blue: 0.141, alpha: 1)
    
    
    //* Order Button Status Color
    let color_Pending: UIColor = UIColor(red: 0.149, green: 0.867, blue: 0.863, alpha: 1)
    let color_In_Progress = UIColor(red: 0.984, green: 0.541, blue: 0.388, alpha: 1)
    let color_On_The_Way = UIColor(red: 0.059, green: 0.420, blue: 0.600, alpha: 1)
    let color_Complete = UIColor(red: 0.565, green: 0.725, blue: 0.282, alpha: 1)
    let color_Cancelled = UIColor(red: 0.929, green: 0.110, blue: 0.141, alpha: 1)
    let color_Rejected = UIColor(red: 0.851, green: 0.039, blue: 0.086, alpha: 1)
    
    
}
