//
//  Tweet.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/12/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
            
            timestamp = dateFormatter.date(from: timeStampString)
        }
       
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
