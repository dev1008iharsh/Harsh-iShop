//
//  BoardingVC.swift
//  Harsh iShop
//
//  Created by Harsh iOS Developer on 06/07/20.
//  Copyright © 2020 Harsh. All rights reserved.
//

import UIKit

class BoardingVC: UIViewController,UIScrollViewDelegate {
    
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pageDots: UIPageControl!
    @IBOutlet weak var collvBoarding: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnSkip(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AuthHomeVC")as! AuthHomeVC
        
        self.navigationController?.pushViewController(nextVC, animated:true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDots.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        if LanguageChanger.currentAppleLanguage() == "ar" {
            
            if pageDots.currentPage == 0{
                btnNext.isHidden = true
            }else{
                btnNext.isHidden = false
            }
            
        }else{
            if pageDots.currentPage == 2{
                btnNext.isHidden = true
            }else{
                btnNext.isHidden = false
            }
            
        }
        
        
    }
    @IBAction func btnNext(_ sender: UIButton) {
        
        
        let visibleItems: NSArray = self.collvBoarding.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        
        if nextItem.row < 3{
            pageDots.currentPage = nextItem.row
            self.collvBoarding.scrollToItem(at: nextItem, at: .left, animated: true)
            
        }
        
        
    }
    
}
extension BoardingVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BoardingCVC
            else { return UICollectionViewCell() }
        
        switch indexPath.row {
        case 0:
            
            cell.lblTitle.text = "Largest Product Variety".localized()
            cell.lblDescription.text = "Order Now with the largest selection of Products".localized()
            break
        case 1:
            
            
            cell.lblTitle.text = "Browse your Favourite Category".localized()
            cell.lblDescription.text = "Pick from thousands of products".localized()
            break
        case 2:
            
            cell.lblTitle.text = "Get your delivery".localized()
            cell.lblDescription.text = "Choose a time. Check out. Relax".localized()
            break
        default:
            break
        }
        
        
        return cell
        
    }
    
    
}
extension BoardingVC: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
