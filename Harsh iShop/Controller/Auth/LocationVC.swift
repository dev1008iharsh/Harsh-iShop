//
//  LocationVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 08/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire


class LocationVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var viewLocation: UIView!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    
    // MARK: Properties
    let locationDropDown = DropDown()
    
    var idLocation :String?
    
 
    
    var strLocation = ""
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureReconiser()
        self.startAnimation()
        getLocationApiData()
        
        
    }
    @IBAction func btnSavenext(_ sender: UIButton) {
        if (strLocation == "")
        {
            
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Select City".localized , view: self)
            
        }else
        {
            
            UserDefaults.standard.set(idLocation, forKey: "CityId")
            UserDefaults.standard.set(strLocation, forKey: "CityName")
            
          
            
            if helper.isSkipped
            {
                
                var viewControllers = self.navigationController!.viewControllers
                print(viewControllers)
                viewControllers.reverse()
                print(viewControllers)
                for obj in viewControllers {
                 
                }
                
                
            }else{
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            
            
        }
        
    }
    
    // MARK: API Functions
    func getLocationApiData(){
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "/listing/city", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                
                print("* Location dictResponse::\(dictResponse)")
                
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
                    
                                 
                                
                    UserDefaults.standard.set(self.idLocation, forKey: "CityId")
                    UserDefaults.standard.set(self.strLocation, forKey: "CityName")
                                
                 
                                            
                                UserDefaults.standard.synchronize()
                                
                                 
                                
                         
                            
                            
                }
            }
        }
    }
    func configLocationDropDown(){
        
        viewLocation.layer.cornerRadius = 10
        viewLocation.layer.borderWidth = 1
        viewLocation.layer.borderColor = UIColor(red: 208/255.0, green: 212/255.0, blue: 219/255.0, alpha: 1).cgColor
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
            self.strLocation = item
            self.lblLocation.text = item
            self.idLocation = self.arrIdLocationDropDown[index]
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
