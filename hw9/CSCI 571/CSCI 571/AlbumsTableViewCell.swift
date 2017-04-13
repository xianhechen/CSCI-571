//
//  AlbumsTableViewCell.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/11/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var AlbumTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    class var expandedHeight: CGFloat {
        get {
            return 800
        }
    }
    
    class var defaultHeight: CGFloat {
        get {
            return 44
        }
    }
    
    var frameAdded = false
    
    func checkHeight() {
        Image1.isHidden = (frame.size.height < AlbumsTableViewCell.expandedHeight)
        Image2.isHidden = (frame.size.height < AlbumsTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if(!frameAdded){
            addObserver(self, forKeyPath: "frame", options: .new, context: nil )
            frameAdded = true
        }
        checkHeight()
    }
    
    func ignoreFrameChanges() {
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        ignoreFrameChanges()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
