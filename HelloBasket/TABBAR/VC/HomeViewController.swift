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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return  1 //category
        }
        else if section == 2 {
            return 1 //recomendation
        }
        else if section == 3 {
            return 1 //sub category
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
            return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 50.0)
            
        }
        else if indexPath.section == 2 {
            //check size
            return CGSize(width: Constants.windowWidth, height: 300)
        }
        else if indexPath.section == 3 {
            
            var rowCount = 0
            let sections = self.homeDataDict?["sections"] as? [[String : Any]]
            if sections?.count ?? 0 > 0 {
                for var index in 0..<sections!.count {
                    let dict = sections?[index]
                    if dict?["type"] as! String == "subcategory" {
                        let subCatg = dict?["subcategory"] as? [[String : Any]]
                        let count1: Int = subCatg?.count ?? 0
                        rowCount = count1/2
                        if count1 % 2 != 0 {
                            rowCount = rowCount + 1
                        }
                        
                        return CGSize(width: Constants.windowWidth, height: CGFloat(rowCount * 140) + 50.0)
                    }
                }
            }
        }
        //---
        
        
        

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
            cell?.headerLbl.text = "Shop by Category"
            let categories = self.homeDataDict?["categories"] as? [[String : Any]]
            cell?.configureCell(screen: "cat", categories: categories ?? [[:]])
            collectionCell = cell
        }
        //RecomCollectionCell
        else if indexPath.section == 2 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(RecomCollectionCell.self)", for: indexPath) as? RecomCollectionCell
            let sections = self.homeDataDict?["sections"] as? [[String : Any]]
            
            if sections?.count ?? 0 > 0 {
                for var index in 0..<sections!.count {
                    let dict = sections?[index]
                    if dict?["type"] as! String == "product" {
                        cell?.headerLbl.text = dict?["name"] as? String
                        let productlist = dict?["products"] as? [[String : Any]]
                        cell?.configureCell(freshProducts: productlist ?? [[:]])
                    }
                }
            }
            collectionCell = cell
        }
        
        else if indexPath.section == 3 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionCell.self)", for: indexPath) as? CategoryCollectionCell
            cell?.headerLbl.text = "Fresh Product Added"
            
            let sections = self.homeDataDict?["sections"] as? [[String : Any]]
            if sections?.count ?? 0 > 0 {
                for var index in 0..<sections!.count {
                    let dict = sections?[index]
                    if dict?["type"] as! String == "subcategory" {
                        let subCatg = dict?["subcategory"] as? [[String : Any]]
                        cell?.configureCell(screen: "subcat", categories: subCatg ?? [[:]])
                    }
                }
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

//MARK:-

//RecomCollectionCell
