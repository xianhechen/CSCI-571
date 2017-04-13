//
//  PlacesViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/12/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import EasyToast


class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
   
    
    @IBOutlet weak var Table: UITableView!
    var searchKeyword = String()
    
    var nameArray = [String]()
    var picArray = [String]()
    var idArray = [String]()
    
    var PrevLink = String()
    var NextLink = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        searchKeyword = KeywordManager.sharedInstance.keywrod
        // print(searchKeyword)
        
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            SwiftSpinner.show("Loading...")
            Alamofire.request("http://cs-server.usc.edu:16031/hw9/search.php?keyword=\(searchKeyword)&type=place").responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // HTTP URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let value = response.result.value {
                    let json = JSON(value)
                    // print(json["page"])
                    // print(json["user"]["paging"])
                    // print(json["user"]["data"].arrayValue)
                    self.PrevLink = json["place"]["paging"]["prev"].stringValue
                    self.NextLink = json["place"]["paging"]["next"].stringValue
                    //print(self.NextLink)
                    for (key, subJson) in json["place"]["data"] {
                        // print(subJson["name"].stringValue)
                        self.nameArray.append(subJson["name"].stringValue)
                        self.picArray.append(subJson["picture"]["data"]["url"].stringValue)
                        self.idArray.append(subJson["id"].stringValue)
                    }
                }
                
                
                self.Table.reloadData()
                SwiftSpinner.hide()
                // print (self.nameArray)
            }
            
        } else {
            
        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (nameArray.count)
        return nameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        //cell.imgIcon.image = iconImage[indexPath.row]
        cell.PlaceName.text = nameArray[indexPath.row]
        let imgURL = NSURL(string: picArray[indexPath.row])
        let data = NSData(contentsOf: (imgURL as? URL)!)
        cell.PlaceProfile.image = UIImage(data: data as! Data)
        //print (picArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:PlaceTableViewCell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        
        UserDetailsManager.sharedInstance.userid = idArray[indexPath.row]
        UserDetailsManager.sharedInstance.userName = nameArray[indexPath.row]
        UserDetailsManager.sharedInstance.userProfileURL = picArray[indexPath.row]
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
