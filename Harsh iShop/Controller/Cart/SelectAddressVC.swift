//
//  SelectAddressVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 20/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage
protocol ProtocolAddressSelected {
    func addressSelectedDelegateFunc(addressId: String ,addressTitle: String,address:String)
}

class SelectAddressVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tblAddress: UITableView!
    
    var marrAddress : Array<JSON> = []
    
    var delegateAddSelected: ProtocolAddressSelected? = nil
    
    var delegateAddressAdded: ProtocolAddressAdded? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        startAnimation()
        getAddressApi()
    }
    
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddAddress(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddAddressVC")as! AddAddressVC
        
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK: -  API Functions
    func getAddressApi(){
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue]
        
        
        
        print(param)
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/address_list", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("Select Address dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrAddress = dictResponse["data"].arrayValue
                    self.tblAddress.reloadData()
                    
                }else{
                    print("*** auth/address_list Api Error")
                    
                }
            }
        }
    }
    
    func deleteAddressApi(strAddressId : String){
        let param: Parameters = ["address_id": strAddressId
        ]
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/delete_address", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("Delete Address dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.startAnimation()
                    self.getAddressApi()
                    self.tblAddress.reloadData()
                    
                }else{
                    print("*** auth/delete_address Api Error")
                    ModelManager().showAlert(title: helper.alertTryAgain.localized, message: dictResponse["message"].stringValue, view: self)
                }
            }
        }
    }
    
    //MARK: -  Helper Functions
    @objc func btnMore(sender : UIButton) {
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "PopOverVC") as! PopOverVC
        
        popoverContent.delegatePopOver = self
        
        popoverContent.index = sender.tag
        
        let nav = UINavigationController(rootViewController: popoverContent)
        
        nav.modalPresentationStyle = .popover
        
        nav.navigationBar.isHidden = true
        
        
        
        
        let popover = nav.popoverPresentationController
        
        popoverContent.isModalInPopover = false
        
        popoverContent.preferredContentSize = CGSize(width: 100, height: 60 )
        
        popover?.delegate = self
        
        popover?.sourceView = sender
        
        popover?.sourceRect = sender.bounds
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
}
// MARK: -  Custom Delegate Functions
extension SelectAddressVC : ProtocolAddressAdded{
    func addressAddedDelegateFunc() {
        startAnimation()
        getAddressApi()
    }
    
    
}
// MARK: -  PopOver View Controller Delegate Functions
extension SelectAddressVC : ProtocolPopOver{
    func editDelegateFunc(index: Int) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddAddressVC")as! AddAddressVC
        
        nextVC.delegateAddressAdded = self
        
        nextVC.isEdit = true
        
        nextVC.mdictAddress = marrAddress[index].dictionaryValue
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    func deleteDelegateFunc(index: Int) {
        
        startAnimation()
        
        deleteAddressApi(strAddressId: marrAddress[index]["address_id"].stringValue)
        
        
    }
    
    
}

// MARK: -  UITableViewDelegate, UITableViewDataSource

extension SelectAddressVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrAddress.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK:  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAddressTVC", for: indexPath) as! SelectAddressTVC
        
        
        cell.lblTitle.text = marrAddress[indexPath.row]["address_type"].stringValue
        
        cell.lblAddress.text =  marrAddress[indexPath.row]["house"].stringValue + ", " + marrAddress[indexPath.row]["apartment"].stringValue + ", " + marrAddress[indexPath.row]["street_address"].stringValue + ", " + marrAddress[indexPath.row]["area"].stringValue
        
        cell.viewBGsetup()
        
        cell.btnMore.addTarget(self, action: #selector(btnMore(sender:)), for: .touchUpInside)
        cell.btnMore.tag = indexPath.row
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = marrAddress[indexPath.row]["house"].stringValue + ", " + marrAddress[indexPath.row]["apartment"].stringValue + ", " + marrAddress[indexPath.row]["street_address"].stringValue + ", " + marrAddress[indexPath.row]["area"].stringValue
        
        self.delegateAddSelected?.addressSelectedDelegateFunc(addressId: marrAddress[indexPath.row]["address_id"].stringValue, addressTitle: marrAddress[indexPath.row]["address_type"].stringValue,address: address)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

