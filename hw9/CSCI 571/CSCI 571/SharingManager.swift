//
//  SharingManager.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/12/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

final class SharingManager {
    
    // Can't init is singleton
    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: SharingManager = SharingManager()
    
    //MARK: Local Variable
    
    var FavoriteClicked = false
    
    var InUsers = false
    var InPages = false
    var InPlaces = false
    var InEvents = false
    var InGroups = false
    
    
    
    
    
    
    
    
    
    var FavUsers = [[String]]()
    var FavPages = [[String]]()
    var FavPlaces = [[String]]()
    var FavEvents = [[String]]()
    var FavGroups = [[String]]()
    
}
