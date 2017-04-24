//
//  ProfileTweetCell.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/21/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class ProfileTweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    var tweet: Tweet! {
        didSet{
           

            nameLabel.text = tweet.name
            screenNameLabel.text = tweet.screenName
            tweetTextLabel.text = tweet.text
            profileImageView.setImageWith(tweet.profileURL!)
            tweetCount.text = String(tweet.retweetCount)
            likeCount.text = String(tweet.favoritesCount)
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
