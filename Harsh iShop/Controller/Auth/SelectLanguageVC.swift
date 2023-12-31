//
//  SelectLanguageVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class SelectLanguageVC: UIViewController {
    //MARK: -  @IBOutlet
    
    
    
    
    // MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: ButtonKs Actions
    @IBAction func btnEng(_ sender: UIButton) {
        
        
        LanguageChanger.changeLanguage(lan: "en")
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        UserDefaults.standard.set("en", forKey: "language_id")
        UserDefaults.standard.synchronize()
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "BoardingVC")as! BoardingVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    @IBAction func btnArabic(_ sender: UIButton) {
        
        
        LanguageChanger.changeLanguage(lan: "ar")
        
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        UserDefaults.standard.set("ar", forKey: "language_id")
        UserDefaults.standard.synchronize()
        
        changeLanguage()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "BoardingVC")as! BoardingVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    // MARK: Helper Functions
    func changeLanguage() {
        
        Localizer.doTheSwizzling()
        
        DispatchQueue.main.async(execute: {() -> Void in
            if let aWindow = self.view.window {
                UIView.transition(with: aWindow, duration: 1.0, options: .transitionFlipFromLeft, animations: {() -> Void in
                    self.view.setNeedsDisplay()
                    self.view.alpha = 1.0
                    self.navigationController?.popViewController(animated: false)
                    let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
                    let next = storyboard?.instantiateViewController(withIdentifier: "BoardingVC") as? BoardingVC
                    let navController = self.view.window?.rootViewController as? UINavigationController
                    if let aNext = next {
                        navController?.pushViewController(aNext, animated: false)
                    }
                })
            }
        })
        
        
    }
    
    
}
