//
//  CompleteRegiVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class CompleteRegiVC: UIViewController {
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    @IBOutlet weak var txtOtp: UITextField!
   
    var strMobileNum : String?
    var strMobileNumber : String = ""
    var strCountryCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func txtFname(_ sender: UITextField) {
        txtLname.becomeFirstResponder()
    }
    
    @IBAction func txtLnameNext(_ sender: UITextField) {
    
    
    @IBAction func txtConfiPassNext(_ sender: UITextField) {
        txtOtp.becomeFirstResponder()
    }
    
    
    @IBAction func btnKeyBoardContinue(_ sender: UITextField) {
        btnContinueTapped()
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        btnContinueTapped()
        checkValidation()
    }
    
    
    func btnContinueTapped(){
        //print("btnContinueTapped")
        checkValidation()
    }
    
    func checkValidation(){
        if txtFname.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your First Name".localized, view: self)
        }else if txtLname.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Last Name".localized, view: self)
   
        }else if !(ModelManager().isValidEmail(emailId: txtEmail.text!)){
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Valid Email Address".localized, view: self)
        }else if txtConfirmPass.text != txtPass.text{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Password and Confirm Password are not same".localized, view: self)
        }else{
            startAnimation()
            registerMobilApi()
        }
        
    }
    // MARK: API Functions
    func registerMobilApi(){
        
        let param: Parameters = ["user_id" : helper.mdictUserDetails["user_id"]!.stringValue,
                                 "first_name": txtFname.text!,
                                 "last_name": txtLname.text!,
                                 "mobile_no" : strMobileNum!,
                                 "country_code": strCountryCode,
                                 "email": txtEmail.text!,
                                 "otp": txtOtp.text!,
                                 "device_token": UserDefaults.standard.value(forKey: "Token")!,
                                 "device_type": "iOS",
                                 "language_id" :"1"]
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/mobile_no_user_profile_update", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Mobile Register::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    
                    UserDefaults.standard.set(dictResponse.dictionary, forKey: "userDetails")
                    
                 
                    if dictResponse["mobile_no"].stringValue.count == 0
                    {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MobileNumberVC")as! MobileNumberVC
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }else{
                        
                        let  next  = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                        
                        self.navigationController?.pushViewController(next, animated: false)
                        
                    }
                    
                    
                    
                }else{
                    print("*** auth/mobile_no_user_profile_update")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
}
