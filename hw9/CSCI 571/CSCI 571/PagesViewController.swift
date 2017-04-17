//
//  PagesViewController.swift
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


class PagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Table: UITableView!
    
    @IBOutlet weak var PrevPage: UIButton!
    
    @IBOutlet weak var NextPage: UIButton!
    
    
    var searchKeyword = String()
    var nameArray = [String]()
    var picArray = [String]()
    var idArray = [String]()
    var PrevLink = String()
    var NextLink = String()
    
    var FavPages = [[String]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if UserDefaults.standard.array(forKey: "favPages") != nil {
            FavPages = UserDefaults.standard.array(forKey: "favPages") as! [[String]]
        }
        SharingManager.sharedInstance.InEvents = false
        SharingManager.sharedInstance.InPages = true
        SharingManager.sharedInstance.InGroups = false
        SharingManager.sharedInstance.InUsers = false
        SharingManager.sharedInstance.InPlaces = false
        if(SharingManager.sharedInstance.FavoriteClicked == false) {
            let index = Table.indexPathForSelectedRow
            if (index != nil){
                self.Table.reloadRows(at: [index!], with: UITableViewRowAnimation.automatic)
            }
        } else {
            Table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchKeyword = KeywordManager.sharedInstance.keywrod
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            SwiftSpinner.show("Loading...")
            Alamofire.request("http://sample-env.rgv3prmeyk.us-west-2.elasticbeanstalk.com/search.php?keyword=\(searchKeyword)&type=page").responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    self.PrevLink = json["page"]["paging"]["prev"].stringValue
                    self.NextLink = json["page"]["paging"]["next"].stringValue
                    for (key, subJson) in json["page"]["data"] {
                        self.nameArray.append(subJson["name"].stringValue)
                        self.picArray.append(subJson["picture"]["data"]["url"].stringValue)
                        self.idArray.append(subJson["id"].stringValue)
                    }
                }
                if self.PrevLink.isEmpty {
                    self.PrevPage.isEnabled =  false
                } else {
                    self.PrevPage.isEnabled = true
                }
                if self.NextLink.isEmpty {
                    self.NextPage.isEnabled =  false
                } else {
                    self.NextPage.isEnabled = true
                }
                self.Table.reloadData()
                SwiftSpinner.hide()
            }
        }  else  {
            PrevPage.isEnabled = false;
            NextPage.isEnabled = false;
        }
        Table.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            return nameArray.count
        } else {
            return FavPages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageTableViewCell") as! PageTableViewCell
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            cell.PageName.text = nameArray[indexPath.row]
            let imgURL = NSURL(string: picArray[indexPath.row])
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.PageProfile.image = UIImage(data: data as! Data)
            var find_array = [String]();
            find_array.append(idArray[indexPath.row])
            find_array.append(nameArray[indexPath.row])
            find_array.append(picArray[indexPath.row])
            if let find = FavPages.index(where: {$0 == find_array}) {
                cell.Star.setImage(UIImage(named:"filled")!, for: UIControlState.normal)
            } else {
                cell.Star.setImage(UIImage(named:"empty")!, for: UIControlState.normal)
            }
        } else {
            cell.PageName.text = FavPages[indexPath.row][1]
            let imgURL = NSURL(string: FavPages[indexPath.row][2])
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.PageProfile.image = UIImage(data: data as! Data)
            cell.Star.setImage(UIImage(named:"filled")!, for: UIControlState.normal)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:PageTableViewCell = tableView.cellForRow(at: indexPath) as! PageTableViewCell
        if (SharingManager.sharedInstance.FavoriteClicked == false) {
            UserDetailsManager.sharedInstance.userid = idArray[indexPath.row]
            UserDetailsManager.sharedInstance.userName = nameArray[indexPath.row]
            UserDetailsManager.sharedInstance.userProfileURL = picArray[indexPath.row]
        } else {
            UserDetailsManager.sharedInstance.userid = FavPages[indexPath.row][0]
            UserDetailsManager.sharedInstance.userName = FavPages[indexPath.row][1]
            UserDetailsManager.sharedInstance.userProfileURL = FavPages[indexPath.row][2]
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
                self.PrevPage.isEnabled =  false
            } else {
                self.PrevPage.isEnabled = true
            }
            if self.NextLink.isEmpty {
                self.NextPage.isEnabled =  false
            } else {
                self.NextPage.isEnabled = true
            }
            self.Table.reloadData()
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
                self.PrevPage.isEnabled =  false
            } else {
                self.PrevPage.isEnabled = true
            }
            if self.NextLink.isEmpty {
                self.NextPage.isEnabled =  false
            } else {
                self.NextPage.isEnabled = true
            }
            self.Table.reloadData()
        }
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
