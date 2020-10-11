//
//  HomeViewController-Ext.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 11/10/20.
//

import Foundation
import UIKit

class ImageBannerCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: BJAutoScrollingCollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var bannerArray = [[String: Any]]()
    func configureCell(imgData:[[String: Any]]) {
        bannerArray = imgData
        initCollectionView()
        scrollReload()
    }
    
    func initCollectionView() {
        self.collectionView.scrollInterval = 2 //Step 2
        self.collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionViewFlowLayout.minimumInteritemSpacing = 0
        self.collectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    func scrollReload() {
        self.collectionView.reloadData()
        self.collectionView.startScrolling() //Step 3
    }
}


extension ImageBannerCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageCollectionViewCell.self)", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imgDict = self.bannerArray[indexPath.row]
        let urlString  =  imgDict["image"] as? String
        cell.cellImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgDict = self.bannerArray[indexPath.row]
        let cat_id = imgDict["cat_id"] as? Int
        print("===>>> ",cat_id ?? 0)
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellImage.contentMode = .scaleToFill
    }
}

