//
//  GroupsViewController.swift
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

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var searchKeyword = String()
    
    var nameArray = [String]()
    var picArray = [String]()
    var idArray = [String]()
    
    var PrevLink = String()
    var NextLink = String()
    
    @IBOutlet weak var Table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        searchKeyword = KeywordManager.sharedInstance.keywrod
        // print(searchKeyword)
        
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            SwiftSpinner.show("Loading...")
            Alamofire.request("http://cs-server.usc.edu:16031/hw9/search.php?keyword=\(searchKeyword)&type=group").responseJSON { response in
                // print(response.request)  // original URL request
                // print(response.response) // HTTP URL response
                // print(response.data)     // server data
                // print(response.result)   // result of response serialization
                
                if let value = response.result.value {
                    let json = JSON(value)
                    // print(json["page"])
                    // print(json["user"]["paging"])
                    // print(json["user"]["data"].arrayValue)
                    self.PrevLink = json["group"]["paging"]["prev"].stringValue
                    self.NextLink = json["group"]["paging"]["next"].stringValue
                    //print(self.NextLink)
                    for (key, subJson) in json["group"]["data"] {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        //cell.imgIcon.image = iconImage[indexPath.row]
        cell.GroupName.text = nameArray[indexPath.row]
        let imgURL = NSURL(string: picArray[indexPath.row])
        let data = NSData(contentsOf: (imgURL as? URL)!)
        cell.GroupProfile.image = UIImage(data: data as! Data)
        //print (picArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:GroupTableViewCell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
        
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
