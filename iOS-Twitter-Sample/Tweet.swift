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
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var postImageURL: URL?
    let userNameSymbol: String = "@"
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userDictionary: NSDictionary?
    var date: String?
    var tweetId: String?
    var retweetedFlag: Bool?
    var favoritedFlag: Bool?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        userDictionary = dictionary["user"] as? NSDictionary
        name = userDictionary?["name"] as? String
        screenName =  userDictionary?["screen_name"] as? String
        screenName = userNameSymbol + screenName!
        tweetId = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweetedFlag = dictionary["retweeted"] as? Bool
        favoritedFlag = dictionary["favorited"] as? Bool
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            
            date = timeStampString.substring(to: (timeStampString.range(of: "+")?.lowerBound)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
            
            timestamp = dateFormatter.date(from: timeStampString)
        }
        
        let profileUrlString = userDictionary?["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileURL = URL(string: profileUrlString)
        }
        if (text?.components(separatedBy: "https://t.co").count == 2) {
        
            if let range = text?.range(of: "https://t.co") {
                let postImageUrlString = text?.substring(from: range.lowerBound)
                if let postImageUrlString = postImageUrlString {
                    print(postImageUrlString)
                    postImageURL = URL(string: postImageUrlString)
                }
            }
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
