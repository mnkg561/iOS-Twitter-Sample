//
//  UserProfileViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/21/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var screenTest: String!
    
    var requestedScreenName: String!
    
    let userNameSymbol: String = "@"
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        if requestedScreenName == nil {
            requestedScreenName = User.currentUser?.screenName
        }
        loadUserProfileItems(requestedScreenName: requestedScreenName)
        loadUserTweets(requestedScreenName: requestedScreenName )
        
     
        // Do any additional setup after loading the view.
    }
    
    
    func loadUserProfileItems(requestedScreenName: String){
        TwitterOAuth1Client.sharedInstance?.getPresentUserProfile(screenName: requestedScreenName, success: { (dictionary: NSDictionary) in
            print("i already got the call")
            
            self.nameLabel.text = dictionary["name"] as? String
            let screenName = dictionary["screen_name"] as? String
            self.screenNameLabel.text = self.userNameSymbol + screenName!
            
            let location = dictionary["location"] as? String
            self.locationLabel.text = location
            
            if location != nil {
                self.locationImageView.image = UIImage(named: "Marker Filled-50")
            }
           
            self.followersCountLabel.text = String((dictionary["followers_count"] as? Int) ?? 0)
            self.followingCountLabel.text = String((dictionary["friends_count"] as? Int) ?? 0)
            
            let profileUrlString = dictionary["profile_image_url_https"] as? String
            if let profileUrlString = profileUrlString {
                let profileURL = URL(string: profileUrlString)
                self.profileImageView.setImageWith(profileURL!)
            }
            
            let headerUrlString = dictionary["profile_banner_url"] as? String
            if let headerUrlString = headerUrlString {
                let headerURL = URL(string: headerUrlString)
                self.headerImageView.setImageWith(headerURL!)
            }
        
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapBackImage(tapGesture:)))
            self.backImage.isUserInteractionEnabled = true
           self.backImage.addGestureRecognizer(tapGesture)
            
        }, failure: { (error: Error) in
            print("trouble... fix it")
        })

    }
    
    func loadUserTweets(requestedScreenName: String){
        TwitterOAuth1Client.sharedInstance?.getUserTimeLine(screenName: requestedScreenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("some trouble.. lets fix it")
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell", for: indexPath) as! ProfileTweetCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    
    func onTapBackImage(tapGesture: UITapGestureRecognizer){
        print("tapped")
     
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        let hamburgerViewController = storyBoard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
        
        menuViewController.hamburgerViewController = hamburgerViewController
        
        hamburgerViewController.menuViewController = menuViewController

        self.present(hamburgerViewController, animated:true, completion:nil)
        
        
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
