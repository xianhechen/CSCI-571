//
//  DetailTabsViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/11/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

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
        })
        
        let  shareButton = UIAlertAction(title: "Share", style: .default, handler: { (action) -> Void in
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(addButton)
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
