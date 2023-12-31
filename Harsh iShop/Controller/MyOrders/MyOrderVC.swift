//
//  MyOrderVC.swift
//
//
//  Created by Harsh iOS Developer on 03/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyOrderVC: UIViewController{
    
    //MARK:- @IBOutlet
    @IBOutlet weak var tblMyOrders: UITableView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //MARK:- Properties
    var marrOrders : Array<JSON> = []
    
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMyOrders.tableFooterView = UIView()
        
        //*** ahiya be var call thay...ek var page load thay ena mate...ane bijivar jyare detail manthi change cancel thay tyare..ena mate notificationCenter no use thay 6e.
      
            let notificationName = Notification.Name("getMyOrders")
            NotificationCenter.default.addObserver(self, selector: #selector(getMyOrderApi), name: notificationName, object: nil)
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC")as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        let notificationName = Notification.Name("getMyOrders")
        NotificationCenter.default.addObserver(self, selector: #selector(getMyOrderApi), name: notificationName, object: nil)
    }
    
    //MARK:- Buttons Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Functions
    
    @objc func getMyOrderApi() {
        
        let param = ["page" : "1",
                     "user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                     "user_type":"User"]
        
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "order/get_order", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
      
                    self.marrOrders  = dictResponse["data"].arrayValue
                    self.tblMyOrders.reloadData()
                    
                }else{
                    print("*** order/get_order API Error")
                   
                    
                }
            }
        }
    }
    
    
    
}
//MARK:- Table DataSource Delegate
extension MyOrderVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return marrOrders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrOrders[section]["item"].arrayValue.count + 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 75
        }
        
        if indexPath.row == marrOrders[indexPath.section]["item"].arrayValue.count + 1
        {
            return 65
        }
        
        return 45
        
    }
    
    //MARK:- cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? MyOrderTVC else { return UITableViewCell() }
            
            cell.configCell1()
            cell.lblOrderid.text = "# \(marrOrders[indexPath.section]["order_id"].stringValue)"
            cell.lblTotalPrice.text = "$ \(marrOrders[indexPath.section]["total"].stringValue)"
            
            return cell
        }
        
        if indexPath.row == marrOrders[indexPath.section]["item"].arrayValue.count + 1
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? MyOrderTVC else { return UITableViewCell() }
            
            cell.configCell3()
            
            cell.lblDeliveryDate.text = " \(marrOrders[indexPath.section]["delivery_date"].stringValue)"
            
            cell.lblDeliveryDate.text = " \(marrOrders[indexPath.section]["delivery_date"].stringValue)"
            
            if self.marrOrders[indexPath.section]["order_status"].stringValue.lowercased() == "pending"{
                cell.btnStatus.backgroundColor = helper.color_Pending
                cell.btnStatus.setTitle("Pending".localized(), for: .normal)
                
            }else if self.marrOrders[indexPath.section]["order_status"].stringValue.lowercased() == "in progress"{
                cell.btnStatus.backgroundColor = helper.color_In_Progress
                cell.btnStatus.setTitle("In Progress".localized(), for: .normal)
                
            }else if self.marrOrders[indexPath.section]["order_status"].stringValue.lowercased() == "on way"{
                cell.btnStatus.backgroundColor = helper.color_On_The_Way
                cell.btnStatus.setTitle("On The Way".localized(), for: .normal)
                
            }else if self.marrOrders[indexPath.section]["order_status"].stringValue.lowercased() == "complete"{
                cell.btnStatus.backgroundColor = helper.color_Complete
                cell.btnStatus.setTitle("Complete".localized(), for: .normal)
                
            }else if self.marrOrders[indexPath.section]["order_status"].stringValue.lowercased() == "canceled"{
                cell.btnStatus.backgroundColor = helper.color_Cancelled
                cell.btnStatus.setTitle("Cancelled".localized(), for: .normal)
            }else{
                cell.btnStatus.backgroundColor = helper.color_Rejected
                cell.btnStatus.setTitle("Rejected".localized(), for: .normal)
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? PlacedOrderTVC else { return UITableViewCell() }
        
        
        cell.configCell2()
        let marrItems:Array <JSON> = marrOrders[indexPath.section]["item"].arrayValue
        
        cell.lblItemName.text = marrItems[indexPath.row-1]["product_name"].stringValue
        
        cell.lblItemQty.text = marrItems[indexPath.row-1]["qty"].stringValue
        
        cell.lblItemPrice.text = "$ \(marrItems[indexPath.row-1]["product_price"].stringValue)"
        
        return cell
        
    }
    
    //MARK:- didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyOrderDetailVC") as! MyOrderDetailVC
        nextVC.mdictOrderDetails = marrOrders[indexPath.section].dictionaryValue
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
}
