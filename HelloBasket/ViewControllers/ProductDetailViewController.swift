//
//  ProductDetailViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 01/11/20.
//

import UIKit

class DetailFirstCell: UITableViewCell {
    
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var sizelbl: UILabel!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var disLbl: UILabel!
}

class DetailDeliveryCell: UITableViewCell {
    
    @IBOutlet weak var nextSlotLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
}

class AboutProductCell: UITableViewCell {
    
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
}

class ProductPackCell: UITableViewCell {
    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var sizelbl: UILabel!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var cutPriceLbl: UILabel!
    @IBOutlet weak var btnSel: UIButton!
    @IBOutlet weak var bgView: UIView!

}


class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var cartBtn: UIButton!

    var product_id : String?
    var screen : String?
    var packSize : Int?
    var packCount : Int?
    
    var wholeDataDict : [String: Any]?
    var sizeData = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        cartBtn.addTarget(self, action: #selector(redirectToCart(sender:)), for: .touchUpInside)

        self.navTitle.text = "Product Details"

        self.fetchProductDetail()
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    @objc func redirectToCart(sender : UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let catgScreen = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            self.navigationController?.pushViewController(catgScreen, animated: true)
        }
    }
    
    func fetchProductDetail() {
        
        let param: [String: Any] = [:]
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.PRODUCT_DETAILS)/\(product_id ?? "1")", postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                print(res)
                self.packSize = 0
                self.packCount = 0
                self.wholeDataDict = res["data"] as? [String : Any]
                if let size = self.wholeDataDict?["sizeprice"] as? [[String: Any]] {
                    self.sizeData = size
                }
                
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
}

extension ProductDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return self.sizeData.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailFirstCell") as? DetailFirstCell
        
        if indexPath.section == 0 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailFirstCell") as? DetailFirstCell
            cell?.disLbl.backgroundColor = AppColor.themeColorSecond
            cell?.disLbl.textColor = .white

            cell?.companyLbl.text = self.wholeDataDict?["company"] as? String
            cell?.nameLbl.text = self.wholeDataDict?["name"] as? String
            
            if self.sizeData.count > 0 {
                
                cell?.sizelbl.text = self.sizeData[packSize ?? 0]["size"] as? String
                let pr = self.sizeData[packSize ?? 0]["price"] as? String
                cell?.mrpLbl.text = "\(StringConstant.RupeeSymbol)\(pr ?? "0")"
                let dis = self.sizeData[packSize ?? 0]["discount"] as? Int
                cell?.disLbl.text = "\(dis ?? 0) % OFF"

            }else{
                cell?.sizelbl.text = ""
                cell?.mrpLbl.text = ""
                cell?.disLbl.text = ""
                
            }
           

            return cell!
        }
        
        else if indexPath.section == 1 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "ImgCell") as? ImgCell
            if self.sizeData.count > 0 {
                if let imgArray = self.sizeData[packSize ?? 0]["images"] as? [[String: Any]] {
                    cell?.configureCell(imgArray: imgArray)
                }
            }
            return cell!
        }
        else if indexPath.section == 2 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "titleAbout") as? AboutProductCell
            cell?.aboutLbl.text = "Pack Sizes"
            cell?.aboutLbl.font = UIFont.systemFont(ofSize: 22)
            return cell!
        }
        
        else if indexPath.section == 3 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "ProductPackCell") as? ProductPackCell
            cell?.disLbl.backgroundColor = AppColor.themeColorSecond
            cell?.disLbl.textColor = .white
            
            cell?.bgView.layer.borderWidth = 1
            cell?.bgView.layer.borderColor = UIColor.gray.cgColor
            
            if self.sizeData.count > 0 {
                cell?.sizelbl.text = self.sizeData[packSize ?? 0]["size"] as? String
                let dis = self.sizeData[packSize ?? 0]["discount"] as? Int
                let pr = self.sizeData[packSize ?? 0]["price"] as? String
                let cut_price = self.sizeData[packSize ?? 0]["cut_price"] as? String
                cell?.mrpLbl.text = "MRP : \(StringConstant.RupeeSymbol)\(pr ?? "0")"
                cell?.disLbl.text = "\(dis ?? 0) % OFF"
                cell?.cutPriceLbl.text = "\(StringConstant.RupeeSymbol)\(cut_price ?? "0")"

            }else{
                cell?.sizelbl.text = ""
                cell?.mrpLbl.text = ""
                cell?.disLbl.text = ""
                cell?.cutPriceLbl.text = ""
            }
            return cell!
        }
        else if indexPath.section == 4 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailDeliveryCell") as? DetailDeliveryCell
            cell?.timeLbl.text = ""
            cell?.nextSlotLbl.text = "Your next available slot"
            if let slot = self.wholeDataDict?["timeslot"] as? [[String: Any]] {
                let fromTime = slot[0]["from_time"] as? String
                let toTime = slot[0]["to_time"] as? String
                cell?.timeLbl.text = "Expired : Today \(fromTime ?? "") - \(toTime ?? "")"
            }
            
            return cell!
        }
        else if indexPath.section == 5 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "titleAbout") as? AboutProductCell
            cell?.aboutLbl.text = "About this Product"
            return cell!
        }
        else if indexPath.section == 6 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "AboutProductCell") as? AboutProductCell
            cell?.aboutLbl.text = "About this Product"
            let desc = self.wholeDataDict?["description"] as? String
            cell?.descLbl.text = "\(desc?.capitalized ?? "")"
            return cell!
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 144
        }
        
        if indexPath.section == 1 {
            return 400
        }
        
        if indexPath.section == 3 {
        return 100
        }
        
        return UITableView.automaticDimension
    }
    
}



class ImgCell : UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imgData =  [[String : Any]]()
    func configureCell(imgArray : [[String : Any]]) {
        self.imgData = imgArray
        
        collectionView.showsHorizontalScrollIndicator = false
        if let imgurl = self.imgData[0]["image"] as? String {
            self.imgView.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        }
        
        collectionView.reloadData()
    }
}

extension ImgCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionCell", for: indexPath) as? ProductImageCollectionCell
        cell?.contentView.layer.borderWidth = 1
        cell?.contentView.layer.borderColor = UIColor.gray.cgColor
        let prodDict = self.imgData[indexPath.row]
        if let imgurl = prodDict["image"] as? String {
            cell?.imgView.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        }
        
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prodDict = self.imgData[indexPath.row]
        if let imgurl = prodDict["image"] as? String {
            self.imgView.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

class ProductImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
