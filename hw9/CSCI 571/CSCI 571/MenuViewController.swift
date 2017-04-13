//
//  MenuViewController.swift
//  CSCI 571
//
//  Created by Xianhe Chen on 4/7/17.
//  Copyright © 2017 Xianhe Chen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var menuNameArr:Array = [String]()
    var iconImage:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArr = ["FB Search", "Home", "Favorites", "About Me"]
        iconImage = [UIImage(named:"fb")!, UIImage(named:"home")!, UIImage(named:"filled")!, UIImage(named:"filled")!]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.imgIcon.image = iconImage[indexPath.row]
        cell.lblMenuName.text = menuNameArr[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        if cell.lblMenuName.text! == "Home" {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
        }
        if cell.lblMenuName.text! == "About Me" {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
        }
        if cell.lblMenuName.text! == "Favorites" {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            SharingManager.sharedInstance.FavoriteClicked = true
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
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
