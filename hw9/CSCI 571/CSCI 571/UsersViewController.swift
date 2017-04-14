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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon        SharingManager.sharedInstance.InEvents = false
        SharingManager.sharedInstance.InPages = false
        SharingManager.sharedInstance.InGroups = false
        SharingManager.sharedInstance.InEvents = false
        SharingManager.sharedInstance.InUsers = true
        SharingManager.sharedInstance.InPlaces = false
        TableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        searchKeyword = KeywordManager.sharedInstance.keywrod
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            SwiftSpinner.show("Loading...")
            Alamofire.request("http://cs-server.usc.edu:16031/hw9/search.php?keyword=\(searchKeyword)&type=user").responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    self.PrevLink = json["user"]["paging"]["prev"].stringValue
                    self.NextLink = json["user"]["paging"]["next"].stringValue
                    for (key, subJson) in json["user"]["data"] {
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
            }
        } else {
            PrevPage.isEnabled = false;
            NextPage.isEnabled = false;
        }
        TableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            return nameArray.count
        } else {
            return SharingManager.sharedInstance.FavUsers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            cell.UserName.text = nameArray[indexPath.row]
            let imgURL = NSURL(string: picArray[indexPath.row])
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.UserProfile.image = UIImage(data: data as! Data)
            cell.star.tag = indexPath.row
            var find_array = [String]();
            find_array.append(idArray[indexPath.row])
            find_array.append(nameArray[indexPath.row])
            find_array.append(picArray[indexPath.row])
            if let find = SharingManager.sharedInstance.FavUsers.index(where: {$0 == find_array}) {
                cell.star.setImage(UIImage(named:"filled")!, for: UIControlState.normal)
            } else {
                cell.star.setImage(UIImage(named:"empty")!, for: UIControlState.normal)
            }
        } else {
            cell.UserName.text = SharingManager.sharedInstance.FavUsers[indexPath.row][1]
            let imgURL = NSURL(string: SharingManager.sharedInstance.FavUsers[indexPath.row][2])
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.UserProfile.image = UIImage(data: data as! Data)
            cell.star.setImage(UIImage(named:"filled")!, for: UIControlState.normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UserTableViewCell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            UserDetailsManager.sharedInstance.userid = idArray[indexPath.row]
            UserDetailsManager.sharedInstance.userName = nameArray[indexPath.row]
            UserDetailsManager.sharedInstance.userProfileURL = picArray[indexPath.row]
        } else {
            UserDetailsManager.sharedInstance.userid = SharingManager.sharedInstance.FavUsers[indexPath.row][0]
            UserDetailsManager.sharedInstance.userName = SharingManager.sharedInstance.FavUsers[indexPath.row][1]
            UserDetailsManager.sharedInstance.userProfileURL = SharingManager.sharedInstance.FavUsers[indexPath.row][2]
        }
    }

    @IBAction func PrevPagePressed(_ sender: Any) {
        Alamofire.request(self.PrevLink).responseJSON { response in
            if let value = response.result.value {
                self.nameArray.removeAll()
                self.picArray.removeAll()
                self.idArray.removeAll()
                let json = JSON(value)
                self.PrevLink = json["paging"]["previous"].stringValue
                self.NextLink = json["paging"]["next"].stringValue
                for (key, subJson) in json["data"] {
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
        }
    }
    
    @IBAction func NextPagePressed(_ sender: Any) {
        Alamofire.request(self.NextLink).responseJSON { response in
            if let value = response.result.value {
                self.nameArray.removeAll()
                self.picArray.removeAll()
                self.idArray.removeAll()
                let json = JSON(value)
                self.PrevLink = json["paging"]["previous"].stringValue
                self.NextLink = json["paging"]["next"].stringValue
                for (key, subJson) in json["data"] {
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
        }
    }
}
