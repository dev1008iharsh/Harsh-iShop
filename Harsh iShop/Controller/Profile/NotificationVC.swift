//
//  NotificationVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 27/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationVC: UIViewController {
    
    
    @IBOutlet weak var tblNotification: UITableView!
    
    var marrNotifications :Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNotificationApi()
    }
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNotificationApi() {
     
        let request = AF.request( helper.baseUrl + "auth/get_notification_list", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Notification dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    self.marrNotifications = dictResponse["data"].arrayValue
                    self.tblNotification.reloadData()
                    
                    
                }else{
                    print("*** auth/get_notification_list API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    
    
}

// MARK:  UITableViewDelegate, UITableViewDataSource

extension NotificationVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrNotifications.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK:  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        
        
        cell.lblMessage.text = marrNotifications[indexPath.row]["notification_message"].stringValue
        cell.lblDate.text = marrNotifications[indexPath.row]["date"].stringValue
        
        
        return cell
        
    }
    
}
