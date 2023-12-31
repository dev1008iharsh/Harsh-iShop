//
//  ChangePassword.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 23/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePassVC: UIViewController {
    //MARK: -  @IBOutlet
    
       
       @IBOutlet weak var btnSave: UIButton!
       
       @IBOutlet weak var txtCurntPass: UITextField!
       
       @IBOutlet weak var txtNewPass: UITextField!
       
       @IBOutlet weak var txtNewConfirmPass: UITextField!
       
     
     
     //MARK: -  Properties

     
     
     //MARK: -  ViewController LifeCycle
     override func viewDidLoad() {
         super.viewDidLoad()

         
     }
     

     //MARK: -  Buttons Actions

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSave(_ sender: UIButton) {
        
        if (txtCurntPass.text?.isEmpty)!
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Current Password".localized, view: self)
            
      
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Confirm Password".localized, view: self)
            
        }else if (txtNewPass.text != txtNewConfirmPass.text)
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "New Password and Confirm Password does not match".localized, view: self)
            
        }else{
            startAnimation()
            changePasswordApi()
        }
        
    }
    
    
    @IBAction func txtCurntPass(_ sender: UITextField) {
        txtNewPass.becomeFirstResponder()
    }
    
    @IBAction func txtNewPass(_ sender: UITextField) {
        txtNewConfirmPass.becomeFirstResponder()
    }
    
    @IBAction func txtNewConfirmPass(_ sender: UITextField) {
        resignFirstResponder()
    }
    
    
    //MARK: -  API Functions
    func changePasswordApi(){
     
        let param: Parameters = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "old_password" : txtCurntPass.text!,
            "new_password" : txtNewConfirmPass.text!]
        
        print(param)
        

        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/change_password", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimating()
            
            if let result = response.value {
             
                if dictResponse["success"].boolValue
                {
                    ModelManager().showAlertHandler(title: "Change Password Successfully".localized, message: dictResponse["message"].stringValue, view: self, okAction: { (UIAlertAction) in

                        self.navigationController?.popViewController(animated: true)

                    })
                    
                    
                }else{
                    print("*** auth/change_password")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
            
            
        }
    }

     //MARK: - Helper Functions
}
