//
//  HelpSupportVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 27/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HelpSupportVC: UIViewController {

    @IBOutlet weak var txtvContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
        helpSuppportApi()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func helpSuppportApi() {
                
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "listing/help_and_support", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()

            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Help Support dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                  
                    let htmlData = NSString(string: dictResponse["data"].stringValue).data(using: String.Encoding.unicode.rawValue)
                    let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
                    let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                          options: options,
                                                                          documentAttributes: nil)
                    
                    self.txtvContent.attributedText = attributedString
                 
                    
                }else{
                    print("*** listing/help_and_support")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }

}
