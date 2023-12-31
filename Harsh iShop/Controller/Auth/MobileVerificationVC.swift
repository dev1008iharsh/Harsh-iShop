//
//  MobileVerificationVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MobileVerificationVC: UIViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtVerify4: UITextField!
    @IBOutlet weak var txtVerify3: UITextField!
   
    
    var strOtp: String?
    
    var strMobileNum : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let strStoreInfo = "Please enter the verification code that was sent to ".localized  +  "\(strMobileNum ?? "No Number")."
        
        let attributedString = NSMutableAttributedString(string: strStoreInfo)
        attributedString.setColorForText("\(strMobileNum ?? "No Number").", with: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
        lblMessage.attributedText = attributedString
        
        
        txtVerify1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtVerify2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
     
        
        txtVerify1.becomeFirstResponder()
        
        
    }
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtVerify1:
                txtVerify2.becomeFirstResponder()
            case txtVerify2:
                txtVerify3.becomeFirstResponder()
            case txtVerify3:
                txtVerify4.becomeFirstResponder()
            case txtVerify4:
                txtVerify4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txtVerify1:
                txtVerify1.becomeFirstResponder()
            case txtVerify2:
                txtVerify1.becomeFirstResponder()
      
            default:
                break
            }
        }
        else{
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
    }
    
    @IBAction func btnNext(_ sender: btnFullWidth) {
        
        if txtVerify1.text!.isEmpty && txtVerify2.text!.isEmpty && txtVerify3.text!.isEmpty && txtVerify4.text!.isEmpty {
            ModelManager().showAlert(title: "Any Field Shold not be empty".localized, message: "OTP must be 4 Digit".localized, view: self)
            
        }else if txtVerify4.text!.isEmpty && txtVerify3.text!.isEmpty && txtVerify2.text!.isEmpty && txtVerify1.text!.isEmpty{
            ModelManager().showAlert(title: "Any Field Shold not be empty".localized, message: "OTP must be 4 Digit".localized, view: self)
        }
        else{
            
            
            
            startAnimation()
       
            verifyNumberApi()
            
        }
        
    }
    
    
    
    @IBAction func btnBack(_ sender: BackBtnArabic) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: API Functions
    func verifyNumberApi(){
        
        let param: Parameters = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                                 "otp": strOtp!]
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/mobile_no_verify", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                
                print("* Mobile Verify dictResponse::\(dictResponse)")
                
                if dictResponse["success"].boolValue
                {
                    
                    if dictResponse["success"].boolValue{
                        
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        UserDefaults.standard.synchronize()
                        
      
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else{
                        ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                    }
                    
                }else{
                    print("*** auth/mobile_no_verify API error")
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    
    
    
}
extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}
