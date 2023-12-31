//
//  CartVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import DropDown


class CartVC: UIViewController {
    
    //MARK: -  @IBOutlet
    
    @IBOutlet weak var tblCart: UITableView!
    
    @IBOutlet weak var imgAlphaPromo: UIImageView!
    @IBOutlet weak var tblCartHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewShippingAddress: UIView!
    @IBOutlet weak var viewDeliveryPortion: UIView!
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblPromoMessage: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressSubTitle: UILabel!
    
    @IBOutlet weak var txtPromo: TextFieldArabic!
    @IBOutlet weak var imgPickUp: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var lblVat: UILabel!
    
    @IBOutlet weak var btnViewSelectDateLeft: UIView!
    
    @IBOutlet weak var viewPromo: UIView!
    
    
    @IBOutlet weak var viewPromoMessage: UIView!
    @IBOutlet weak var btnViewSelectedTimeRIght: UIView!
    @IBOutlet weak var btnViewSelectTimeLeft: UIView!
    @IBOutlet weak var btnSelectTimeRight: UIButton!
    @IBOutlet weak var btnSelectDateRight: UIButton!
    @IBOutlet weak var viewEmptyCart: UIView!
    @IBOutlet weak var viewPromoDiscount: UIView!
    @IBOutlet weak var lblPromoDiscount: UILabel!
     @IBOutlet weak var btnPlaceOrder: UIButton!
    
    @IBOutlet weak var lblSelectedTime: UILabel!
    @IBOutlet weak var lblSelectedDate: UILabel!
    
    //MARK: -  Properties
    
    var marrTimes : Array<String> = []
    var marrDates : Array<String> = []
    var marrCartProducts : Array<JSON> = []
    
    //Dictionary For Value Sending in Cart
    var mdictCart : Dictionary<String,JSON> = [:]
    
    
    var isPaymentCash : Bool = false
    var isPickUp : Bool = false
    
    let deliDateDropDown = DropDown()
    
   var strDeliDate: String = ""
    var strAddressId: String = ""
    var strDeliTime: String = ""
    
    
 
    
    let deliTimeDropDown = DropDown()
    
 
    var delegateAddSelected : ProtocolAddressSelected? = nil
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*** Calculating Delivery Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - MMM dd, yyyy"
        dateFormatter.locale = Locale.init(identifier: "en")
 
        for i in 0 ... 3
        {
            today = calendar.date(byAdding: .day, value: i+4, to:Date())!
            marrDates.append(dateFormatter.string(from: today))
        }
        
        
        //*** Calculating Delivery Time
        marrTimes.append("09 : 00 AM")
        marrTimes.append("12 : 00 PM")
        marrTimes.append("03 : 00 PM")
        marrTimes.append("06 : 00 PM")
        self.scrollView.isHidden = true
                  self.viewEmptyCart.isHidden = true
                  self.tblCartHeight.constant = 0
                  
                  self.imgAlphaPromo.alpha = 0.0
                  self.viewPromo.isHidden = true
                  self.viewPromoMessage.isHidden = true
                  
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.scrollView.isHidden = true
            self.viewEmptyCart.isHidden = true
     
            
            
            if strAddressId.count > 0
            {
                viewShippingAddress.isHidden = false
                
            }else{
                viewShippingAddress.isHidden = true
                
            }
            
