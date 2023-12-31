//
//  ProductDetailVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage


class ProductDetailVC: UIViewController, UIScrollViewDelegate  {
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var collvDetailSlider: UICollectionView!
    @IBOutlet weak var viewCartBuyNwButtons: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var collvRecent: UICollectionView!
    @IBOutlet weak var btnCart: UIButton!
    //@IBOutlet weak var lblBadge: BadgeSwift!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var viewBadge: UIView!
    
    @IBOutlet weak var lblRecentlyViewed: UILabel!
    
    @IBOutlet weak var viewCollvRecent: UIView!
    
    
    //MARK: -  Properties
    var marrProducts :Array<JSON> = []
    var mdictProductdetail:Dictionary<String,JSON> = [:]
    var marrDetailSlider : Array<JSON> = []
    var qty = 0
    var strProductName : String? = nil
    var strItemId = ""
    
    var marrCartProducts : Array<JSON> = []
    var mdictQty : Dictionary<String,JSON> = [:]
    var marrQty : Array<JSON> = []
    var marrAllKey : Array<JSON> = []
    
    
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if strItemId.count > 0
        {
            startAnimation()
            getProductDetailForSliderTapped()
            
        }else{
            startAnimation()
            setUpProductDetail()
            getCartProductsApi()
        }
        
