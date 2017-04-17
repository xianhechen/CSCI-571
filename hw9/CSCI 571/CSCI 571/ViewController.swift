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
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var Search: UINavigationItem!
    
    @IBOutlet weak var InputField: UITextField!

    @IBOutlet weak var Clear: UIButton!
    
    var locationManager: CLLocationManager!
    var lon = String()
    var lat = String()
    
    
    @IBAction func ClearPressed(_ sender: Any) {
        InputField.text = ""
    }
    
    @IBAction func SearchPressed(_ sender: Any) {
        SharingManager.sharedInstance.FavoriteClicked = false
        if (InputField.text! == ""){
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: false)
        } else {
            let keyword = InputField.text!
            KeywordManager.sharedInstance.keywrod = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let revealViewController:SWRevealViewController = self.revealViewController()
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        //print("Location: ")
        //print(self.lat)
        //print(self.lon)
        UserDetailsManager.sharedInstance.currentLat = self.lat
        UserDetailsManager.sharedInstance.currentLon = self.lon
    }
    @IBOutlet weak var Open: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        InputField.returnKeyType = UIReturnKeyType.done
        Open.target = revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        self.InputField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        InputField.resignFirstResponder()
        return (true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        self.lat = String(format: "%.6f", lastLocation.coordinate.latitude)
        self.lon = String(format: "%.6f", lastLocation.coordinate.longitude)
        //print(lat)
        //print(lon)
    }
}

