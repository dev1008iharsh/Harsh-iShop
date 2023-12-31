//
//  AuthHomeVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON



class AuthHomeVC: UIViewController,UITextViewDelegate {
    
    // MARK: @IBOutlet
    @IBOutlet weak var txtvTermsCondi: UITextView!
    @IBOutlet weak var viewLoginMobile: UIView!
   
    @IBOutlet weak var viewApple: UIView!
    
    
    
    let loginManager = LoginManager()
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsCondiClick()
        configSignInMethodsView()
        googleSignInFunc()
    }
    
    // MARK: Buttons Actions
    @IBAction func btnSkip(_ sender: UIButton) {
        helper.isSkipped = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
     
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
      
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func btnSignUpFacaeBook(_ sender: UIButton) {
        facebookLogin()
    }
    @IBAction func btnSignUpGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnLoginMobile(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MobileNumberVC")as! MobileNumberVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK:- Helper Functions
    func configSignInMethodsView(){
        viewFb.layer.cornerRadius = 20
        
     
        viewGoogle.layer.borderWidth = 0.8
        
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
        
        attributedString.addAttribute(.font, value: UIFont(name: "Avenir-Medium", size: 15)!, range: FullStringRange)
        attributedString.addAttribute(.paragraphStyle, value: style, range: FullStringRange)
     
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.red,
        ]
        
        txtvTermsCondi.isUserInteractionEnabled = true
        txtvTermsCondi.isEditable = false
     
        
    }
    
    func googleSignInFunc(){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    // MARK:- FaceBook Login
    func facebookLogin(){
        //global declare karyu 6e...let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (result) in
            switch result{
            case .cancelled :
    
                
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                
                self.getFaceBookData()
            }
        }
    }
    func getFaceBookData(){
        if AccessToken.current != nil{
            GraphRequest.init(graphPath: "me", parameters: ["fields":"name, first_name, last_name, email, picture.type(large)" ]).start { (connection, result, error) in
                if error == nil{
                    
                    let dict = result as! [String : AnyObject] as NSDictionary
                    
                    let fbFullName = dict.object(forKey: "name") as? String ?? ""
                    let fbFirstName = dict.object(forKey: "first_name") as? String ?? ""
                    let fbLastName = dict.object(forKey: "last_name") as? String ?? ""
                    let fbEmail = dict.object(forKey: "email") as? String ?? ""
                    let fbId = dict.object(forKey: "id") as? String ?? ""
                    
                    
                    let fbProfileStrUrl: String = "http://graph.facebook.com/\(fbId)/picture?type=large"
                    let fbProfileurl: URL = URL(string: fbProfileStrUrl)!
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "UserInfoVC")as! UserInfoVC
                    print(fbFullName)
                    nextVC.strFname = fbFirstName
               
                    self.loginManager.logOut()
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }else{
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: error!.localizedDescription, view: self)
                }
            }
        }
    }
   
}

// MARK:- Google Login
extension AuthHomeVC: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            print("Pop up cancelled")
            return
        }
        
        let userId: String = user.userID
        
        let idToken: String = user.authentication.idToken
        
        let gFullName = user.profile.name ?? ""
        let gFirstNname = user.profile.givenName ?? ""
  
        
        print(mdictGoogleSignIn)
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "UserInfoVC")as! UserInfoVC
        nextVC.strFname = gFirstNname
        nextVC.strLname = gLastName
        nextVC.strEmail = gEmail
        nextVC.profileUrl = gProfileurl
        GIDSignIn.sharedInstance()?.signOut()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    
    
}
