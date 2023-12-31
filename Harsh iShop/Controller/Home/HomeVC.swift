//
//  HomeVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 10/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import SDWebImage
import SideMenu
import AMShimmer




class HomeVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, SideMenuNavigationControllerDelegate {
    
    //MARK: -  @IBOutlet
    
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var collvStories: UICollectionView!
    @IBOutlet weak var tblShimmer: UITableView!
    @IBOutlet weak var tblCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var collvSlider: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var viewTabBar: UIView!
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var lblWelcomeUser: UILabel!
    @IBOutlet weak var viewNavBarHome: UIView!
    
    //MARK: -  Properties
    var isSearch = false
    var searchTimer: Timer? = nil
    var marrSlider : Array<JSON> = []
    var marrCategory : Array<JSON> = []
    var marrSearchCategory : Array<JSON> = []
    var marrSearchItems : Array<JSON> = []
    var marrStories :Array<JSON> = []
    
    
    
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
        //*** TODO
        //** Issue of Tbl Shimmer
        
        setWelComeUser()
        let notificationName = Notification.Name("goToProductDetail")
        NotificationCenter.default.addObserver(self, selector:
            #selector(goToProductDetail), name: notificationName, object: nil)
        
        
        viewSearch.isHidden = true
        txtSearch.delegate = self
        self.tblShimmer.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            AMShimmer.start(for: self.tblShimmer)
            self.tblShimmer.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getProductsSliderApi()
            self.getStoriesApi()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let notificationName = Notification.Name("goToProductDetail")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        
    }
    
    
    //MARK: -  Buttons Actions
    
    @IBAction func btnNotification(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
            
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    @IBAction func btnSideMenu(_ sender: UIButton) {
        view.alpha = 0.2
        view?.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let menu = storyboard?.instantiateViewController(withIdentifier: "SideMenuNavigationController") as! SideMenuNavigationController
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            menu.leftSide = false
            
            
        }else{
            menu.leftSide = true
            
            
        }
        
        menu.enableSwipeToDismissGesture = true
        menu.statusBarEndAlpha = 0.0
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
        
        //            SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "SideMenuNavigationController") as? SideMenuNavigationController
        //            SideMenuManager.default.addPanGestureToPresent(toView: view)
        //            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .right)
    }
    
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        view.alpha = 1
    }
    @IBAction func btnViewAllCategory(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC")as! CategoriesVC
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    @IBAction func btnProfileTab(_ sender: UIButton) {
      
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC")as! ProfileVC
            
            
            self.navigationController?.pushViewController(nextVC, animated: false)
            
        
    }
    
    @IBAction func btnFavTab(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            
            self.navigationController?.pushViewController(nextVC, animated: false)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    @IBAction func btnCartTab(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            
            self.navigationController?.pushViewController(nextVC, animated: false)
            
            
        }else{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC") as! AuthHomeVC
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    @IBAction func btnDoneSearch(_ sender: UIButton) {
        startAnimation()
        getSearchItemsApi()
    }
    
    @IBAction func btnBackSearch(_ sender: UIButton) {
        viewSearch.isHidden = true
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        
        txtSearch.text = ""
        viewSearch.isHidden = false
        startAnimation()
        getSearchCategoryApi()
    }
    //MARK: -  Helper Functions
    func setWelComeUser(){
        lblWelcomeUser.text = "Welcome".localized
        print(helper.mdictUserDetails)
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            lblWelcomeUser.text = "Welcome".localized + " " + helper.mdictUserDetails["first_name"]!.stringValue
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDots.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
    }
    
    
    //MARK: - textField Delegate
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(
            timeInterval: 0.4,
            target: self,
            selector: #selector(self.getSearchItemsApi),
            userInfo: nil,
            repeats: false)
        
        return true
        
    }
    
    
    //MARK: - API Functions
    
    
    func getProductsSliderApi(){
        
        var param: Parameters = [:]
        
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
            
            
        }
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request( helper.baseUrl + "listing/category_wise_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            
            AMShimmer.stop(for: self.tblShimmer)
            self.tblShimmer.isHidden = true
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("* getProductsSliderApi dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrSlider = dictResponse["slider"].arrayValue
                    self.pageDots.numberOfPages = self.marrSlider.count
                    self.collvSlider.reloadData()
                    
                    self.marrCategory = dictResponse["data"].arrayValue
                    print(self.marrCategory)
                    self.tblCategory.reloadData()
                    
                    
                    let calculateCategoryForHeight = self.marrCategory.count
                    self.tblCategoryHeight.constant = CGFloat(230 * calculateCategoryForHeight)
                    
                    
                }else{
                    print("*** listing/category_wise_product API error")
                    self.stopAnimation()
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
                print("stories catogories dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrStories = dictResponse["data"].arrayValue
                    print(self.marrStories)
                    self.collvStories.reloadData()
                    
                }else{
                    print("* stories listing/category API error")
                }
            }
        }
    }
    
    
    @objc func goToProductDetail()  {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        print(helper.mdictProductdetail)
        nextVC.mdictProductdetail = helper.mdictProductdetail
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func btnViewAll(sender : UIButton)  {
        
        let nextVC  = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
        nextVC.strCategoryId = self.marrCategory[sender.tag]["category_id"].stringValue
        nextVC.strCategoryName = self.marrCategory[sender.tag]["category_name"].stringValue
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    func getSearchCategoryApi(){
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "listing/category", method: .get, parameters: nil, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("search Category dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrSearchCategory = dictResponse["data"].arrayValue
                    self.tblSearch.reloadData()
                    
                }else{
                    print("* search listing/category API error")
                }
            }
        }
    }
    
    
    @objc func getSearchItemsApi(){
        
        var param = ["search": txtSearch.text!]
        if  UserDefaults.standard.bool(forKey: "isLoggedIn") {
            
            param["user_id"] = helper.mdictUserDetails["user_id"]!.stringValue
        }
        
        print(param)
        
        let headers: HTTPHeaders = ["Accept-Language": UserDefaults.standard.value(forKey:"language_id") as! String]
        
        let request = AF.request(helper.baseUrl + "search/search_product", method: .post, parameters: param, headers: headers)
        request.responseJSON { response in
            
            self.stopAnimation()
            
            if let result = response.value {
                let dictResponse = JSON(result as! NSDictionary)
                print("dictResponse::\(dictResponse)")
                if dictResponse["success"].boolValue
                {
                    self.marrSearchItems = dictResponse["data"].arrayValue
                    self.isSearch = true
                    self.tblSearch.reloadData()
                    
                }else{
                    print("* search/search_product API error")
                }
            }
        }
        
        
    }
}

