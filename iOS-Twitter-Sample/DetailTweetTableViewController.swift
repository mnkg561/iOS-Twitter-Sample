//
//  DetailTweetTableViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/15/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking

class DetailTweetTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetedByLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    

    @IBOutlet weak var replybutton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeCount: UILabel!
    var tweet: Tweet!

    var favoritedFlag: Bool?
    var retweetedFlag: Bool?
    var retweetsCount: Int?
    var likesCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tweetedByLabel.text = self.tweet.name
        userNameLabel.text = self.tweet.name
        tweetTextLabel.text = self.tweet.text
        profileImage.setImageWith(self.tweet.profileURL!)
        userNameLabel.text = self.tweet.screenName
        dateLabel.text = self.tweet.date
        self.retweetsCount = self.tweet.retweetCount
        retweetCount.text = String(self.tweet.retweetCount)
        likeCount.text = String(self.tweet.favoritesCount)
        
        
        if self.tweet.retweetedFlag == true {
          retweetButton.setImage(UIImage(named: "Retweet Filled-50"), for: .normal)
            self.retweetedFlag = true
        }else {
            self.retweetedFlag = false
        }
        
        if self.tweet.favoritedFlag == true {
            likeButton.setImage(UIImage(named: "Like Filled-50"), for: .normal)
            self.favoritedFlag = true
        } else {
            self.favoritedFlag = false
        }
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Reply Arrow-50"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.replyTweet(_:)), for: .touchDown)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButton(item1, animated: true)

       tableView.tableFooterView = UIView()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
    
    }
    
    
    
    func replyTweet(_ button: UIButton){
               
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let ReplyTableViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyTableViewController") as! ReplyTableViewController
        self.present(ReplyTableViewController, animated:true, completion:nil)
        ReplyTableViewController.userNameLabel.text = self.tweet.screenName
        ReplyTableViewController.tweetId = self.tweet.tweetId

    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func onClickReplyButton(_ sender: Any) {
       
        
        replyTweet(replybutton)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

  
    @IBAction func onClickReTweetButton(_ sender: Any) {
        if self.retweetedFlag == true {
           TwitterOAuth1Client.sharedInstance?.retweet(twitterId: self.tweet.tweetId!, apiOperationString: "unretweet")
            retweetButton.setImage(UIImage(named: "Retweet-50"), for: .normal)
            if self.tweet.retweetedFlag == true {
               retweetCount.text = String(self.tweet.retweetCount - 1)
            } else {
                retweetCount.text = String(self.tweet.retweetCount)
            }
            
            self.retweetedFlag = false
            
        } else {
            TwitterOAuth1Client.sharedInstance?.retweet(twitterId: self.tweet.tweetId!, apiOperationString: "retweet")
            retweetButton.setImage(UIImage(named: "Retweet Filled-50"), for: .normal)
            if self.tweet.retweetedFlag == false {
                retweetCount.text = String(self.tweet.retweetCount + 1)
            } else {
                retweetCount.text = String(self.tweet.retweetCount)
            }
            self.retweetedFlag = true
            
        }
        
    }
    
    @IBAction func onClickLikeButton(_ sender: Any) {
        if self.favoritedFlag == true {
            TwitterOAuth1Client.sharedInstance?.makeItFavorite(twitterId: self.tweet.tweetId!, apiOperationString: "destroy")
            likeButton.setImage(UIImage(named: "Like-50"), for: .normal)
            if self.tweet.favoritedFlag == true {
            likeCount.text  = String(self.tweet.favoritesCount - 1)
            } else {
                likeCount.text  = String(self.tweet.favoritesCount)
            }
            self.favoritedFlag = false
        } else {
            TwitterOAuth1Client.sharedInstance?.makeItFavorite(twitterId: self.tweet.tweetId!, apiOperationString: "create")
            likeButton.setImage(UIImage(named: "Like Filled-50"), for: .normal)
            if self.tweet.favoritedFlag == false {
                likeCount.text  = String(self.tweet.favoritesCount + 1)
            } else {
                likeCount.text  = String(self.tweet.favoritesCount)
            }
            self.favoritedFlag = true
        }
        
    }
    
}
