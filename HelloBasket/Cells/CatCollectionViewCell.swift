//
//  CatCollectionViewCell.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 24/10/20.
//

import Foundation
import UIKit


class CatCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var catList =  [[String : Any]]()
    func configureCell(catList : [[String : Any]]) {
        self.catList = catList
        collectionView.isScrollEnabled = true
        collectionView.reloadData()
    }
}

//CategoryCollectionCell
extension CatCollectionViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth/2.3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as? SubCategoryCollectionViewCell
        
        cell?.titleLbl.backgroundColor = .white
        cell?.contentView.backgroundColor = .clear
        cell?.backgroundColor = .clear
        cell?.titleLbl.layer.cornerRadius = 5
        cell?.titleLbl.layer.masksToBounds = true
        
        
        let prodDict = self.catList[indexPath.row]
        
        cell?.titleLbl.text = prodDict["name"] as? String
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prodDict = self.catList[indexPath.row]
        let cat_id = prodDict["id"] as? Int ?? 0
        NotificationCenter.default.post(name: Notification.Name("cat"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

