//
//  UsersViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/10/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import EasyToast

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var PrevPage: UIButton!
    
    @IBOutlet weak var NextPage: UIButton!
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
        
        SwiftSpinner.show("Loading...")
        
        Alamofire.request("http://cs-server.usc.edu:16031/hw9/search.php?keyword=\(searchKeyword)&type=user").responseJSON { response in
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            // print(response.data)     // server data
            // print(response.result)   // result of response serialization
            
            if let value = response.result.value {
                let json = JSON(value)
                // print(json["user"]["paging"])
                // print(json["user"]["data"].arrayValue)
                self.PrevLink = json["user"]["paging"]["prev"].stringValue
                self.NextLink = json["user"]["paging"]["next"].stringValue
                //print(self.NextLink)
                for (key, subJson) in json["user"]["data"] {
                    // print(subJson["name"].stringValue)
                    self.nameArray.append(subJson["name"].stringValue)
                    self.picArray.append(subJson["picture"]["data"]["url"].stringValue)
                    self.idArray.append(subJson["id"].stringValue)
                }
            }
            
            if self.PrevLink.isEmpty {
                self.PrevPage.isEnabled =  false;
            } else {
                self.PrevPage.isEnabled = true;
            }
            if self.NextLink.isEmpty {
                self.NextPage.isEnabled =  false;
            } else {
                self.NextPage.isEnabled = true;
            }
            
            self.TableView.reloadData()
            SwiftSpinner.hide()
            //print (self.nameArray)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        //cell.imgIcon.image = iconImage[indexPath.row]
        cell.UserName.text = nameArray[indexPath.row]
        let imgURL = NSURL(string: picArray[indexPath.row])
        let data = NSData(contentsOf: (imgURL as? URL)!)
        cell.UserProfile.image = UIImage(data: data as! Data)
        //print (picArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:UserTableViewCell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        
        UserDetailsManager.sharedInstance.userid = idArray[indexPath.row]
        UserDetailsManager.sharedInstance.userName = nameArray[indexPath.row]
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func PrevPagePressed(_ sender: Any) {
        
        Alamofire.request(self.PrevLink).responseJSON { response in
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            // print(response.data)     // server data
            // print(response.result)   // result of response serialization
            
            if let value = response.result.value {
                self.nameArray.removeAll()
                self.picArray.removeAll()
                self.idArray.removeAll()
                let json = JSON(value)
                self.PrevLink = json["paging"]["previous"].stringValue
                self.NextLink = json["paging"]["next"].stringValue
                //print(self.NextLink)
                for (key, subJson) in json["data"] {
                    // print(subJson["name"].stringValue)
                    self.nameArray.append(subJson["name"].stringValue)
                    self.picArray.append(subJson["picture"]["data"]["url"].stringValue)
                    self.idArray.append(subJson["id"].stringValue)
                }
            }
            
            if self.PrevLink.isEmpty {
                self.PrevPage.isEnabled =  false;
            } else {
                self.PrevPage.isEnabled = true;
            }
            if self.NextLink.isEmpty {
                self.NextPage.isEnabled =  false;
            } else {
                self.NextPage.isEnabled = true;
            }
            self.TableView.reloadData()
            //SwiftSpinner.hide()
        }



        
    }
    
    @IBAction func NextPagePressed(_ sender: Any) {
        //searchKeyword = KeywordManager.sharedInstance.keywrod
        // print(searchKeyword)
        //SwiftSpinner.show("Loading...")
        
        // print(self.NextLink)
        
        Alamofire.request(self.NextLink).responseJSON { response in
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            // print(response.data)     // server data
            // print(response.result)   // result of response serialization
            
            if let value = response.result.value {
                self.nameArray.removeAll()
                self.picArray.removeAll()
                self.idArray.removeAll()
                let json = JSON(value)
                self.PrevLink = json["paging"]["previous"].stringValue
                self.NextLink = json["paging"]["next"].stringValue
                // print(json["paging"])
                for (key, subJson) in json["data"] {
                    // print(subJson["name"].stringValue)
                    self.nameArray.append(subJson["name"].stringValue)
                    self.picArray.append(subJson["picture"]["data"]["url"].stringValue)
                    self.idArray.append(subJson["id"].stringValue)
                }
            }
            if self.PrevLink.isEmpty {
                self.PrevPage.isEnabled =  false;
            } else {
                self.PrevPage.isEnabled = true;
            }
            if self.NextLink.isEmpty {
                self.NextPage.isEnabled =  false;
            } else {
                self.NextPage.isEnabled = true;
            }
            self.TableView.reloadData()
            
            
            //SwiftSpinner.hide()
        }

    }
    
    
    
    
    
}
