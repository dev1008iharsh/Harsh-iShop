//
//  SignUpVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class SignUpVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var btnCountryCode: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var txtFname: UITextField!
    
    @IBOutlet weak var txtLname: UITextField!
    
    @IBOutlet weak var txtOtp: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtMobNumber: UITextField!
    
    @IBOutlet weak var txtPass: UITextField!
    
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    @IBOutlet weak var viewRightDropAr: UIView!
    // MARK: Properties
    let cntryCodeDropDown = DropDown()
    
    var strCntryCode : String?
    
    
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCntryCodeBtnForArabic()
    }
    
    
    
    // MARK: Button Actions
    @IBAction func btnCountryCode(_ sender: UIButton) {
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            cntryCodeDropDown.anchorView = viewRightDropAr
            
        }else{
            cntryCodeDropDown.anchorView = btnCountryCode
            
        }
        
        
        
        cntryCodeDropDown.direction = .any
        //cntryCodeDropDown.selectRow(at: 0)
        cntryCodeDropDown.dataSource = ["+91","+971","+61","+98"]
        
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 50
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 15
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 1
        //appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        cntryCodeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //print("Selected cntryCodeDropDown item: \(item) at index: \(index)")
            self.strCntryCode = item
            self.btnCountryCode.setTitle(item, for: .normal)
            //self.idLocation = self.arrIdcntryCodeDropDown[index]
        }
        cntryCodeDropDown.show()
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func txtFname(_ sender: UITextField) {
        txtLname.becomeFirstResponder()
    }
    
    @IBAction func txtLnameNext(_ sender: UITextField) {
        txtEmail.becomeFirstResponder()
    }
    
    @IBAction func txtEmailNext(_ sender: UITextField) {
        txtMobNumber.becomeFirstResponder()
    }
    
    @IBAction func txtMobNumberNext(_ sender: UITextField) {
        txtPass.becomeFirstResponder()
    }
    
    @IBAction func txtPassNext(_ sender: UITextField) {
        txtConfirmPass.becomeFirstResponder()
    }
    
    @IBAction func btnKeyBoardContinue(_ sender: UITextField) {
        btnContinueTapped()
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        btnContinueTapped()
    }
    
    
    // MARK: Button Continue Tapped
    
    func btnContinueTapped(){
        //print("btnContinueTapped")
        checkValidation()
        
    }
    
    // MARK: Helper Actions
    func setCntryCodeBtnForArabic(){
        if LanguageChanger.currentAppleLanguage() == "ar"{
            btnCountryCode.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        }else{
            btnCountryCode.contentEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        }
    }
    
    func checkValidation(){
        if txtFname.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your First Name".localized, view: self)
        }else if txtLname.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Last Name".localized, view: self)
        }else if txtEmail.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Email".localized, view: self)
        }else if txtMobNumber.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Mobile Number".localized, view: self)
        }else if txtPass.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Password".localized, view: self)
        }else if txtConfirmPass.text!.isEmpty{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Your Confirm Password".localized, view: self)
        }else if !(ModelManager().isValidEmail(emailId: txtEmail.text!)){
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Valid Email Address".localized, view: self)
        }else if txtConfirmPass.text != txtPass.text{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Password and Confirm Password are not same".localized, view: self)
        }else if txtMobNumber.text!.count < 8{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Valid Mobile Number".localized, view: self)
        }else if txtMobNumber.text!.count > 15{
            ModelManager().showAlert(title: helper.alertTitle.localized, message: "Please Enter Valid Mobile Number".localized, view: self)
        }else{
            startAnimation()
            registerUserApi()
            
        }
        
    }
    
    // MARK: API Functions
    func registerUserApi(){
        
        let params: Parameters = ["user_type":"User",
                                  "first_name": txtFname.text!,
                                  "last_name": txtLname.text!,
                                  "email": txtEmail.text!,
                                  "mobile_no" : txtMobNumber.text!,
                                  "country_code": strCntryCode ?? "+92",
                                  "password": txtPass.text!,
                                  "device_token": "123",
                                  "device_type": "iOS",
                                  "language_id" :"1"]
        
        print(params)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/user_register", method: .post, parameters: params, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Regi User Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(dictResponse.dictionaryObject, forKey: "userDetails")
                    UserDefaults.standard.synchronize()

                    helper.mdictUserDetails = JSON(UserDefaults.standard.dictionary(forKey: "userDetails")! as NSDictionary).dictionaryValue
                    
                    
                    
                    if dictResponse["mobile_no"].stringValue.count == 0
                    {
                        
                        // TODO  if helper.isSkipped je jagya ae hoy ee  jagya ae pacho lai javano...
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MobileNumberVC")as! MobileNumberVC
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }else{
                        
                        let  next  = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerificationVC") as! MobileVerificationVC
                        next.strMobileNum = self.txtMobNumber.text!
                        self.navigationController?.pushViewController(next, animated: false)
                        
                    }
                    
                    
                    
                }else{
                    print("*** auth/user_register Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
}
