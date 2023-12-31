//
//  PrivacyPolicyVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 27/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var txtvContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
 
    
    func privacyPolicyApi() {
                
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "listing/privacy_policy", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()

            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Privecy Policy dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                  
                    let htmlData = NSString(string: dictResponse["data"].stringValue).data(using: String.Encoding.unicode.rawValue)
               
                 
                    
                }else{
                    print("*** listing/privacy_policy API ERROR")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }

}
