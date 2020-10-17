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
    var sectionBanners = [[String : Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationHomeIdentifier"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.productDetailNotification(notification:)), name: Notification.Name("NotificationDetailIdentifier"), object: nil)

        
        
        navigationView.backgroundColor = AppColor.themeColor
        self.view.backgroundColor = .white
        self.fetchHomeData()
    }
    
    
    //MARK:- Fetch user details after login
    func fetchHomeData() {
        Loader.showHud()
        let params = [:] as Dictionary<String, String>
        ServiceClient.sendRequestGET(apiUrl: APIEndPoints.shared.GET_HOMEDATA, postdatadictionary: params, isArray: false) { (response) in
            Loader.dismissHud()

            if let res = response as? [String : Any] {
                self.homeDataDict = res
                self.sectionBanners.removeAll()
                
                let sections = self.homeDataDict?["sections"] as? [[String : Any]]
                if sections?.count ?? 0 > 0 {
                    
                    for var index in 0..<sections!.count {
                        let dict = sections?[index]
                        if dict?["type"] as! String == "banner" {
                            let bannerdata = dict?["bannerdata"] as? [String : Any]
                            self.sectionBanners.append(bannerdata ?? [:])
                        }
                    }
                }
                
                
                print(self.homeDataDict ?? [:])
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func returnSectionData() -> [[String : Any]] {
        if let sections = self.homeDataDict?["sections"] as? [[String : Any]] {
            return sections

        }
        return [[:]]
    }
    
    func returnBannerCount() -> Int {

        if self.sectionBanners.count > 0 {
            return self.self.sectionBanners.count
        }
        return 0
    }

    func returnBannerData() -> [[String : Any]] {
        return self.sectionBanners
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {

        print(notification.userInfo ?? [:])

        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let catgScreen = storyBoard.instantiateViewController(withIdentifier: "ProductCategoryViewController") as? ProductCategoryViewController {
            catgScreen.prevDict = notification.userInfo as? [String : Any]
            catgScreen.screen = "home"
            self.navigationController?.pushViewController(catgScreen, animated: true)
        }
        
    }
    //for detail screen
    @objc func productDetailNotification(notification: Notification) {

        print(notification.userInfo ?? [:])
//for detail screen direct
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let catgScreen = storyBoard.instantiateViewController(withIdentifier: "ProductCategoryViewController") as? ProductCategoryViewController {
            catgScreen.prevDict = notification.userInfo as? [String : Any]
            catgScreen.screen = "home"
            self.navigationController?.pushViewController(catgScreen, animated: true)
        }
        
    }
    
}
//MARK:-
//MARK:- HomeViewController


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //for banner
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        if section == 1 {
            return  1 //category
        }
        if section == 2 {
            return self.returnSectionData().count
        }
        
        return 1
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
            
            if rowCount > 0 {
                return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 50.0)

            }
            return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 0)
                        
        }
        else if indexPath.section == 2 {
            //check size
            let sectionData = self.returnSectionData()
            let dict = sectionData[indexPath.row]
            
            if dict["type"] as? String == "product" {
                
                let productlist = dict["products"] as? [[String : Any]]
                if productlist?.count ?? 0 > 0 {
                    return CGSize(width: Constants.windowWidth, height: 330)
                }
                return CGSize(width: Constants.windowWidth, height: 0)
                
            }
            
            if dict["type"] as? String == "subcategory" {
                
                let catg = self.homeDataDict?["subcategory"] as? [[String : Any]]
                let count1: Int = catg?.count ?? 0
                
                var rowCount = count1/2
                if count1 % 2 != 0 {
                    rowCount = rowCount + 1
                }
                
                if rowCount > 0 {
                    return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 50.0)

                }
                return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 0)

            }
            
            if dict["type"] as? String == "banner" {
                
                if let bannerdata = dict["bannerdata"] as? [String : Any] {
                    return CGSize(width: Constants.windowWidth, height: 180)
                }
                
                return CGSize(width: Constants.windowWidth, height: 0)
            }
            
        }
        
        return CGSize(width: Constants.windowWidth, height: 0)
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
            cell?.configureCell(imgData: banners ?? [[:]], screen : "top")
            collectionCell = cell
        }
        if indexPath.section == 1 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionCell.self)", for: indexPath) as? CategoryCollectionCell
            cell?.headerLbl.text = "Shop by Category"
            let categories = self.homeDataDict?["categories"] as? [[String : Any]]
            cell?.configureCell(screen: "cat", categories: categories ?? [[:]])
            collectionCell = cell
        }
        
        
        let sectionData = self.returnSectionData()
        
        if indexPath.section == 2 {
            
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(ImageBannerCell.self)", for: indexPath) as? ImageBannerCell
            collectionCell = cell
            
            if sectionData.count > 0 {
                let dict = sectionData[indexPath.row]
                
                if dict["type"] as? String == "product" {
                    let cell = collectionView
                        .dequeueReusableCell(withReuseIdentifier: "\(RecomCollectionCell.self)", for: indexPath) as? RecomCollectionCell
                    cell?.headerLbl.text = dict["name"] as? String
                    let productlist = dict["products"] as? [[String : Any]]
                    cell?.configureCell(freshProducts: productlist ?? [[:]])
                    collectionCell = cell
                }
                
                if dict["type"] as? String == "subcategory" {
                    
                    let cell = collectionView
                        .dequeueReusableCell(withReuseIdentifier: "\(SubCategoryCollectionCell.self)", for: indexPath) as? SubCategoryCollectionCell
                    cell?.headerLbl.text = dict["name"] as? String
                    let subCatg = dict["subcategory"] as? [[String : Any]]
                    cell?.configureCellForSubCategory(screen: "subcat", categories: subCatg ?? [[:]])
                    collectionCell = cell
                }
                
                if dict["type"] as? String == "banner" {
                    
                    let cell = collectionView
                        .dequeueReusableCell(withReuseIdentifier: "\(ImageBannerCell.self)", for: indexPath) as? ImageBannerCell
                    if let bannerdata = dict["bannerdata"] as? [String : Any] {
                        var banners = [[String:Any]]()
                        banners.append(bannerdata)
                        cell?.configureCell(imgData: banners, screen: "" )
                    }
                    collectionCell = cell
                }
                
            }
            
        }
        
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let vc = DetailViewController.instantiate(appStoryboard: .home) as DetailViewController
        //        vc.product = dataArr[indexPath.row]
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
