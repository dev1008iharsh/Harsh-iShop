//
//  ProductListVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 13/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProductListVC: UIViewController {
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var collvStories: UICollectionView!
    @IBOutlet weak var collvProducts: UICollectionView!
    @IBOutlet weak var lblTitleCategory: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
  
    
    //MARK: -  Properties
    var marrProducts : Array<JSON> = []
    
    var marrStories :Array<JSON> = []
    
    var strCategoryId = ""
    var strCategoryName = ""
    var strSearchText = ""
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitleCategory.text = strCategoryName
        startAnimation()
   
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewSearch.layer.cornerRadius =  viewSearch.frame.size.height / 2
        viewSearch.clipsToBounds = true
    }
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        strSearchText = txtSearch.text!
        if strSearchText.count > 0{
            startAnimation()
            getSearchProductApi()
        }
    }
    @IBAction func btnCart(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                  
                  let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               
            
                  
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
                   print("* dictResponse::\(dictResponse)")
                   if dictResponse["success"].boolValue
                   {
                       print("* Product Added")
                   }else{
                       print("*** auth/add_to_wishlist Api Error")
                   }
               }
           }
       }
    
    func getProductsApi(){
        
        var param:Parameters = ["category_id": strCategoryId]
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
        }
        
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "listing/category_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* getProductsApi dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                 
                    
                }else{
                    self.marrProducts.removeAll()
                    self.collvProducts.reloadData()
                    print("*** listing/category_product API error")
                    
                }
            }
        }
    }
    
    func getStoriesApi(){
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "listing/category", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* stories catogories dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrStories = dictResponse["data"].arrayValue
                    print(self.marrStories)
                    self.collvStories.reloadData()
                    
                }else{
                    print("*** stories listing/category API error")
                }
            }
        }
    }
    
    func getSearchProductApi(){
        
       
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "search/search_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* getSearchProductApi dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrProducts = dictResponse["data"].arrayValue
                    self.lblTitleCategory.text = self.strSearchText
                    self.collvProducts.reloadData()
                    
                }else{
                    self.marrProducts.removeAll()
                    self.collvProducts.reloadData()
                    print("*** getSearchProductApi API error")
                    
                }
            }
        }
    }
    
    //MARK: - Helper Functions
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
        
        collvProducts.reloadData()
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                     "product_id": dictData["product_id"]!.stringValue]
      
        
        addToFavApi(param: param)
        
    }
}

//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension ProductListVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collvStories{
            return marrStories.count
        }
        return marrProducts.count
    }
    
    //MARK: -  Collection cellForRowAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collvStories{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCVC", for: indexPath) as? StoriesCVC
                else { return UICollectionViewCell() }
            
            cell.viewBGSetup()
            
            cell.lblStories.text  = self.marrStories[indexPath.row]["category_name"].stringValue
            cell.imgStories.sd_setImage(with: self.marrStories[indexPath.row]["category_image"].url, placeholderImage: UIImage(named: ""))
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellProducts", for: indexPath) as? HomeProductCVC
            else { return UICollectionViewCell() }
        cell.viewBGShadow()
        cell.imgProduct.layer.cornerRadius = 10.0
        
        cell.lblProductTitle.text = self.marrProducts[indexPath.row]["product_name"].stringValue
        cell.lblProductPrice.text = "\(self.marrProducts[indexPath.row]["currency"].stringValue)" + " " + "\(self.marrProducts[indexPath.row]["price"].stringValue)"
        
        cell.imgProduct.sd_setImage(with: self.marrProducts[indexPath.row]["product_image"].url, placeholderImage: UIImage(named: ""))
        print(self.marrProducts)
        print(self.marrProducts[indexPath.row]["is_favourite"].boolValue)
       cell.btnFav.isHidden = !UserDefaults.standard.bool(forKey: "isLoggedIn")
        if self.marrProducts[indexPath.row]["is_favourite"].boolValue
        {
            cell.btnFav.setImage(UIImage.init(named: "filled_star"), for: .normal)
        }else{
            cell.btnFav.setImage(UIImage.init(named: "star"), for: .normal)
        }
        
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
    //MARK: -  Collection didSelectRowAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collvStories{
            self.marrProducts.removeAll()
            self.collvProducts.reloadData()
            
            lblTitleCategory.text = marrStories[indexPath.row]["category_name"].stringValue
            strCategoryId = marrStories[indexPath.row]["category_id"].stringValue
            
            startAnimation()
            
            getProductsApi()
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC")as! ProductDetailVC
            nextVC.mdictProductdetail = marrProducts[indexPath.row].dictionaryValue
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        
    }
    
}
// MARK: CollectionView FlowLayout
extension ProductListVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collvStories{
            return CGSize(width: 95, height: 90)
        }
        
        return CGSize(width: (collvProducts.frame.size.width)/2, height: (collvProducts.frame.size.width)/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collvStories{
            return 7
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == collvStories{
            return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
    }
    
}
