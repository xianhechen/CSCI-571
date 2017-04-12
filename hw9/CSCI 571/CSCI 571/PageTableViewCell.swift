//
//  PageTableViewCell.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/11/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class PageTableViewCell: UITableViewCell {

    @IBOutlet weak var PageName: UILabel!
    
    @IBOutlet weak var PageProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
