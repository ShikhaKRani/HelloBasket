//
//  HotDealsViewController-Ext.swift
//  HelloBasket
//
//  Created by Subhash Kumar on 22/10/20.
//

import Foundation
import UIKit

extension HotDealsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 200)
        }
        
        return CGSize(width: Constants.windowWidth, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            CGSize(width: collectionView.frame.width, height: 0)
        } else if section == 1{
            
        } else if section == 2 {
            
        }
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var collectionCell: UICollectionViewCell?
        
        if indexPath.section == 0 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(ImageBannerCell.self)", for: indexPath) as? ImageBannerCell
            let banners = self.homeDataDict?["banner"] as? [[String : Any]]
            cell?.configureCell(imgData: banners ?? [[:]], screen : "top")
            collectionCell = cell
        }
        
        if indexPath.section == 1 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(CatCollectionViewCell.self)", for: indexPath) as? CatCollectionViewCell

            let categories = self.homeDataDict?["category"] as? [[String : Any]]
            if categories?.count ?? 0 > 0 {
                cell?.configureCell(catList: categories!)
            }
            collectionCell = cell
        }
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let vc = DetailViewController.instantiate(appStoryboard: .home) as DetailViewController
        //        vc.product = dataArr[indexPath.row]
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
