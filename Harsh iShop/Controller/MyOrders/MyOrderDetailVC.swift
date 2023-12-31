//
//  MyOrderDetailVC.swift
//  E-Commerce Order - OrderDetail
//
//  Created by Harsh iOS Developer on 03/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cosmos

class MyOrderDetailVC: UIViewController {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContactSupport: UIButton!
    @IBOutlet weak var btnContactSupportBig: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var tblProductHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var viewRatingMain: UIView!
    @IBOutlet weak var lblNote: UILabel!
  
    
    
    //MARK:- Properties
    var mdictOrderDetails : Dictionary<String,JSON> = [:]
    
    var marrItems :Array <JSON> = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRatingMain.isHidden = true
        ratingView.settings.fillMode = .half
        marrItems = mdictOrderDetails["item"]!.arrayValue
        tblProductHeight.constant = CGFloat((44 * marrItems.count))
      
        setUpLables()
        setUpRatingStar()
        
        
    }
    //MARK:- Buttons Action
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnStatus(_ sender: UIButton) {
        
    }
    @IBAction func btnContactSupportBig(_ sender: UIButton) {
        
    }
    @IBAction func btnCancelOrder(_ sender: UIButton) {
        print(mdictOrderDetails)
        if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "pending"
        {
            
         
                
            }) { (noAction) in
                print("No Tapped")
            }
            
        }
        
        
        if mdictOrderDetails["order_status"]!.stringValue == "Complete"
        {
            
            startAnimation()
            submitRatingApi()
            
        }
        
    }
    @IBAction func btnSupport(_ sender: UIButton) {
        
    }
    
    
    //MARK: - Api Functions
    func submitRatingApi() {
       
        
        let param = ["rating" : "\(ratingView.rating)",
            "order_id": mdictOrderDetails["order_id"]!.stringValue]
        
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "order/add_rating", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Add Rating dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.btnCancelOrder.isUserInteractionEnabled = false
                    
                    self.btnCancelOrder.isHidden = true
                    self.btnContactSupport.isHidden = true
             
                    ModelManager().showAlertHandler(title: "Rating Submitted".localized, message: dictResponse["message"].stringValue, view: self, okAction: { (UIAlertAction) in
                        
                        self.navigationController?.popViewController(animated: false)
                        
                    })
                    
                    
                }else{
                    print("*** order/add_rating API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    func cancelOrderApi() {
       
        let param = ["status" : "Canceled",
                     "order_id": mdictOrderDetails["order_id"]!.stringValue,
                     "user_type": helper.mdictUserDetails["user_type"]!.stringValue]
        
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "order/order_status_change", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Cancel Order dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    let notificationName = Notification.Name("getMyOrders")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                    
                    self.btnCancelOrder.isHidden = true
                    self.btnContactSupport.isHidden = true
                    self.btnContactSupportBig.isHidden = true
                    
                    ModelManager().showAlertHandler(title: "Order Cancelled".localized, message: "You have Sucessfully Cancelled your Order".localized, view: self, okAction: { (UIAlertAction) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    
                    
                }else{
                    print("*** order/order_status_change API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    
    
    
    //MARK:- Helper Functions
    func setUpRatingStar(){
        ratingView.rating = 1.0
        
        ratingView.settings.totalStars = 5
      
        ratingView.settings.updateOnTouch = true

        ratingView.settings.fillMode = .half
     
        ratingView.settings.starSize = 30

        ratingView.settings.starMargin = 5

        ratingView.settings.filledColor = UIColor.yellow

        ratingView.settings.emptyBorderColor = UIColor.yellow

        ratingView.settings.filledBorderColor = UIColor.yellow
        
        ratingView.settings.minTouchRating = 0.5
        
    }
    func setUpLables(){
        lblOrderId.text = "# \(mdictOrderDetails["order_id"]!.stringValue)"
        
        btnStatus.layer.cornerRadius = btnStatus.frame.size.height / 2
        
        
        
        lblSubTotal.text = "$ \(mdictOrderDetails["sub_total"]!.stringValue)"
        
        lblVat.text = "$ " + mdictOrderDetails["total_vat"]!.stringValue
        
        lblDeliveryCharges.text = "$ " + mdictOrderDetails["total_delivery_charge"]!.stringValue
        
        lblTotal.text = "$ " + mdictOrderDetails["total"]!.stringValue
        
        lblDeliveryInfo.text =  mdictOrderDetails["delivery_date"]!.stringValue + " " + mdictOrderDetails["delivery_time"]!.stringValue
        
        lblAddress.text = mdictOrderDetails["address_type"]!.stringValue + "\n" + mdictOrderDetails["house"]!.stringValue + mdictOrderDetails["apartment"]!.stringValue + ", "  + "\n" + mdictOrderDetails["street_address"]!.stringValue + ", " + mdictOrderDetails["area"]!.stringValue
        
        if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "pending"{
            
         
            btnStatus.backgroundColor = helper.color_Pending
            btnStatus.setTitle("Pending".localized(), for: .normal)
        }else if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "in progress"{
            btnStatus.backgroundColor = helper.color_In_Progress
            btnStatus.setTitle("In Progress".localized(), for: .normal)
          
            
        }else if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "on way"{
            btnStatus.backgroundColor = helper.color_On_The_Way
            btnStatus.setTitle("On The Way".localized(), for: .normal)
       
            
        }else if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "complete"{
            
            viewRatingMain.isHidden = false
            btnStatus.backgroundColor = helper.color_Complete
            btnStatus.setTitle("Complete".localized(), for: .normal)
            
           
            
        }else if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "canceled"{
            
    
            
            btnStatus.backgroundColor = helper.color_Cancelled
            btnStatus.setTitle("Cancelled".localized(), for: .normal)
            
        }else{
            
            btnStatus.backgroundColor = helper.color_Rejected
            btnStatus.setTitle("Rejected".localized(), for: .normal)
         
        }
        
        //Rating View Configuration
        ratingView.rating = 0.0
        
        if mdictOrderDetails["rating"]!.stringValue != "" {
            
            ratingView.rating = mdictOrderDetails["rating"]!.doubleValue
            
            btnCancelOrder.isHidden = true
            btnContactSupport.isHidden = true
            
            
        }else if mdictOrderDetails["order_status"]!.stringValue == "Complete"
        {
            ratingView.rating = 1.0
            ratingView.isUserInteractionEnabled = true
            btnCancelOrder.setTitle("Submit Rating".localized, for: .normal)
            
            btnContactSupportBig.isHidden = true
            
        }else if mdictOrderDetails["order_status"]!.stringValue.lowercased() == "pending"{
            
            btnContactSupportBig.isHidden = true
            
        }else{
            
            btnCancelOrder.isHidden = true
            btnContactSupport.isHidden = true
            
        }
        
        
    }
    
    
    
}
//MARK:- Table DataSource Delegate
extension MyOrderDetailVC: UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrItems.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? PlacedOrderTVC  else { return UITableViewCell() }
        
        
        cell.selectionStyle = .none
        
        cell.lblItemName.text  = marrItems[indexPath.row]["product_name"].stringValue
        cell.lblItemPrice.text = "$ " + (marrItems[indexPath.row]["product_price"].stringValue)
        
        cell.lblItemQty.text  = marrItems[indexPath.row]["qty"].stringValue
        
        
        cell.viewQty.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewQty.layer.cornerRadius = 3.0
        cell.viewQty.layer.borderWidth = 0.5
        return cell
        
        
    }
    
}
