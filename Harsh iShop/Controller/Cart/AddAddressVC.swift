//
//  AddAddressVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 20/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import DropDown

protocol ProtocolAddressAdded: class {
    func addressAddedDelegateFunc()
}

class AddAddressVC: UIViewController,LocationSelectedDelegate {
   
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var txtAppartment: UITextField!
    
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var btnSaveAddress: UIButton!
    @IBOutlet weak var txtAddiNotes: UITextField!
    @IBOutlet weak var txtLocationOnMap: UITextField!
    
   
    //MARK: -  Properties
    
    var mdictAddress : Dictionary<String,JSON> = [:]
    
    var strAddressType : String = "Home"
    
    var isEdit = false
    var strLatitude = ""
    var strLongitude = ""
    
    
    var strCityId = ""
    
    
    var delegateAddressAdded: ProtocolAddressAdded? = nil
    
    
    let locationDropDown = DropDown()
    
    
    
    var arrLocationApi : Array<JSON> = []
    
    var arrLocationDropDown = [String]()
    
    var arrIdLocationDropDown = [String]()
    
    var strCity : String?
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureReconiser()
        self.startAnimation()
        getLocationApiData()
        
        
        if isEdit{
            
            txtHouse.text = mdictAddress["house"]?.stringValue
        
            //*** aa key ni value j khali ave 6e..
            txtLocationOnMap.text = mdictAddress["address"]?.stringValue
            
            txtAddiNotes.text = mdictAddress["additional_notes"]?.stringValue
            
            resetButtonsBackGround()
            
            switch mdictAddress["address_type"]?.stringValue {
                
            case "Home":
                btnHome.backgroundColor = helper.color_red
                btnHome.setTitleColor(.white, for: .normal)
    
            default:
                print("switch Case Failed at addresstype isEdit")
            }
            //                       Latitude = (mdictAddress["latitude"]?.stringValue)!
            //                       Longitude = (mdictAddress["longitude"]?.stringValue)!
            
            //                       strCityId = (mdictAddress["address_id"]?.stringValue)!
        }else{
            
           //*** AA Project mate..city api ma nathietle...
//            strCityId = JSON(UserDefaults.standard.value(forKey: "CityId")!).stringValue
//
//            lblCity.text = JSON(UserDefaults.standard.value(forKey: "CityName")!).stringValue
            
        }
      
        strCityId = JSON(UserDefaults.standard.value(forKey: "CityId")!).stringValue

        lblCity.text = JSON(UserDefaults.standard.value(forKey: "CityName")!).stringValue
        
    }
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSelectLocationMap(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "LocationMapVC") as! LocationMapVC
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
       
    }
    @IBAction func btnSaveAddress(_ sender: UIButton) {
        if (txtAppartment.text?.isEmpty)!
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Appartment Name".localized, view: self)
            
        }else if (txtHouse.text?.isEmpty)!
        {
            
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter House".localized , view: self)
            
        }else if (txtStreetAddress.text?.isEmpty)!
        {
            
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Street Address".localized , view: self)
            
        }else if (txtArea.text?.isEmpty)!
        {
            
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Area".localized , view: self)
            
        }else if (txtAddiNotes.text?.isEmpty)!
        {
            
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Enter Additional Notes".localized , view: self)
            
        }/*else if(Longitude.length == 0)
             {
             ModelManager().showAlert(title: helper.AlertTitle , message: "Please Select Location".localized , view: self)
             
         }*/else{
            
            startAnimation()
            addAddressApi()
        }
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        resetButtonsBackGround()
        
        btnHome.backgroundColor = helper.color_red
        btnHome.setTitleColor(.white, for: .normal)
        
        strAddressType = "Home"
    }
    
    @IBAction func btnWork(_ sender: UIButton) {
        resetButtonsBackGround()
        
        btnWork.backgroundColor = helper.color_red
        btnWork.setTitleColor(.white, for: .normal)
        strAddressType = "Work"
        
        
    }
    
    @IBAction func btnOther(_ sender: UIButton) {
        resetButtonsBackGround()
        
        btnOther.backgroundColor = helper.color_red
        btnOther.setTitleColor(.white, for: .normal)
        strAddressType = "Other"
        
    }
    //MARK: - map Selected location Delegate
    func locationSelected(strAdress: String, strLat: String, strLong: String) {
            
                   strLatitude = strLat
                   strLongitude = strLong
                   txtLocationOnMap.text = strAdress
       }
       
    
    //MARK: - API Functions
    func getLocationApiData(){
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "/listing/city", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                
                print("* City dictResponse::\(dictResponse)")
                
                if dictResponse["success"].boolValue
                {
                    self.arrLocationApi = dictResponse["data"].arrayValue
                    
                    for i in 0 ..< self.arrLocationApi.count {
                        let string = self.arrLocationApi[i]["city_name"].stringValue
                        self.arrLocationDropDown.append(string)
                        
                        let id = self.arrLocationApi[i]["city_id"].stringValue
                        self.arrIdLocationDropDown.append(id)
                    }
                    
                    self.configLocationDropDown()
                    
                }else{
                    print("*** listing/city API error")
                }
            }
        }
    }
    
    
    func addAddressApi(){
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "address_type":strAddressType,
            "apartment":txtAppartment.text!,
            "house":txtHouse.text!,
            "street_address":txtStreetAddress.text!,
            "area":txtArea.text!,
            "city_id": strCityId ,
            "additional_notes":txtAddiNotes.text!,
            "address_id": isEdit ? mdictAddress["address_id"]!.stringValue : "",
            "latitude": strLatitude,
            "longitude": strLongitude,
            "address" : txtLocationOnMap.text ?? ""
            ] as [String : Any]
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        
        let request = AF.request(helper.baseUrl + "auth/add_edit_address", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                
                print("* Add Address dictResponse::\(dictResponse)")
                
                if dictResponse["success"].boolValue
                {
                    self.delegateAddressAdded?.addressAddedDelegateFunc()
                    _ = self.navigationController?.popViewController(animated: false)
                    
                }else{
                    print("*** auth/add_edit_address API Error")
                    ModelManager().showAlert(title: helper.alertTryAgain, message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    //MARK: - Helper Functions
    
    func resetButtonsBackGround(){
        btnHome.backgroundColor = .clear
        btnHome.setTitleColor(helper.color_red, for: .normal)
        
        btnWork.backgroundColor = .clear
        btnWork.setTitleColor(helper.color_red, for: .normal)
        
        btnOther.backgroundColor = .clear
        btnOther.setTitleColor(helper.color_red, for: .normal)
        
    }
    
    
    func configLocationDropDown(){
        
        locationDropDown.anchorView = viewLocation
        locationDropDown.direction = .any
        //locationDropDown.selectRow(at: 0)
        locationDropDown.dataSource = arrLocationDropDown
        
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        locationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //print("Selected LocationDropDown item: \(item) at index: \(index)")
            self.strCity = item
            self.lblCity.text = item
            self.strCityId = self.arrIdLocationDropDown[index]
        }
        
    }
    // MARK: Tap Gestures
    func tapGestureReconiser(){
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(tapLocationDropDown))
        locationGesture.numberOfTapsRequired  = 1
        locationGesture.numberOfTouchesRequired = 1
        viewLocation.addGestureRecognizer(locationGesture)
        
    }
    
    
    // MARK: @objc Selectors
    @objc func tapLocationDropDown(){
        locationDropDown.show()
    }
    
}
