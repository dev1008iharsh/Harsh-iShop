//
//  CategoriesVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 13/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoriesVC : UIViewController {

    //MARK: -  @IBOutlet
    @IBOutlet weak var collvCategories: UICollectionView!
    
    
    //MARK: -  Properties

    var marrCategories : Array<JSON> = []
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
        getCategoriesApi()
    }
    
    @IBAction func btnCart(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                       
            self.navigationController?.pushViewController(nextVC, animated: true)
      
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
                     
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    //MARK: -  API Functions

    func getCategoriesApi(){
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "listing/category", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            
      
                print("* All catogories dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrCategories = dictResponse["data"].arrayValue
                    self.collvCategories.reloadData()
                    
                }else{
                    print("*** All catogories listing/category API error")
                }
            }
        }
    }
    
    //MARK: - Helper Functions

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension CategoriesVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marrCategories.count
    }
    
    
    //MARK: -  Collection cellForRowAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_Categories_Fav", for: indexPath) as? CategoriesCVC
            else { return UICollectionViewCell() }
    placeholderImage: UIImage(named: ""))
        
        return cell
        
    }
    
    
    //MARK: -  Collection didSelectRowAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
     
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
}
// MARK: CollectionView FlowLayout
extension CategoriesVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collvCategories.frame.size.width - 25)/2, height: collvCategories.frame.size.height/3)
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