        //self.lblBadge.isHidden = true
        
        
        
    
        
        
    }
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCart(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    @IBAction func btnMinus(_ sender: UIButton) {
        if qty ==  1{
            lblQty.text = "1"
        }else if qty > 1{
            qty-=1
            
            let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                         "product_id": mdictProductdetail["product_id"]!.stringValue,
                         "qty": "-1"]
            //"price_unit": mdictProductdetail["price_unit"]!.stringValue]
            
            
            startAnimation()
            addToCartApi(param: param)
            
        }
        
    }
    
    @IBAction func btnPlus(_ sender: UIButton) {
        qty+=1
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                     "product_id": mdictProductdetail["product_id"]!.stringValue,
                     "qty": "1"]
        
        
        startAnimation()
        addToCartApi(param: param)
    }
    
    
    @IBAction func btnProceedToCart(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            qty+=1
            lblQty.text = "\(qty)"
            
            let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                         "product_id": mdictProductdetail["product_id"]!.stringValue,
                         "qty": "1"]
            
            
            startAnimation()
            addToCartApi(param: param)
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
        
    }
    
    @IBAction func btnBuyNow(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            qty+=1
            lblQty.text = "\(qty)"
            
            let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                         "product_id": mdictProductdetail["product_id"]!.stringValue,
                         "qty": "1"]
            
            
            startAnimation()
            addToCartBuyNowApi(param: param)
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
    @IBAction func btnFav(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            if mdictProductdetail["is_favourite"]!.boolValue
            {
                
                mdictProductdetail["is_favourite"] = JSON("0")
                btnFav.setImage(UIImage.init(named: "star"), for: .normal)
            }else{
                
                mdictProductdetail["is_favourite"] = JSON("1")
                btnFav.setImage(UIImage.init(named: "filled_star"), for: .normal)
            }
            
            
            let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                         "product_id": mdictProductdetail["product_id"]!.stringValue]
            
            print(param)
            addToFavApi(param: param)
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
        
        
        
    }
    
    
    //MARK: -  API Functions
    func addToFavApi(param : Parameters){
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "auth/add_to_wishlist", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    print("* Product Added")
                }else{
                    print("*** auth/add_to_wishlist Api Error")
                }
            }
        }
    }
    
    
    
    
    
    
    
    func getRecentlyViewedProducts() {
        
        let arr = helper.marrRecentlyViewed as NSArray
        let stringRepresentation = arr.componentsJoined(by: ",")
        
        print(stringRepresentation)
        
        var param:Parameters = ["product_id": stringRepresentation]
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
        }
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "listing/recent_view_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Recent Product dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    
                    self.marrProducts = dictResponse["data"].arrayValue
                    
                    self.lblRecentlyViewed.isHidden = false
                    self.viewCollvRecent.isHidden = false
                    self.collvRecent.reloadData()
                    
                    if self.marrProducts.count == 0
                    {
                        self.lblRecentlyViewed.isHidden = true
                        self.viewCollvRecent.isHidden = true
                        self.marrProducts.removeAll()
                        self.collvRecent.reloadData()
                    }
                    
                }else{
                    
                    print("*** listing/recent_view_product API Error")
                    self.lblRecentlyViewed.isHidden = true
                    self.viewCollvRecent.isHidden = true
                    self.marrProducts.removeAll()
                    self.collvRecent.reloadData()
                    
                }
            }
        }
    }
    
    func addToCartApi(param : Parameters) {
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "cart/add_cart", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* AddToCart Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.viewCartBuyNwButtons.isHidden = true
                    self.getCartProductsApi()
                    
                }else{
                    print("*** cart/add_cart API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    func addToCartBuyNowApi(param : Parameters) {
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "cart/add_cart", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* UpdateCart Response::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                    
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }else{
                    print("*** cart/update_cart API Error")
                    ModelManager().showAlert(title: helper.alertTitle.localized , message: dictResponse["message"].stringValue, view: self)
                    
                }
            }
        }
    }
    
    func getProductDetailForSliderTapped(){
        var param:Parameters = ["product_id": strItemId]

        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {

            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
        }
        print(param)
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]

        let request = AF.request( helper.baseUrl + "listing/recent_view_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in

            self.stopAnimating()

            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* get Product Slider Tapped ::\(dictResponse)")
                if dictResponse["success"].boolValue
                {

                    self.mdictProductdetail = dictResponse["data"][0].dictionaryValue
                    print(self.mdictProductdetail)
                    self.setUpProductDetail()
                    
                }else{

                    print("* get Product Slider Tapped API Error")

                }
            }


        }
    }
    
    func getCartProductsApi(){
        print("getCartProductsApi")
        var param = ["off_deliveries":"Yes"]
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
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
                    
                    self.marrQty = dictResponse["data"].arrayValue
                    for i in 0..<self.marrQty.count{
                        let productName = self.marrQty[i]["product_name"].stringValue
                        let productQty = self.marrQty[i]["qty"].stringValue
                        self.mdictQty["\(productName)"] = JSON(productQty)
                        
                    }
                    print(self.mdictQty)
                    
                    self.setUpProductDetail()
                    
                    
                    //                    self.lblBadge.text = "\(dictResponse["data"].arrayValue.count)"
                    //
                    //                    if self.lblBadge.text != "0"
                    //                    {
                    //                        self.lblBadge.isHidden = false
                    //                        self.btnCart.isHidden = false
                    //                    }else{
                    //                        self.lblBadge.isHidden = true
                    //                        self.btnCart.isHidden = true
                    //                   }
                    
                }else{
                    
                    //                    self.lblBadge.isHidden = true
                    //                    self.btnCart.isHidden = true
                    
                }
            }
            
            
        }
    }
    
    //MARK: -  Helper Functions
    
    
    @objc func btnFav(sender: UIButton) {
        
        var dictData = marrProducts[sender.tag].dictionaryValue
        print(dictData)
        //0 means False. 1 means True
        if dictData["is_favourite"]!.boolValue
        {
            
            dictData["is_favourite"] = JSON("0")
            
        }else{
            
            dictData["is_favourite"] = JSON("1")
            
        }
        print(JSON(dictData))
        print(marrProducts[sender.tag])
        
        marrProducts[sender.tag] = JSON(dictData)
        
        collvRecent.reloadData()
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                     "product_id": dictData["product_id"]!.stringValue]
        
        
        addToFavApi(param: param)
        
    }
    
    func setUpProductDetail(){
        
        //*** getting Recently Viewd Product
        getRecentlyViewedProducts()
        
        print("setUpProductDetail")
        if mdictProductdetail["is_favourite"]!.boolValue
        {
            btnFav.setImage(UIImage.init(named: "filled_star"), for: .normal)
            
        }else{
            btnFav.setImage(UIImage.init(named: "star"), for: .normal)
            
        }
        
        lblTitle.text = mdictProductdetail["product_name"]!.stringValue
        lblName.text = mdictProductdetail["product_name"]!.stringValue
        strProductName = mdictProductdetail["product_name"]!.stringValue
        
        //TODO - Search ni API ma Price ni key avti nathi etle Crash thay 6e..
        lblPrice.text = "\(self.mdictProductdetail["currency"]!.stringValue)" + " " + "\(self.mdictProductdetail["price"]!.stringValue)"
        
        lblDesc.text = mdictProductdetail["description"]!.stringValue
        
        marrDetailSlider = mdictProductdetail["product_images"]!.arrayValue
        
        
        if self.mdictQty.keys.contains(mdictProductdetail["product_name"]!.stringValue){
            
            lblQty.text = mdictQty["\(mdictProductdetail["product_name"]!.stringValue)"]?.stringValue ?? "0"
            
            
        }
        if lblQty.text == "0"{
            viewCartBuyNwButtons.isHidden = false
        }else{
            viewCartBuyNwButtons.isHidden = true
        }
        
        pageDots.numberOfPages = marrDetailSlider.count
        
        
        //*** Setting Up Recently Viewd Product
        setUpRecentlyViewdProduct()
        
        
    }
    
    func setUpRecentlyViewdProduct(){
        //*** If product does not exists then add it to array... Other wise if exists thake that product get the id of that product remove that product from array and add it to 0th index...
        
        if !helper.marrRecentlyViewed.contains(mdictProductdetail["product_id"]!)
        {
            helper.marrRecentlyViewed.insert(mdictProductdetail["product_id"]!, at: 0)
            
        }else{
            
            let arr = helper.marrRecentlyViewed as Array
            let strId = "\(mdictProductdetail["product_id"]!.stringValue)"
            let index = arr.firstIndex(of: JSON(strId))
            helper.marrRecentlyViewed.remove(at: index!)
            helper.marrRecentlyViewed.insert(mdictProductdetail["product_id"]!, at: 0)
        }
        print(helper.marrRecentlyViewed)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDots.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
    }
    
    
}
//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension ProductDetailVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collvRecent{
            return marrProducts.count
        }
        return marrDetailSlider.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: -   Collection cellForRowAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collvRecent{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellProducts", for: indexPath) as? HomeProductCVC
                else { return UICollectionViewCell() }
            cell.viewBGShadow()
            cell.imgProduct.layer.cornerRadius = 10.0
            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            /*
            self.imageView.sd_setShowActivityIndicatorView(true)

            //give style value
            self.imageView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            */
            
            cell.lblProductTitle.text = self.marrProducts[indexPath.row]["product_name"].stringValue
            cell.lblProductPrice.text = "\(self.marrProducts[indexPath.row]["currency"].stringValue)" + " " + "\(self.marrProducts[indexPath.row]["price"].stringValue)"
            
            cell.imgProduct.sd_setImage(with: self.marrProducts[indexPath.row]["product_image"].url, placeholderImage: UIImage(named: ""))
            
            
            cell.btnFav.isHidden = !UserDefaults.standard.bool(forKey: "isLoggedIn")
            cell.btnFav.addTarget(self, action: #selector(btnFav(sender:)), for:.touchUpInside)
            cell.btnFav.tag = indexPath.row
            if self.marrProducts[indexPath.row]["is_favourite"].boolValue
            {
                cell.btnFav.setImage(UIImage.init(named: "filled_star"), for: .normal)
            }else{
                cell.btnFav.setImage(UIImage.init(named: "star"), for: .normal)
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSliderCVC", for: indexPath) as? HomeSliderCVC
            else { return UICollectionViewCell() }
        cell.imgSlider.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgSlider.layer.cornerRadius = 10.0
        cell.imgSlider.sd_setImage(with: self.marrDetailSlider[indexPath.row].url, placeholderImage: UIImage(named: ""))
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(mdictProductdetail)
        if collectionView == collvRecent{
            mdictProductdetail = self.marrProducts[indexPath.row].dictionaryValue
            setUpProductDetail()
            collvDetailSlider.reloadData()
            print(mdictProductdetail)
            
        }
       
    }
    
}
//MARK: -  CollectionView DataSource Delegate
extension ProductDetailVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collvRecent{
            return CGSize(width: (collvRecent.frame.size.width - 25)/2, height: collvRecent.frame.size.height)
        }
        return CGSize(width: collvDetailSlider.bounds.width, height: collvDetailSlider.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collvRecent{
            return 5
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collvRecent{
            return 0
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == collvRecent{
            return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
    }
    
}
