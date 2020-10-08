//
//  sideMenuTableViewCell.swift
//  EDXPERT
//
//  Created by Vibhash Kumar on 16/07/19.
//  Copyright © 2019 Vibhash Kumar. All rights reserved.
//

import UIKit

class sideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuTitleLbl: UILabel!
    @IBOutlet weak var menuImgIcon: UIImageView!
    @IBOutlet weak var listUnderlineView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        selectionStyle = .none
        // Configure the view for the selected state
    }

}
