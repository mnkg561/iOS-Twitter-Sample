//
//  TweetCustomCell.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/12/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class TweetCustomCell: UITableViewCell {

    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetedByLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
          tweetTextLabel.text = tweet.text
            
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