            startAnimation()
            getCartProductsApi()
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
    }
    
    //MARK: -  Buttons Actions
    @IBAction func btnAddAddress(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        nextVC.delegateAddSelected = self as ProtocolAddressSelected
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction func btnEdit(_ sender: UIButton) {
        
       let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        nextVC.delegateAddSelected = self as ProtocolAddressSelected
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func btnOpenApplyPromo(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.33) {
            self.txtPromo.becomeFirstResponder()
            self.imgAlphaPromo.alpha = 0.7
            self.viewPromo.isHidden = false
            
        }
        
        
    }
    @IBAction func btnViewPromoClose(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.33) {
            self.txtPromo.resignFirstResponder()
            self.imgAlphaPromo.alpha = 0.0
            self.viewPromo.isHidden = true
        }
        
    }
    
    @IBAction func btnCash(_ sender: UIButton) {
        isPaymentCash = true
        btnCash.setImage(UIImage.init(named: "select"), for: .normal)
        btnCard.setImage(UIImage.init(named: "unselect"), for: .normal)
    }
    
    @IBAction func btnCard(_ sender: UIButton) {
        
        isPaymentCash = false
        btnCash.setImage(UIImage.init(named: "unselect"), for: .normal)
        btnCard.setImage(UIImage.init(named: "select"), for: .normal)
    }
    @IBAction func btnApplyPromoPopUp(_ sender: UIButton) {
        startAnimation()
        getCartProductsApi()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnProfileTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
    
    @IBAction func btnPickUpTapped(_ sender: UIButton) {
        viewDeliveryPortion.isHidden = !viewDeliveryPortion.isHidden
        if viewDeliveryPortion.isHidden
        {
            imgPickUp.image = UIImage.init(named: "check")
            isPickUp = true
        }else{
            imgPickUp.image = UIImage.init(named: "uncheck")
            isPickUp = false
        }
    }
    
    @IBAction func btnFavTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @IBAction func btnHomeTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    @IBAction func btnSelectDate(_ sender: UIButton) {
        if LanguageChanger.currentAppleLanguage() == "ar" {
            deliDateDropDown.anchorView = btnViewSelectDateLeft
            
        }else{
            deliDateDropDown.anchorView = btnSelectDateRight
            
        }
        deliDateDropDown.direction = .any
        deliDateDropDown.selectRow(at: 0)
        deliDateDropDown.dataSource = marrDates
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 50
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
      
        
        
        deliDateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //print("Selected deliDateDropDown item: \(item) at index: \(index)")
            self.strDeliDate = item
            self.lblSelectedDate.text = item
            //self.idLocation = self.arrIddeliDateDropDown[index]
        }
        deliDateDropDown.show()
    }
    
    @IBAction func btnSelectTime(_ sender: UIButton) {
        if LanguageChanger.currentAppleLanguage() == "ar" {
            deliTimeDropDown.anchorView = btnViewSelectTimeLeft
            
        }else{
            deliTimeDropDown.anchorView = btnViewSelectedTimeRIght
            
        }
        deliTimeDropDown.direction = .any
        deliTimeDropDown.selectRow(at: 0)
        deliTimeDropDown.dataSource = marrTimes
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 50
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 15
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 1
        //appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        
        deliTimeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //print("Selected deliDateDropDown item: \(item) at index: \(index)")
            self.strDeliTime = item
            self.lblSelectedTime.text = item
            //self.idLocation = self.arrIddeliDateDropDown[index]
        }
        deliTimeDropDown.show()
        
    }
    
    //MARK: - Helper Functions
    @objc func btnDelete( sender: UIButton) {
        
        let dictData = marrCartProducts[sender.tag].dictionaryValue
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "cart_id": dictData["cart_id"]!.stringValue,
            "qty": "0"]
       
        startAnimation()
        updateCartApi(param: param)
        
    }
    
    
    @objc func btnMinus( sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblCart.cellForRow(at: indexPath) as! CartTVC
        
        var dictData = marrCartProducts[sender.tag].dictionaryValue
        
        
        if let qty = dictData["qty"]?.intValue{
            
            if qty > 1
            {
                dictData["qty"] = JSON("\(qty - 1)")
            }else if qty == 1{
                
                
                let dictData = marrCartProducts[sender.tag].dictionaryValue
                
                let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                    "cart_id": dictData["cart_id"]!.stringValue,
                    "qty": "0"]
                
                startAnimation()
                updateCartApi(param: param)
            }else{
                
            }
        }else{
            print("** responce Failed At btnMinusApi Configuration")
        }
        
        cell.lblQty.text = dictData["qty"]!.stringValue
        
        marrCartProducts[sender.tag] = JSON(dictData)
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "cart_id": dictData["cart_id"]!.stringValue,
            "qty": dictData["qty"]!.stringValue]
        
       
        startAnimation()
        updateCartApi(param: param)
        
    }
    
    @objc func btnAdd( sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblCart.cellForRow(at: indexPath) as! CartTVC
        
        var dictData = marrCartProducts[sender.tag].dictionaryValue
        
        
        if let qty = dictData["qty"]?.intValue{
            dictData["qty"] = JSON(qty + 1)
        }else{
            dictData["qty"] = JSON("1")
        }
        
        cell.lblQty.text = dictData["qty"]!.stringValue
        
        marrCartProducts[sender.tag] = JSON(dictData)
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "cart_id": dictData["cart_id"]!.stringValue,
            "qty": dictData["qty"]!.stringValue]
        
        
        startAnimation()
        updateCartApi(param: param)
        
    }
    //MARK: -  Place Order Buttons
    
    @IBAction func btnPlaceOrder(_ sender: UIButton) {
        if marrCartProducts.count  == 0
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Add Some Items to Cart".localized, view: self)
        }else if !isPickUp && (strAddressId == "")
        {
            ModelManager().showAlert(title: helper.alertTitle.localized , message: "Please Select Address".localized,
        }else{
            
            startAnimation()
            placeOrderApi()
            
        }
        
    }
    //MARK: -  API Functions
    
    func placeOrderApi() {
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                             "address_id":strAddressId,
                             "off_deliveries":"Yes",
                             "delivery_date":strDeliDate,
                             "delivery_time":strDeliTime,
                             "payment_method":isPaymentCash ? "Cash" : "Card",
                             "vat":self.mdictCart["vat"]!.stringValue,
                             "total_vat":self.mdictCart["total_vat"]!.stringValue,
                             "sub_total":self.mdictCart["sub_total"]!.stringValue,
                             "total":self.mdictCart["total"]!.stringValue,
                             "total_delivery_charge":self.mdictCart["total_delivery_charge"]!.stringValue,
                             "delivery_charge":self.mdictCart["delivery_charge"]!.stringValue,
                             "promo_code":self.mdictCart["promo_code"]!.stringValue,
                             "promo_code_discount":self.mdictCart["promo_code_discount"]!.stringValue,
                             "promo_code_type":self.mdictCart["promo_code_type"]!.stringValue,
                             "promo_code_value":self.mdictCart["promo_code_value"]!.stringValue,
                             "promo_code_id":self.mdictCart["promo_code_id"]!.stringValue,
                             "is_pickup": isPickUp ? "1" : "0"]
               
               
               //self.mdictPromo
               print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "order/add_order", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()

            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Place Add Order Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "CongratesVC") as! CongratesVC
               
                    
                }else{
                    print("*** order/add_order API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    
    
    func updateCartApi(param : Parameters) {
        
        print(param)
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "cart/update_cart", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* UpdateCart Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.getCartProductsApi()
                    
                }else{
                    print("*** cart/update_cart API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    
    
    func getCartProductsApi(){
        
        var param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
            "off_deliveries":"Yes"]
        
        if txtPromo.text != ""
        {
            param["promo_code"] = txtPromo.text
        }
        
       
        
        
        print(param)
        
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "cart/get_cart", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimating()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("*getCartProducts::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    self.mdictCart = dictResponse.dictionaryValue
                    
                    //SetUp TableHeight - Reload Data
                    self.marrCartProducts = dictResponse["data"].arrayValue
                    self.tblCartHeight.constant = CGFloat((self.marrCartProducts.count * 110))
                    self.tblCart.reloadData()
                    
                    //SetUp Lables Of Price
                    self.lblSubTotal.text = dictResponse["currency"].stringValue + dictResponse["sub_total"].stringValue
                    self.lblVat.text = dictResponse["vat"].stringValue
                    self.lblDeliveryCharge.text = dictResponse["currency"].stringValue + dictResponse["total_delivery_charge"].stringValue
                    self.lblTotal.text = dictResponse["currency"].stringValue + dictResponse["total"].stringValue
                    
                    
                    //SetUp PromoCode
                    self.lblPromoDiscount.text =  dictResponse["currency"].stringValue + dictResponse["promo_code_discount"].stringValue
                    
                    if dictResponse["promo_code_discount"].floatValue > 0.0
                    {
                        self.viewPromoDiscount.isHidden = false
                    }else{
                        self.viewPromoDiscount.isHidden = true
                    }
                    
                    
                    let strPromoValue : String?
                    strPromoValue = dictResponse["promo_code_message"].stringValue
                    
                    if strPromoValue == ""
                    {
                        self.viewPromoMessage.isHidden = true
                        
                    }else if strPromoValue == "false"
                    {
                        ModelManager().showAlert(title: helper.alertTryAgain.localized, message: "Invalid PromoCode !".localized, view: self)
                        self.lblPromoMessage.text = "Invalid PromoCode !"
                        self.viewPromoMessage.isHidden = false
                        
                    }else{
                        
//
//                        ModelManager().showAlert(title: "Yehh", message: "PromoCode Applied Successfully", view: self)
//                        self.lblPromoMessage.text = "Invalid PromoCode !"
//                        self.lblPromoMessage.text = dictResponse["promo_code_message"].stringValue
//
                    }
                    
                    self.viewPromo.isHidden = true
                    self.txtPromo.text = ""
                    
                    
                    //SetUp EmptyCart Icon ScrolView
                    self.scrollView.isHidden = false
                    self.viewEmptyCart.isHidden = true
                    
                    //self.getDeliveryTime()
                    
                }else{
                    print("*** cart/get_cart api error")
                    self.scrollView.isHidden = true
                    self.viewEmptyCart.isHidden = false
                    
                    self.marrCartProducts.removeAll()
                    
                    self.tblCartHeight.constant = CGFloat(100 * self.marrCartProducts.count)
                    
                    self.tblCart.reloadData()
                    
                    self.lblSubTotal.text = "0.0"
                    self.lblDeliveryCharge.text = "0.0"
                    self.lblVat.text = "0.0"
                    self.lblTotal.text = "0.0"
                }
            }
            
            
        }
    }
    
    
    //    func getDeliveryTime() {
    //
    //
    //           let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
    //
    //           let request = AF.request( helper.baseUrl + "listing/get_delivery_time", method: .post, parameters: nil, headers: headers)
    //           request.responseJSON { response in
    //
    //               self.stopAnimating()
    //
    //               if let result = response.value {
    //
    //                   let dictResponse = JSON(result as! NSDictionary)
    //
    //                   print("Delivery Time ::-\(dictResponse)")
    //
    //                   if dictResponse["success"].boolValue
    //                   {
    //
    //                       self.marrTimes = dictResponse["data"].arrayValue
    //                    print(self.marrTimes)
    //                   }else{
    //                       print("** listing/get_delivery_time API Error")
    //                       ModelManager().showAlert(title: helper.alertTitle , message: dictResponse["message"].stringValue, view: self)
    //
    //                   }
    //               }
    //           }
    //       }
    
    
    
    
    
    
    
    
    
    
}
//MARK: - Address Delegate Methos Confiremed


