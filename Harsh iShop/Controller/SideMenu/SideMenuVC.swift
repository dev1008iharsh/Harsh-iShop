//
//  SideMenuVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 31/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var tblSideMenu: UITableView!
    @IBOutlet weak var lblEditStatic: UILabel!
    @IBOutlet weak var btnEditPencil: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    let arrMenuItems : [String] = [ "Edit Profile".localized ,"My Orders".localized ,"Notifications".localized, "My Favourites".localized,"Categories".localized,"Help Support".localized,"Privacy Policy".localized,"Share App".localized,"Logout".localized ]
    
    
    let arrImgMenuItems = ["ProfileS","iconHistory","iconNotifications","FavS","allCategories","Help","Privacy","share","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            startAnimation()
            getProfileApi()
            
        }else{
            
            lblEditStatic.isHidden = true
            btnEditPencil.isHidden = true
            
        }
        
        
        
    }
    @IBAction func btnEditPencil(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction func CloseSideMenu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func btnLogoutTapped() {
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
        }
        
        let nextVC  = self.storyboard?.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //MARK: -  API Functions
    
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
                    
                    self.lblMobileNumber.text = dictResponse["mobile_no"].stringValue
                    self.imgProfile.isHidden = false
                    self.imgProfile.sd_setImage(with: dictResponse["profile_image"].url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 3), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    
                    
                }else{
                    print("*** auth/get_profile Api Error")
                    
                    
                }
            }
            
            
        }
    }
}
// MARK:  UITableViewDelegate, UITableViewDataSource

extension SideMenuVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuItems.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if  !UserDefaults.standard.bool(forKey: "isLoggedIn") && indexPath.row == 8{
            
            return 0
            
        }
        return 50
        
    }
    
    
    // MARK:  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as? SideMenuTVC else { return UITableViewCell() }
        
        cell.lblTitleMenu.text = "\(arrMenuItems[indexPath.row])"
        cell.imgMenu.image = UIImage(named: arrImgMenuItems[indexPath.row])
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }else{
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            
            
            break
        case 1:
            
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
                
            }else{
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            
            
            break
        case 2:
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            }else{
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            
            
            break
        case 3:
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            }else{
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            }
            
            break
        case 4:
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            break
            
        case 5:
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "HelpSupportVC") as! HelpSupportVC
                
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                
            }else{
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            
            
            break
        case 6:
            
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
            
            break
        case 7:
            //share app
            let defaultText = "Download Awesome Shopping App iHarsh Shop"
            let appURL : URL = URL(string: "https://www.google.com/")!
            
            let activityController: UIActivityViewController
            
            let image = UIImage(named: "logo-1")
            
            let data = image?.jpegData(compressionQuality: 0.9)
            
            if let imgToShare = data, let imageToShare = UIImage(data: imgToShare as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, appURL, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText,appURL],applicationActivities: nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
            
            break
            
        case 8:
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                
                //log out
                ModelManager().showConfirmAlert(title: helper.alertTitle, message: "Are you Sure you want to logout?", view: self, YesAction: { (action) in
                    self.btnLogoutTapped()
                }) { (action) in
                    print("Cancel Clicked")
                }
                
            }else{
                
                
                
            }
            
            
            break
            
            
        default:
            print("Failed at default swift Case Side Menu Table Did Select")
            break
        }
        
        
    }
}
