//
//  UserInfoVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 01/08/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var viewMobNumber: UITextField!
    @IBOutlet weak var viewEmail: UITextField!
    @IBOutlet weak var txtMobNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    
    @IBOutlet weak var imgGotProfile: UIImageView!
    
    var strFname = ""
    var strLname = ""
    var strEmail = ""
    var strId = ""
    var strProfileUrl = ""
    
    var strMobNumber = ""
    var profileUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if strEmail == ""{
            viewEmail.isHidden = true
        }else{
            viewEmail.isHidden = false
            txtEmail.text = strEmail
        }
        
        if strMobNumber == ""{
            viewMobNumber.isHidden = true
        }else{
            viewMobNumber.isHidden = false
        }
        
        
        if let theProfileImageUrl = profileUrl {
            do {
                let imageData = try Data(contentsOf: theProfileImageUrl as URL)
                imgGotProfile.image = UIImage(data: imageData)
            } catch {
                print("Unable to load data: \(error)")
            }
        }
        
        txtFname.text = strFname
        txtLname.text = strLname
        
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
       
        startAnimation()
        loginWithFbApi()
    }
    
    func loginWithFbApi() {
        
        let param: Parameters = ["first_name": strFname,
                                 "last_name": strLname,
                                 "facebook_id": strId,
                                 "profile_image": strProfileUrl,
                                 "device_type":"iOS",
                                 "device_token": "123456"]
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/facebook_register_login", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimating()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* fbDictResponce dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    //***Update Profile Pic
             
                        
                        let userIdForFbUser = dictResponse["mobile_verify"].stringValue
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MobileNumberVC")as! MobileNumberVC
                        nextVC.isFacebookLogin = true
                        nextVC.userIdForFbUser = userIdForFbUser
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                        
                    }else{
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(dictResponse.dictionaryObject, forKey: "userDetails")
                        UserDefaults.standard.synchronize()

                        helper.mdictUserDetails = JSON(UserDefaults.standard.dictionary(forKey: "userDetails")! as NSDictionary).dictionaryValue
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let nextVC = storyBoard.instantiateViewController(withIdentifier: "LocationVC")as! LocationVC
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                        
                    }
                    
                    
                }else{
                    print("*** auth/facebook_register_login API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    func uploadProfileApi() {
        let url = helper.baseUrl + "auth/update_profile_image"
        
        let imgData = imgGotProfile.image!.jpegData(compressionQuality: 0.8)!
        let sticks = String(Date().timeIntervalSince1970*1000000)
        print(sticks)
        print(imgData)
        
        let param: Parameters = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,]
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            //key of image is "withName" key....which is coming from API
            multipartFormData.append( imgData, withName: "profile_image",fileName: "\(sticks).jpg", mimeType: "image/jpg")
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                  to:url,method: .post, headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
        }
        .downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            
            self.stopAnimating()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print(dictResponse)
                if dictResponse["success"].boolValue
                {
                    print("Upload Succcesfully")
                }else{
                    ModelManager().showAlert(title: "", message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
    
    
}
