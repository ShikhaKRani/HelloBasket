//
//  SidemenuBottomTableViewCell.swift
//  OnlineAssessmentApp
//
//  Created by Vibhash Kumar on 17/09/20.
//  Copyright © 2020 Vibhash Kumar. All rights reserved.
//

import UIKit

class SidemenuBottomTableViewCell: UITableViewCell {

     @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var versionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
        // Configure the view for the selected state
    }
    
}
