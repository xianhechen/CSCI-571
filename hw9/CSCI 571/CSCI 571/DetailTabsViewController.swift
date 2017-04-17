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
import FBSDKShareKit

class DetailTabsViewController: UITabBarController, FBSDKSharingDelegate {



    @IBOutlet weak var Options: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    var FavUsers = [[String]]()
    var FavPages = [[String]]()
    var FavPlaces = [[String]]()
    var FavEvents = [[String]]()
    var FavGroups = [[String]]()

    @IBAction func OptionsPressed(_ sender: Any) {
        
        if UserDefaults.standard.array(forKey: "favUsers") != nil  {
            FavUsers = UserDefaults.standard.array(forKey: "favUsers") as! [[String]]
        }
        if UserDefaults.standard.array(forKey: "favPages") != nil  {
            FavPages = UserDefaults.standard.array(forKey: "favPages") as! [[String]]
        }
        if UserDefaults.standard.array(forKey: "favEvents") != nil  {
            FavEvents = UserDefaults.standard.array(forKey: "favEvents") as! [[String]]
        }
        if UserDefaults.standard.array(forKey: "favPlaces") != nil  {
            FavPlaces = UserDefaults.standard.array(forKey: "favPlaces") as! [[String]]
        }
        if UserDefaults.standard.array(forKey: "favGroups") != nil  {
            FavGroups = UserDefaults.standard.array(forKey: "favGroups") as! [[String]]
        }
        
        
        let alertController = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let addButton = UIAlertAction(title: "Add to favorites", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.view.showToast("Added to favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            var temp_arr = [String]()
            temp_arr.append(UserDetailsManager.sharedInstance.userid)
            temp_arr.append(UserDetailsManager.sharedInstance.userName)
            temp_arr.append(UserDetailsManager.sharedInstance.userProfileURL)
            
            
            if SharingManager.sharedInstance.InEvents == true {
                self.FavEvents.append(temp_arr)
                UserDefaults.standard.set(self.FavEvents, forKey: "favEvents")
            }
            else if SharingManager.sharedInstance.InPages == true {
                self.FavPages.append(temp_arr)
                UserDefaults.standard.set(self.FavPages, forKey: "favPages")
            } else if SharingManager.sharedInstance.InUsers == true {
                self.FavUsers.append(temp_arr)
                UserDefaults.standard.set(self.FavUsers, forKey: "favUsers")
            } else if SharingManager.sharedInstance.InGroups == true {
                self.FavGroups.append(temp_arr)
                UserDefaults.standard.set(self.FavGroups, forKey: "favGroups")
            } else if SharingManager.sharedInstance.InPlaces == true {
                self.FavPlaces.append(temp_arr)
                UserDefaults.standard.set(self.FavPlaces, forKey: "favPlaces")
            }
        })
        
        
        let removeButton = UIAlertAction(title: "Remove favorites", style: .default, handler: { (action) -> Void in
            self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
            var temp_arr = [String]()
            temp_arr.append(UserDetailsManager.sharedInstance.userid)
            temp_arr.append(UserDetailsManager.sharedInstance.userName)
            temp_arr.append(UserDetailsManager.sharedInstance.userProfileURL)
            if SharingManager.sharedInstance.InEvents == true {
                //self.FavEvents = UserDefaults.standard.array(forKey: "favEvents") as! [[String]]
                if let find = self.FavEvents.index(where: {$0 == temp_arr}) {
                    self.FavEvents.remove(at: find)
                    UserDefaults.standard.set(self.FavEvents, forKey: "favEvents")
                }
                
            } else if SharingManager.sharedInstance.InPages == true {
                //self.FavPages = UserDefaults.standard.array(forKey: "FavPages") as! [[String]]
                
                if let find = self.FavPages.index(where: {$0 == temp_arr}) {
                    self.FavPages.remove(at: find)
                    UserDefaults.standard.set(self.FavPages, forKey: "favPages")
                    print("removed")
                }
                
            } else if SharingManager.sharedInstance.InUsers == true {
                //self.FavUsers = UserDefaults.standard.array(forKey: "favUsers") as! [[String]]

                if let find = self.FavUsers.index(where: {$0 == temp_arr}) {
                    self.FavUsers.remove(at: find)
                    UserDefaults.standard.set(self.FavUsers, forKey: "favUsers")
                }
                
            } else if SharingManager.sharedInstance.InGroups == true {
                //self.FavGroups = UserDefaults.standard.array(forKey: "FavGroups") as! [[String]]
                
                if let find = self.FavGroups.index(where: {$0 == temp_arr}) {
                    self.FavGroups.remove(at: find)
                    UserDefaults.standard.set(self.FavGroups, forKey: "favGroups")
                }
            } else if SharingManager.sharedInstance.InPlaces == true {
                //self.FavPlaces = UserDefaults.standard.array(forKey: "favPlaces") as! [[String]]
                
                if let find = self.FavPlaces.index(where: {$0 == temp_arr}) {
                    self.FavPlaces.remove(at: find)
                    UserDefaults.standard.set(self.FavPlaces, forKey: "favPlaces")
                }
            }
        })
        
        let  shareButton = UIAlertAction(title: "Share", style: .default, handler: { (action) -> Void in
            print("Share button tapped")
            //share to FB button goes here
            
            /*
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "https://scontent.xx.fbcdn.net") as! URL
            content.contentTitle = UserDetailsManager.sharedInstance.userName
            content.contentDescription = "FB Share for CSCI 571"
            content.imageURL = NSURL(string: UserDetailsManager.sharedInstance.userProfileURL) as! URL
            //FBSDKShareDialog.show(from: self, with: content, delegate: self)
            FBSDKShareDialog.show(from: self, with: content, delegate: self)
            */
            /*
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string:"http://scontent.xx.fbcdn.net") as! URL
            content.contentTitle = UserDetailsManager.sharedInstance.userName
            content.contentDescription = "FB Share for CSCI 571"
            content.imageURL = NSURL(string: UserDetailsManager.sharedInstance.userProfileURL) as! URL
            
            var dialog: FBSDKShareDialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            
            dialog.delegate = self
            //dialog.show()
            dialog.show()
            
            */
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            
            content.contentURL = NSURL(string:"https://www.facebook.com/"+UserDetailsManager.sharedInstance.userid) as! URL
            content.contentTitle = UserDetailsManager.sharedInstance.userName
            content.contentDescription = "FB Share for CSCI 571"
            content.imageURL = NSURL(string: UserDetailsManager.sharedInstance.userProfileURL) as! URL
            
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.delegate = self
            dialog.mode = FBSDKShareDialogMode.feedBrowser
            // if you don't set this before canShow call, canShow would always return YES
            if !dialog.canShow() {
                // fallback presentation when there is no FB app
                //dialog.mode = FBSDKShareDialogMode.feedBrowser
                dialog.mode = FBSDKShareDialogMode.automatic
            }
            dialog.show()
            
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        var find_array = [String]();
        find_array.append(UserDetailsManager.sharedInstance.userid)
        find_array.append(UserDetailsManager.sharedInstance.userName)
        find_array.append(UserDetailsManager.sharedInstance.userProfileURL)
        
        if SharingManager.sharedInstance.InEvents == true {
            if let find = FavEvents.index(where: {$0 == find_array}) {
                alertController.addAction(removeButton)
            } else {
                alertController.addAction(addButton)
            }
        } else if SharingManager.sharedInstance.InPages == true {
            if let find = FavPages.index(where: {$0 == find_array}) {
                alertController.addAction(removeButton)
            } else {
                alertController.addAction(addButton)
            }
        } else if SharingManager.sharedInstance.InUsers == true {
            if let find = FavUsers.index(where: {$0 == find_array}) {
                alertController.addAction(removeButton)
            } else {
                alertController.addAction(addButton)
            }
        } else if SharingManager.sharedInstance.InGroups == true {
            if let find = FavGroups.index(where: {$0 == find_array}) {
                alertController.addAction(removeButton)
            } else {
                alertController.addAction(addButton)
            }
            
        } else if SharingManager.sharedInstance.InPlaces == true {
            if let find = FavPlaces.index(where: {$0 == find_array}) {
                alertController.addAction(removeButton)
            } else {
                alertController.addAction(addButton)
            }
        }
        
        alertController.addAction(shareButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    

    
    /**
     Sent to the delegate when the share completes without error or cancellation.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter results: The results from the sharer.  This may be nil or empty.
     */
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("success")
        self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: false)
    }
    
    
    /**
     Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("Error")
        self.view.showToast("Error!", position: .bottom, popTime: 2, dismissOnTap: false)
    }
    
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: FBSDKSharing) {
        print("cancelled")
        self.view.showToast("Cancelled!", position: .bottom, popTime: 2, dismissOnTap: false)
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
