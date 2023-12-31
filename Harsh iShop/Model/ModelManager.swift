//
//  ModelManager.swift
//  piplanapane
//
//  Created by Parth Patoliya on 30/03/18.
//  Copyright © 2018 Parth. All rights reserved.
//

import UIKit
 

class ModelManager: NSObject {
    

    func isValidEmail(emailId:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    

    public func showAlert(title:String, message: String, view:UIViewController) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    

    public func showAlertHandler(title:String, message: String, view:UIViewController,okAction:@escaping ((UIAlertAction) -> Void)) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: okAction))
        view.present(alert, animated: true, completion: nil)
    }
    

    public func showConfirmAlert(title:String, message: String, view:UIViewController,YesAction:@escaping ((UIAlertAction) -> Void),NoAction:@escaping ((UIAlertAction) -> Void)) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertAction.Style.default, handler: YesAction))
        alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertAction.Style.default, handler: NoAction))
        view.present(alert, animated: true, completion: nil)
    }

    
    
}
