//
//  ViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/7/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import EasyToast


class ViewController: UIViewController {

    @IBOutlet weak var Search: UINavigationItem!
    
    @IBOutlet weak var InputField: UITextField!

    @IBOutlet weak var Clear: UIButton!
    
    @IBAction func ClearPressed(_ sender: Any) {
        InputField.text = ""
        
    }
    
    @IBAction func SearchPressed(_ sender: Any) {
        
        if (InputField.text! == ""){
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: false)
        } else {
            
            KeywordManager.sharedInstance.keywrod = InputField.text!
            let revealViewController:SWRevealViewController = self.revealViewController()
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        
        
        
        
    }
    @IBOutlet weak var Open: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Open.target = revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

