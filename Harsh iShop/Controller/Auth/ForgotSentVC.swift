//
//  ForgotSentVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotSentVC: UIViewController {
    
    var strEmail : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendEmail(_ sender: UIButton) {
        startAnimation()
        forgotEmailSentApi()
    }
    @IBAction func btnLoginPage(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
       
    }
    
    // MARK: API Functions
    func forgotEmailSentApi(){
        
        let param: Parameters = ["email": strEmail]
        
        print(param)
       
        let request = AF.request( helper.baseUrl + "auth/forgot_password", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* forgotEmailSentApi dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                     
                    
                }else{
                    print("*** auth/forgot_password API error")
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
    
}
