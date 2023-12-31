//
//  LoginVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class LoginVC: UIViewController,UITextFieldDelegate {
    
    // MARK: @IBOutlet
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var txtPass: UITextField!
 
    // MARK: Properties
    
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtPass.delegate = self
        txtEmail.delegate = self
        termsCondiClick()
        
        
    }
    
    // MARK: Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func btnKeyBoardContinue(_ sender: UITextField) {
        btnContinueTapped()
    }
    
    @IBAction func txtEmailNext(_ sender: UITextField) {
        txtPass.becomeFirstResponder()
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        btnContinueTapped()
        
    }
    
    @IBAction func btnForgotPass(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
     
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/login", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Login dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(dictResponse.dictionaryObject, forKey: "userDetails")
                    UserDefaults.standard.synchronize()
                    
                    helper.mdictUserDetails = JSON(UserDefaults.standard.dictionary(forKey: "userDetails")! as NSDictionary).dictionaryValue
                    
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "LocationVC")as! LocationVC
//                    nextVC.strEmail = self.txtEmail.text!
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }else{
                    print("*** auth/login API error")
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
    
    // MARK: Helper Functions
    func checkValidation(){
        if txtEmail.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your First Name", view: self)
        }else if txtPass.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Last Name", view: self)
   
            startAnimation()
            loginUserApi()
        }
        
    }
    
    
    func termsCondiClick(){
        txtvTermsCondi.text = "By using myDukaan, you agree to the terms and conditions and privacy policy".localized
        
        
        let main_string = "By using myDukaan, you agree to the terms and conditions and privacy policy".localized
        
        
        let string1 = "terms and conditions".localized
        let string2 = "privacy policy".localized
        
        let FullStringRange = (main_string as NSString).range(of: main_string)
        let rangeString1 = (main_string as NSString).range(of: string1)
        let rangeString2 = (main_string as NSString).range(of: string2)
        
        let attributedString = NSMutableAttributedString.init(string: main_string)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
      
        attributedString.addAttribute(NSAttributedString.Key.link, value: "https://www.twitter.com", range: rangeString2)
        
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.red,
        ]
        
        txtvTermsCondi.isUserInteractionEnabled = true
        txtvTermsCondi.isEditable = false
        
        txtvTermsCondi.linkTextAttributes = linkAttributes
        txtvTermsCondi.attributedText = attributedString
        
    }
    
}

