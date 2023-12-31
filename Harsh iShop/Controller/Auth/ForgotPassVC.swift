//
//  ForgotPassVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPassVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnKeyBoardContinue(_ sender: UITextField) {
        btnContinueTapped()
    }
    @IBAction func btnContinue(_ sender: UIButton) {
        btnContinueTapped()
    }
    func btnContinueTapped() {
        //print("btn Continue")
        
        checkValidation()
        
        
    }
    // MARK: Helper Functions
    func checkValidation(){
        if txtEmail.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your First Name".localized, view: self)
       
            startAnimation()
            forgotSendEmailApi()
        }
        
    }
    // MARK: API Functions
    func forgotSendEmailApi(){
        let param: Parameters = ["email": txtEmail.text!]
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "auth/forgot_password", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
         
                print("* forgotSendEmailApi dictResponse::\(dictResponse)")
                
                if dictResponse["success"].boolValue
                {
                    self.stopAnimation()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "ForgotSentVC")as! ForgotSentVC
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }else{
                    print("*** auth/forgot_password api error")
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
}
