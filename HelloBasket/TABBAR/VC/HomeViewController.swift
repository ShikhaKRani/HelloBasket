//
//  HomeViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import SideMenu
import SDWebImage

//MARK:- Side Menu Set up
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
                SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
}

class HomeViewController: UIViewController{
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var homeDataDict : [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor
        self.view.backgroundColor = .white
        self.fetchHomeData()
    }
    
    
    //MARK:- Fetch user details after login
    func fetchHomeData() {
        Loader.showHud()
        let params = [:] as Dictionary<String, String>
        ServiceClient.sendRequest(apiUrl: APIEndPoints.shared.GET_HOMEDATA, postdatadictionary: params, method: "GET", isArray: false) { (response) in
            Loader.dismissHud()

            if let res = response as? [String : Any] {
                self.homeDataDict = res
                print(self.homeDataDict ?? [:])
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
//MARK:-
//MARK:- HomeViewController


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return  1 //category
        }
        else if section == 2 {
            //sections
            //            return dataArr?.others?.count ?? 0
            return 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 200)
        }
        else if indexPath.section == 1 {
            
            let catg = self.homeDataDict?["categories"] as? [[String : Any]]
            let count1: Int = catg?.count ?? 0
            
            var rowCount = count1/3
            if count1 % 3 != 0 {
                rowCount = rowCount + 1
            }
            return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 40.0)
            
        }
//        else if indexPath.section == 2 {
//
//        }
        
        
        //        else if indexPath.section == 2 {
        //
        //            let data = dataArr?.others?[indexPath.row]
        //            let count1: Int = data?.event?.count ?? 0
        //            let count2: Int = data?.banners?.count ?? 0
        //
        //            var rowCount = count1/3
        //
        //            if count1 % 3 != 0 {
        //                rowCount = rowCount + 1
        //            }
        //            let rowCount1 = count2 > 0 ? 1: 0
        //            return CGSize(width: self.view.frame.width, height: CGFloat(rowCount * 140) + CGFloat(rowCount1 * 181) + 40.0)
        //        }
        
        
        
        return CGSize(width: self.view.frame.width, height: 150)
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
            let banners = self.homeDataDict?["banners"] as? [[String : Any]]
            cell?.configureCell(imgData: banners ?? [[:]])
            collectionCell = cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionCell.self)", for: indexPath) as? CategoryCollectionCell
            let categories = self.homeDataDict?["categories"] as? [[String : Any]]
            cell?.configureCell(categories: categories ?? [[:]])
            collectionCell = cell
        }
        
        
        
        //        else if indexPath.section == 2 {
        //            let cell = collectionView
        //                .dequeueReusableCell(withReuseIdentifier: "\(EventOtherCell.self)", for: indexPath) as? EventOtherCell
        //            cell?.configureCell(homeOthers: dataArr?.others?[indexPath.row])
        //            cell?.viewButton.tag = indexPath.row
        //            cell?.viewButton.addTarget(self, action: #selector(viewEvent(sender:)), for: .touchUpInside)
        //            collectionCell = cell
        //            cell?.delegate = self
        //        }
        
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let vc = DetailViewController.instantiate(appStoryboard: .home) as DetailViewController
        //        vc.product = dataArr[indexPath.row]
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:-

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!

    var categories =  [[String : Any]]()
    
    func configureCell(categories : [[String : Any]]) {
        viewButton.layer.cornerRadius = 10
        viewButton.layer.masksToBounds = true
        self.categories = categories
        headerLbl.text = "Shop by Category"
        collectionView.reloadData()
    }
    
}

//CategoryCollectionCell
extension CategoryCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth/3.3, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "CategoryInnerCell", for: indexPath) as? CategoryInnerCell
        let catDict = self.categories[indexPath.row]
        let urlString  =  catDict["image"] as? String
        cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)

        cell?.lblName.text = catDict["name"] as? String//name
        cell?.lblDesc.isHidden = true
        cell?.rateImg.isHidden = true
        cell?.lblName.font = UIFont.systemFont(ofSize: 15)

        cell?.rateView.isHidden = true
        cell?.contentView.layer.borderWidth = 0.5
        cell?.contentView.layer.borderColor = UIColor.lightGray.cgColor

        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        cellPressAction(eventID: self.nearPlaceModel[indexPath.row].id ?? 0)
    }
}


class CategoryInnerCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateImg: UIImageView!

}
