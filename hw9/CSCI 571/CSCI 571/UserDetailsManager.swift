//
//  UserDetailsManager.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/10/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

final class UserDetailsManager {
    
    // Can't init is singleton
    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: UserDetailsManager = UserDetailsManager()
    
    //MARK: Local Variable
    
    var userid = String()
    var userName = String()
    var userProfileURL = String()
    
    
    var currentLat = String()
    var currentLon = String()
}
