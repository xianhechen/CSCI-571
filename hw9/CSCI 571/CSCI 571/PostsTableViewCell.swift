//
//  PostsTableViewCell.swift
//  
//
//  Created by Xianhe Chen on 4/11/17.
//
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var PostProfile: UIImageView!
    @IBOutlet weak var PostContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
