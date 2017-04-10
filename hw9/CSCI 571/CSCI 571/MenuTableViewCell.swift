//
//  MenuTableViewCell.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/7/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblMenuName: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
