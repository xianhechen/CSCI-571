//
//  Details2ViewController.swift
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

class Details2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var PostContentArray = [[String]]()
    var TempArray = [String]()
    
    @IBOutlet weak var Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SwiftSpinner.show("Loading...")
        Alamofire.request("http://sample-env.rgv3prmeyk.us-west-2.elasticbeanstalk.com/search.php?userid=\(UserDetailsManager.sharedInstance.userid)&type=user").responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                for (key, subJson) in json["posts"]["data"] {
                    //print(subJson)
                    
                    //deal with story and message here
                    if subJson["message"] == nil {
                        self.TempArray.append(subJson["story"].stringValue)
                    } else {
                        self.TempArray.append(subJson["message"].stringValue)
                    }
                    
                    
                    self.TempArray.append(subJson["created_time"].stringValue)
                    self.PostContentArray.append(self.TempArray)
                    self.TempArray = []
                }
            }
            self.Table.estimatedRowHeight = 100
            self.Table.rowHeight = UITableViewAutomaticDimension
            self.Table.reloadData()
            SwiftSpinner.hide()
        }
        Table.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (AlbumNameArray.count)
        var numOfRows: Int = 0
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: Table.bounds.size.width, height: Table.bounds.size.height))
        noDataLabel.text          = "No data found."
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        Table.backgroundView  = noDataLabel
        Table.separatorStyle  = .none
        if PostContentArray.count > 0{
            numOfRows = PostContentArray.count
            noDataLabel.isHidden = true
        }else{
            noDataLabel.isHidden = false
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell") as! PostsTableViewCell
        let imgURL = NSURL(string: UserDetailsManager.sharedInstance.userProfileURL)
        let data = NSData(contentsOf: (imgURL as? URL)!)
        cell.PostProfile.image = UIImage(data: data as! Data)
        cell.PostContent.text = PostContentArray[indexPath.row][0]
        let dateFormatter = DateFormatter()
        let inputDate = PostContentArray[indexPath.row][1]
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" //iso 8601
        let outputDate = dateFormatter.date(from: inputDate)
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss" //iso 8601
        let resultString = dateFormatter.string(from: outputDate!)
        cell.PostTime.text = resultString
        return cell
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
