//
//  DetailsViewController.swift
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

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var AlbumNameArray = [String]()
    var AlbumPicturesArray = [[String]]()
    var AlbumHiResPicArray = [[NSData]]()
    var TempHiResPicArray = [NSData]()
    var TempArray = [String]()
    var SelectedIndexPath : IndexPath?

    @IBOutlet weak var Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SwiftSpinner.show("Loading...")
        Alamofire.request("http://sample-env.rgv3prmeyk.us-west-2.elasticbeanstalk.com/search.php?userid=\(UserDetailsManager.sharedInstance.userid)&type=user").responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                for (_, subJson) in json["albums"]["data"] {
                    self.AlbumNameArray.append(subJson["name"].stringValue)
                    for (_, pictures) in subJson["photos"]["data"] {
                        self.TempArray.append(pictures["id"].stringValue)
                    }
                    self.AlbumPicturesArray.append(self.TempArray)
                    self.TempArray = []
                }
            }
            self.Table.reloadData()
            var picID = String()
            var picture = NSData()
            for album in self.AlbumPicturesArray {
                for picID in album {
                    let imgURL = NSURL(string: "https://graph.facebook.com/v2.8/\(picID)/picture?access_token=EAACxu1kZBnhMBADkNL93SOToHuupSjtmdFZBOWtrghZAWu6P2lGZCiaOfQnAQVOyQQnQfHpBnz9ei4tEOEs7652Rl4xR0D4MB0oimyC8sjivlEZAmoXVTPOSBBnh8XI6ZAdjXjSwr6UeixeIBs10uUxAMZCJ218nCUZD")
                    let picture = NSData(contentsOf: (imgURL as? URL)!)
                    self.TempHiResPicArray.append(picture!)
                }
                self.AlbumHiResPicArray.append(self.TempHiResPicArray)
                self.TempHiResPicArray = []
            }
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
        var numOfRows: Int = 0
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: Table.bounds.size.width, height: Table.bounds.size.height))
        noDataLabel.text          = "No data found."
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        Table.backgroundView  = noDataLabel
        Table.separatorStyle  = .none
        if AlbumNameArray.count > 0{
            numOfRows = AlbumNameArray.count
            noDataLabel.isHidden = true
        }else{
            noDataLabel.isHidden = false
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsTableViewCell") as! AlbumsTableViewCell
        cell.AlbumTitle.text = AlbumNameArray[indexPath.row]//AlbumNameArray[indexPath.row]
        if (AlbumPicturesArray[indexPath.row].count == 2) {
            let data1 = AlbumHiResPicArray[indexPath.row][0]
            let data2 = AlbumHiResPicArray[indexPath.row][1]
            cell.Image1.image = UIImage(data: data1 as! Data)
            cell.Image2.image = UIImage(data: data2 as! Data)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = SelectedIndexPath
        if indexPath == SelectedIndexPath {
            SelectedIndexPath = nil
        } else {
            SelectedIndexPath = indexPath
        }
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = SelectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == SelectedIndexPath {
            return AlbumsTableViewCell.expandedHeight
        } else {
            return AlbumsTableViewCell.defaultHeight
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