extension CartVC : ProtocolAddressSelected{
    func addressSelectedDelegateFunc(addressId: String, addressTitle: String, address: String) {
        print(addressId)
        print(addressTitle)
        print(address)
        strAddressId = addressId
        
        lblAddressTitle.text  = addressTitle
        lblAddressSubTitle.text = address
        
        if strAddressId.count > 0
        {
            viewShippingAddress.isHidden = false
            
        }
    }
    
    
}
//MARK: - UITableViewDelegate, UITableViewDataSource

extension CartVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrCartProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK:  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC", for: indexPath) as? CartTVC else { return UITableViewCell() }
        
        cell.lblTitle.text  = self.marrCartProducts[indexPath.row]["product_name"].stringValue
        cell.lblPrice.text  = self.marrCartProducts[indexPath.row]["currency"].stringValue + self.marrCartProducts[indexPath.row]["product_price"].stringValue
        cell.lblQty.text  = self.marrCartProducts[indexPath.row]["qty"].stringValue
        cell.imgProduct.sd_setImage(with: self.marrCartProducts[indexPath.row]["product_image"].url, placeholderImage: UIImage(named: ""))
        
        
        
        cell.btnAdd.addTarget(self, action: #selector(btnAdd(sender:)), for:.touchUpInside)
        cell.btnAdd.tag = indexPath.row
        
        cell.btnMinus.addTarget(self, action: #selector(btnMinus(sender:)), for:.touchUpInside)
        cell.btnMinus.tag = indexPath.row
        
        cell.btnDelete.addTarget(self, action: #selector(btnDelete(sender:)), for:.touchUpInside)
        cell.btnDelete.tag = indexPath.row
        
        return cell
        
    }
    
}
