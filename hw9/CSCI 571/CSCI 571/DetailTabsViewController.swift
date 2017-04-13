//
//  DetailTabsViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/11/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import EasyToast

class DetailTabsViewController: UITabBarController {


    

    @IBOutlet weak var Options: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func OptionsPressed(_ sender: Any) {
    
        
        
        let alertController = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        
        
        
        
        let addButton = UIAlertAction(title: "Add to favorites", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.view.showToast("Added to favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            var temp_arr = [String]()
            temp_arr.append(UserDetailsManager.sharedInstance.userid)
            temp_arr.append(UserDetailsManager.sharedInstance.userName)
            temp_arr.append(UserDetailsManager.sharedInstance.userProfileURL)
            SharingManager.sharedInstance.FavUsers.append(temp_arr)
        })
        
        
        let removeButton = UIAlertAction(title: "Remove favorites", style: .default, handler: { (action) -> Void in
            self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            var temp_arr = [String]()
            temp_arr.append(UserDetailsManager.sharedInstance.userid)
            temp_arr.append(UserDetailsManager.sharedInstance.userName)
            temp_arr.append(UserDetailsManager.sharedInstance.userProfileURL)
            
            
            var findIndex = SharingManager.sharedInstance.FavUsers.index(where: {$0 == temp_arr})
            
            
            SharingManager.sharedInstance.FavUsers.remove(at: findIndex!)
        })
        
        
        let  shareButton = UIAlertAction(title: "Share", style: .default, handler: { (action) -> Void in
            print("Share button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        var find_array = [String]();
        
        find_array.append(UserDetailsManager.sharedInstance.userid)
        find_array.append(UserDetailsManager.sharedInstance.userName)
        find_array.append(UserDetailsManager.sharedInstance.userProfileURL)
        
        if let find = SharingManager.sharedInstance.FavUsers.index(where: {$0 == find_array}) {
            alertController.addAction(removeButton)
        } else {
            alertController.addAction(addButton)
        }

        
        
        alertController.addAction(shareButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
    }
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
