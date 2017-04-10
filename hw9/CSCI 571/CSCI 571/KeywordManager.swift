//
//  KeywordManager.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/10/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

final class KeywordManager {
    
    // Can't init is singleton
    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: KeywordManager = KeywordManager()
    
    //MARK: Local Variable
    
    var keywrod = String()
    
}
