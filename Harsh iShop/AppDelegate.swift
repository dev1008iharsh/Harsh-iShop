//
//  AppDelegate.swift
//  Harsh iShop
//   8007323
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Localize_Swift
import IQKeyboardManagerSwift
import Alamofire
import NVActivityIndicatorView
import Firebase
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import SwiftyJSON
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        autoLogin()
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            
            ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
            
            return true
        }
        
        func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            
        }
        
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "616011902215-5hhbdendek5sc2o6if05oju5rh2dv7hv.apps.googleusercontent.com"
        GMSPlacesClient.provideAPIKey("AIzaSyCijR62QvVs-yeysJ5m8PodZJVFQEBHSfs")
        
        
        
        if (UserDefaults.standard.object(forKey: "language_id") == nil)
        {
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
            
            
            LanguageChanger.changeLanguage(lan: "en")
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            UserDefaults.standard.set("en", forKey: "language_id")
            UserDefaults.standard.synchronize()
            
            Localizer.doTheSwizzling()
            
        }
        
        
        
        GMSServices.provideAPIKey("AIzaSyC4QV0kWdHnmVdG6KOAHog4XkSeOTYJEik")
        
        
        
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.enable = true
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func autoLogin(){
        
        //            if (UserDefaults.standard.value(forKey: "RecentlyViewed") != nil)
        //            {
        //                helper.marrRecentlyViewed = JSON(UserDefaults.standard.value(forKey: "RecentlyViewed")!).arrayValue
        //            }
        
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            print(UserDefaults.standard.value(forKey: "userDetails")!)
            helper.mdictUserDetails = JSON(UserDefaults.standard.dictionary(forKey: "userDetails")!).dictionaryValue
            
            print(helper.mdictUserDetails)
            
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            rootViewController.pushViewController(profileViewController, animated: false)
            
        }else if UserDefaults.standard.bool(forKey: "isAuthHome")
        {
            
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            rootViewController.pushViewController(profileViewController, animated: false)
            
        }
        
    }
    
}

