//
//  SearchResultsViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/9/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITabBarController {

    @IBOutlet weak var Search: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            Search.title = "Search Results"
        } else {
            Search.title = "Favorites"
        }
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var Open: UIBarButtonItem!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
