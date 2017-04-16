//
//  TweetCustomCell.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/12/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCustomCell: UITableViewCell {

    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetedByLabel: UILabel!

    
    var tweet: Tweet! {
        didSet{
            print("i got the call")
            tweetTextLabel.text = tweet.text
            tweetedByLabel.text = tweet.name
            userNameLabel.text = tweet.screenName
            ownerImageView.setImageWith(tweet.profileURL!)
           
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
