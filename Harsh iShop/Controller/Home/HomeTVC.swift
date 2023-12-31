//
//  CategoryTVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 10/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import NVActivityIndicatorView

class HomeTVC: UITableViewCell {
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var collvProducts: UICollectionView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    
    
    //MARK: -  Properties
    var marrProducts :Array<JSON> = []
    
    
    //MARK: -  ViewController LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setDelegate()  {
        
        collvProducts.delegate = self
        collvProducts.dataSource = self
        
    }
    //MARK: -  Buttons Actions
    
    @IBAction func btnFavTapped(_ sender: UIButton) {
        var dictData = marrProducts[sender.tag].dictionaryValue
        if dictData["is_favourite"]!.boolValue
        {
            
            dictData["is_favourite"] = JSON("0")
            
        }else{
            
            dictData["is_favourite"] = JSON("1")
            
        }
        
        marrProducts[sender.tag] = JSON(dictData)
        collvProducts.reloadData()
    
        
        addToFavApi(param: parameters)
    }
    //MARK: -  API Functions
    func addToFavApi(param : Parameters){
        print(param)
        
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
        
        collvProducts.reloadData()
        
        
        let param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue,
                     "product_id": dictData["product_id"]!.stringValue]
       
        
        addToFavApi(param: param)
        
    }
    
  
    
}

extension HomeTVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marrProducts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellProducts", for: indexPath) as? HomeProductCVC
            else { return UICollectionViewCell() }
        cell.viewBGShadow()
        cell.imgProduct.layer.cornerRadius = 10.0
        
        cell.lblProductTitle.text = self.marrProducts[indexPath.row]["product_name"].stringValue
        cell.lblProductPrice.text = "\(self.marrProducts[indexPath.row]["currency"].stringValue)" + " " + "\(self.marrProducts[indexPath.row]["price"].stringValue)"
        
        cell.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        helper.mdictProductdetail = marrProducts[indexPath.row].dictionaryValue
        
        let notificationName = Notification.Name("goToProductDetail")
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        
    }
    
}
//MARK: -  CollectionView FlowLayout Delegate
extension HomeTVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collvProducts.frame.size.width - 25)/2, height: collvProducts.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
    }
    
}
