//
//  GroupTableViewCell.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/12/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var GroupName: UILabel!
    @IBOutlet weak var GroupProfile: UIImageView!
    
    @IBOutlet weak var Star: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
