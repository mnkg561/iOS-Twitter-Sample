//
//  TwitterHomeLineControllerViewController.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/12/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class TwitterHomeLineController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Twitter Filled-50"))
        
        loadHomeTimeLine();
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for:UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Create_New_Filled-50"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.sendTweets(_:)), for: .touchDown)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "Gender Neutral User Filled-50"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //btn2.addTarget(self, action: #selector(Class.MethodName), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        //self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        self.navigationItem.setRightBarButton(item1, animated: true)
        self.navigationItem.setLeftBarButton(item2, animated: true)
        
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendTweets(_ button: UIButton){
        //TwitterOAuth1Client.sharedInstance?.sendNewTweet()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let NewTweetViewController = storyBoard.instantiateViewController(withIdentifier: "NewTweetViewController") as! NewTweetViewController
        self.present(NewTweetViewController, animated:true, completion:nil)
    }
    
    func loadHomeTimeLine(){
        
        TwitterOAuth1Client.sharedInstance?.testHomeLine(success3: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
                print(tweet.favoritesCount)
            }
            print("count = \(self.tweets.count) ")
            self.tableView.reloadData()
        }, failure3: { (error: Error) in
            print(error.localizedDescription)
        })
        
       

    }
    
    func refreshControlAction (refreshControl: UIRefreshControl){
        loadHomeTimeLine()
        refreshControl.endRefreshing()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell =  tableView.dequeueReusableCell(withIdentifier: "TweetCustomCell", for: indexPath) as! TweetCustomCell
        
        cell.tweet = self.tweets[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let clickedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: clickedCell)
        let tweet = self.tweets[indexPath!.row]
        print("clicked on \(tweet.text!)")
        let DetailTweetTableViewController = segue.destination as! DetailTweetTableViewController
        
        DetailTweetTableViewController.tweet = tweet
        
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
