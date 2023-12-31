//
//  EditProfileVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 23/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class EditProfileVC: UIViewController {
    
    //MARK: -  @IBOutlet
    
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
   
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    
    
    
    //MARK: -  Properties
    
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        getProfileApi()
        
    }
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLockChangePassword(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
        self.navigationController?.pushViewController(nextVC, animated: true)
   
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        if (txtFname.text?.isEmpty)!
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Your First Name".localized, view: self)
            
        else{
            ModelManager().showConfirmAlert(title: "Update Profile", message: "Do you Really want to Update your Profile ?".localized, view: self, YesAction: { (yesAction) in
                self.startAnimation()
                self.updateProfileApi()
                
                
            }) { (noAction) in
                print("no tapped at user profile save button")
            }
            
        }
        
    }
    
    @IBAction func btnMobNum(_ sender: UIButton) {
        ModelManager().showAlert(title: helper.alertTitle.localized, message: "Sorry ! You can not change your Mobile Number".localized, view: self)
    }
    
     
    
    @IBAction func txtEmailNext(_ sender: UITextField) {
        resignFirstResponder()
    }
    //MARK: - Helper Functions
    private func showAlert() {
        
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            PHPhotoLibrary.requestAuthorization { (status) in
                print(status)
                switch status{
                case .authorized:
                    self.getImage(fromSourceType: .photoLibrary)
                case .notDetermined:
                    print("notDetermined")
                    if status == PHAuthorizationStatus.authorized{
                       self.getImage(fromSourceType: .photoLibrary)
                    }
              
                case .denied:
                    print("denied")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Photo Library Denided", message: "Photo Library access was previously denided.Please update your Settings if you wish to change this", preferredStyle: .alert)
                        let goToSettingsAction = UIAlertAction(title: "Go to Setting", style: .default){
                            (action) in
                            DispatchQueue.main.async {
                                if let url = URL(string: UIApplication.openSettingsURLString){
                                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }

                            }
                        }

                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(goToSettingsAction)
                        alert.addAction(cancelAction)
                        self.present(alert,animated: true)

                    }
                    
                default :
                    break


                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
               
                    self.imgProfile.sd_setImage(with: dictResponse["profile_image"].url, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 3), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    
                    
                }else{
                    print("*** auth/get_profile Api Error")
                    
                    
                }
            }
            
            
        }
    }
    
    func updateProfileApi(){
        print("getCartProductsApi")
        
        
        let param: Parameters = ["user_id":helper.mdictUserDetails["user_id"]!.stringValue,
            "first_name" : txtFname.text!,
            "last_name"  : txtLname.text!,
            "mobile_no"  : txtMob.text!
        ]
     
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/update_profile", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimating()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* update Profile ::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    ModelManager().showAlert(title: "Updated Sucessfully".localized, message: dictResponse["message"].stringValue, view: self)
                   self.navigationController?.popViewController(animated: true)
                    
                }else{
                   
                    
                }
            }
        }
    }
    
    
    
}

//MARK:- Image Picker
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //This is the tap gesture added on my UIImageView.
    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }
    
    //Show alert to selected the media source type.
    
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            myPickerController.delegate = self
            myPickerController.sourceType = sourceType
            self.present(myPickerController,animated: true)
            
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.editedImage] as? UIImage {
            self.imgProfile.image = image
            imgProfile.contentMode = .scaleAspectFill
            
            imgProfile.clipsToBounds = true
        }else if let image = info[.originalImage] as? UIImage{
            self.imgProfile.image = image
        }
        
        dismiss(animated: true, completion: nil)
        startAnimation()
        //uploadProfileApi()
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
