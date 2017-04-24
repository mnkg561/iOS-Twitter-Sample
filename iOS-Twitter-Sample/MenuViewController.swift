//
//  MenuViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/21/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import SwiftyGif


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var tweetsNavigationController: UIViewController!
    private var userNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    private var signOutController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "twitter_gif.gif")
        let imageview = UIImageView(gifImage: gif, manager: gifmanager)
        imageview.frame = CGRect(x: 0.0, y:250.0, width: self.view.frame.width, height: 400.0)
        view.addSubview(imageview)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        userNavigationController = storyboard.instantiateViewController(withIdentifier: "UserNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        signOutController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(userNavigationController)
        viewControllers.append(mentionsNavigationController)
        viewControllers.append(signOutController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let titles = [ "Home", "My Profile", "Mentions", "Sign out"]
        
        cell.menuTitleLabel.text = titles[indexPath.row]
        
     return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
              
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }

   
     

}