//MARK: -   UITableViewDelegate, UITableViewDataSource

extension HomeVC : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblCategory:
            return 230
        case tblShimmer:
            return 230
        case tblSearch:
            if isSearch{
                return 60
            }
            return 80
        default:
            print("*** switch case default heightForRowAt")
            return CGFloat()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblCategory:
            return marrCategory.count
        case tblShimmer:
            return 10
        case tblSearch:
            if isSearch{
                return marrSearchItems.count
            }
            return marrSearchCategory.count
            
            
            
        default:
            print("***switch case default numberOfRowsInSection")
            return Int()
        }
        
    }
    
    
    //MARK: -  Table cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView {
        case tblCategory:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            cell.marrProducts = self.marrCategory[indexPath.row]["product"].arrayValue
            cell.collvProducts.reloadData()
            cell.setDelegate()
            cell.lblCategory.text = self.marrCategory[indexPath.row]["category_name"].stringValue
            
            cell.btnViewAll.addTarget(self, action: #selector(btnViewAll(sender:)), for:.touchUpInside)
            cell.btnViewAll.tag = indexPath.row
            
            return cell
            
            
            
        case tblShimmer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeSearchTVC else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
            
            
            
            
        case tblSearch:
            print(isSearch)
            if isSearch{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as? HomeSearchTVC else { return UITableViewCell() }
                
                cell.lblSearchTitle.text  = self.marrSearchItems[indexPath.row]["product_name"].stringValue
                
                cell.imgSearch.sd_setImage(with: self.marrSearchItems[indexPath.row]["product_image"].url, placeholderImage: UIImage(named: ""))
                
                return cell
                
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? HomeSearchTVC else { return UITableViewCell() }
                
                cell.lblSearchTitle.text  = self.marrSearchCategory[indexPath.row]["category_name"].stringValue
                cell.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                cell.imgSearch.sd_setImage(with: self.marrSearchCategory[indexPath.row]["category_image"].url, placeholderImage: UIImage(named: ""))
                
                
                return cell
            }
            
            
            
            
            
            
            
        default:
            print("***switch case default cellForRowAt")
            return UITableViewCell()
        }
        
    }
    
    // MARK:  Table didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch{
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC")as! ProductDetailVC
            
            nextVC.mdictProductdetail = marrSearchItems[indexPath.row].dictionaryValue
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            nextVC.strCategoryId = self.marrSearchCategory[indexPath.row]["category_id"].stringValue
            nextVC.strCategoryName = self.marrSearchCategory[indexPath.row]["category_name"].stringValue
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            
        }
    }
    
    
    
}

//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collvStories{
            return marrStories.count
        }
        
        return marrSlider.count
    }
    
    // MARK: Collection cellForRowAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collvStories{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCVC", for: indexPath) as? StoriesCVC
                else { return UICollectionViewCell() }
            
            cell.viewBGSetup()
            
            cell.lblStories.text  = self.marrStories[indexPath.row]["category_name"].stringValue
            cell.imgStories.sd_setImage(with: self.marrStories[indexPath.row]["category_image"].url, placeholderImage: UIImage(named: ""))
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSliderCVC", for: indexPath) as? HomeSliderCVC
            else { return UICollectionViewCell() }
        
        
        cell.imgSlider.sd_setImage(with: self.marrSlider[indexPath.row].url, placeholderImage: UIImage(named: ""))
        
        return cell
        
    }
    
    //MARK: -  Collection didSelectRowAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collvStories{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            nextVC.strCategoryId = self.marrStories[indexPath.row]["category_id"].stringValue
            nextVC.strCategoryName = self.marrStories[indexPath.row]["category_name"].stringValue
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if collectionView == collvSlider {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
           
            self.navigationController?.pushViewController(nextVC, animated: true)
            
          
        }
        
        
    }
    
}
// MARK: CollectionView Flow Layout
extension HomeVC : UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collvStories{
            return CGSize(width: 95, height: 90)
        }
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
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
