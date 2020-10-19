//
//  ProductCell.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 18/10/20.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var offerlbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var priceCut: UILabel!
    @IBOutlet weak var priceSale: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dropDownBtnImg: UIImageView!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var AddFirstBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var addFirstTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        offerlbl.layer.cornerRadius = 15
        offerlbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
