//
//  ProfileVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet var viewsStack: [UIView]!
    
    @IBOutlet weak var btnLogout: UIButton!
    
   
    
    @IBOutlet weak var lblChangeLanguage: UILabel!
    @IBOutlet weak var viewTopProfile: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            startAnimation()
            getProfileApi()
            
            
            
        }else{
            
            btnLogout.isHidden = true
            
        }
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            lblChangeLanguage.text = "English Language"
        }else{
            lblChangeLanguage.text = "اللغة العربي"
            
        }
        
    }
    
    
    
    @IBAction func btnBack(_ sender: BackBtnArabic) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnFavTab(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            
            self.navigationController?.pushViewController(nextVC, animated: false)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
    
    @IBAction func btnHomeTab(_ sender: UIButton) {
       
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
       
    }
    
    @IBAction func btnCartTab(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            
            self.navigationController?.pushViewController(nextVC, animated: false)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
    }
    
    @IBAction func btnAllCategories(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    @IBAction func btnPrivacyPolicy(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    @IBAction func btnEditProfile(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
    
    @IBAction func btnMyOrders(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
    }
    
    @IBAction func btnNotification(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
    
    @IBAction func btnFavourites(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
            
        }
        
    }
    
    @IBAction func btnHelpSupport(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "HelpSupportVC") as! HelpSupportVC
            
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        }else{
            
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       
                       let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                       
                       self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
    
    @IBAction func btnShareApp(_ sender: UIButton) {
        let defaultText = "Download Awesome Shopping App iHarsh Shop"
        let appURL : URL = URL(string: "https://www.google.com/")!
        
    
        if let imgToShare = data, let imageToShare = UIImage(data: imgToShare as Data) {
            activityController = UIActivityViewController(activityItems: [defaultText, appURL, imageToShare], applicationActivities: nil)
        } else {
            activityController = UIActivityViewController(activityItems: [defaultText,appURL],applicationActivities: nil)
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func btnChngLang(_ sender: UIButton) {
        btnChangeLanguage()
        
    }
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        
        ModelManager().showConfirmAlert(title: helper.alertTitle, message: "Are you Sure you want to logout?", view: self, YesAction: { (action) in
            self.btnLogoutTapped()
        }) { (action) in
            print("Cancel Clicked")
        }
        
    }
    
    func getProfileApi(){
        print("getCartProductsApi")
        
        
        let param: Parameters = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue]
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/get_profile", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimating()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("*getProfile ::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    self.lblName.text = dictResponse["first_name"].stringValue + " " + dictResponse["last_name"].stringValue
                    
                    self.lblMobNumber.text = dictResponse["mobile_no"].stringValue
                    
                    
                    
                    self.imgProfile.sd_setImage(with: dictResponse["profile_image"].url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 3), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    
                    
                }else{
                    print("*** auth/get_profile Api Error")
                    
                    
                }
            }
            
            
        }
    }
    //MARK:- Helper Functions
    func configUI(){
        
        viewsStack.forEach { $0.layer.cornerRadius = 10 }
        viewTopProfile.layer.cornerRadius = 33.3
        viewTopProfile.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func btnChangeLanguage() {
        
        if LanguageChanger.currentAppleLanguage() == "en" {
            LanguageChanger.changeLanguage(lan: "ar")
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            UserDefaults.standard.set("ar", forKey: "language_id")
            UserDefaults.standard.synchronize()
            
        }
        else {
            LanguageChanger.changeLanguage(lan: "en")
            
         
        }
        
        Localizer.doTheSwizzling()
        
        DispatchQueue.main.async(execute: {() -> Void in
            if let aWindow = self.view.window {
                UIView.transition(with: aWindow, duration: 1.0, options: .transitionFlipFromLeft, animations: {() -> Void in
                    self.view.setNeedsDisplay()
                    self.view.alpha = 1.0
            
                    let arrVC = [vc1,vc2]
                    self.navigationController?.setViewControllers(arrVC, animated: true)
                    
                })
            }
        })
        
        
    }
    
    
    func btnLogoutTapped() {
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
        }
        
        let nextVC  = self.storyboard?.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let next = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        //        let navigate = UINavigationController(rootViewController: next)
        //        navigate.setNavigationBarHidden(true, animated: true)
        //        self.slideMenuController()?.changeMainViewController(navigate, close: true)
        
    }
    
}
