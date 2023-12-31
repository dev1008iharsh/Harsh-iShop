//
//  FavouritesVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 11/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavouritesVC: UIViewController {
    
    @IBOutlet weak var collvFav: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            self.viewEmptyCart.isHidden = true
        
            getFavApi()
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
       
            
        }
        
    }
    //MARK: -  Buttons Actions
    @IBAction func btnBack(_ sender: BackBtnArabic) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnProfileTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
     
        
    }
    
    
    @IBAction func btnHomeTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @IBAction func btnCartTab(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    //MARK: -  API Functions
    
    func getFavApi(){
        
        var param: Parameters = [:]
        
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param = ["user_id": helper.mdictUserDetails["user_id"]!.stringValue]
            
            print(param)
            
        }
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "auth/get_wishlist", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* Fav dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
              
                    self.viewEmptyCart.isHidden = true
                    
                }else{
                    print("*** Fav auth/get_wishlist API error")
                    self.viewEmptyCart.isHidden = false
                    
                }
            }
        }
    }
}
//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension FavouritesVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marrFav.count
    }
    
    
    //MARK: -  Collection cellForRowAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Categories_Fav", for: indexPath) as? CategoriesCVC
            else { return UICollectionViewCell() }
  
        return cell
        
    }
    
    
    //MARK: -  Collection didSelectRowAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
      
        
    }
    
}
// MARK: CollectionView FlowLayout
extension FavouritesVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collvFav.frame.size.width - 25)/2, height: collvFav.frame.size.height/3)
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
