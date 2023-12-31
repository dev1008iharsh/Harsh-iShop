//
//  MobileNumberVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 07/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire

class MobileNumberVC: UIViewController {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var btnCountryCode: UIButton!
    
    @IBOutlet weak var viewRightDropAr: UIView!
    
    @IBOutlet weak var txtMobNumber: UITextField!
    
    @IBOutlet weak var txtvTermsCondi: UITextView!
    
    // MARK: Properties
    let cntryCodeDropDown = DropDown()
    
    var strCntryCode : String? = "+91"
    var userIdForFbUser = ""
    var isFacebookLogin : Bool = false
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        termsCondiClick()
    }
    
    
    
    // MARK: Buttons Actions
    @IBAction func btnCountryCode(_ sender: UIButton) {
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            cntryCodeDropDown.anchorView = viewRightDropAr
            
        }else{
            cntryCodeDropDown.anchorView = btnCountryCode
            
        }
        cntryCodeDropDown.direction = .any
        cntryCodeDropDown.selectRow(at: 0)
        cntryCodeDropDown.dataSource = ["+91","+971","+61"]
        
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
    
    @IBAction func btnNext(_ sender: UIButton) {
        
        if (txtMobNumber.text?.isEmpty)!
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Mobile Number".localized, view: self)
            
        }else{
            startAnimation()
            regiLoginMobApi()
        }
        
    }
    
    
    // MARK: API Functions
    func regiLoginMobApi(){
        
        var param: Parameters = ["mobile_no" : txtMobNumber.text!,
                                 "country_code": strCntryCode ?? "+91",
                                 "device_token": "123",
                                 "device_type": "iOS",
                                 "language_id" :"1"]
        
        print(param)
        //*** Jo FaceBook Login thi ahiya avse to apde ene user id apsu to ee verification vc ma jase...condition khoti padse etle.
        if isFacebookLogin
        {

            param = ["user_id": helper.mdictUserDetails["user_id"]?.stringValue ?? userIdForFbUser,
                     "mobile_no" : txtMobNumber.text!,
                     "country_code": strCntryCode ?? "+91",
                     "device_token": "123456",
                     "device_type": "iOS",
                     "language_id" :"1"]
        }
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/mobile_no_register", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Regi-Login Mobile Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    
                    UserDefaults.standard.set(dictResponse.dictionaryObject, forKey: "userDetails")
                    UserDefaults.standard.synchronize()
                    
                    helper.mdictUserDetails = JSON(UserDefaults.standard.dictionary(forKey: "userDetails")! as NSDictionary).dictionaryValue
                    
                    if dictResponse["first_name"].stringValue.count == 0
                    {
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CompleteRegiVC")as! CompleteRegiVC
                        nextVC.strMobileNumber = self.txtMobNumber?.text ?? "No Mob"
                        nextVC.strCountryCode = self.strCntryCode!
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }else{
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MobileVerificationVC")as! MobileVerificationVC
                        nextVC.strMobileNum = "\(self.strCntryCode ?? "No Country Code") \(self.txtMobNumber.text ?? "No Mob Num")"
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }
                    
                }else{
                    print("*** auth/user_register Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
    
    
    // MARK: Helper Functions
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
        
        
        attributedString.addAttribute(.font, value: UIFont(name: "Avenir-Medium", size: 15)!, range: FullStringRange)
        attributedString.addAttribute(.paragraphStyle, value: style, range: FullStringRange)
        attributedString.addAttribute(NSAttributedString.Key.link, value: "https://www.google.com", range: rangeString1)
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



