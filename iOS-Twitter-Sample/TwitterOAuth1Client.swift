//
//  TwitterOAuth1Client.swift
//  iOS-Twitter-Sample
//
//  Created by Mogulla, Naveen on 4/11/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterOAuth1Client: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterOAuth1Client(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "CIJATrGfSxv5aoyIdv0DqTrlL", consumerSecret: "fnPoCSw8cG5uxW4JO7h5YN4Zi2yTKsqx5JsNnYSxxddKT4auiI")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func redirectUserToTwitter(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        //step1: Clear any request tokens
        
        deauthorize()
        
        //Step 2: Call Twitter Request Token end point to get a request token
        fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "iostwittersample://callback")!, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("request token \(requestToken.token!)")
            
            //step 3: Redirect the user to Twitter with request token in the query parameter
            let authCodeURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(authCodeURL, options: [:], completionHandler: { (Bool) in
                print("user has been redirected to twitter")
                
            })
        }) { (error: Error!) in
            print("iam in trouble")
            self.loginFailure?(error)
        }
    }
    
    func getAccessToken(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query!)
        // step 1
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("access token \(accessToken!.token))")
            
            self.userDetails(success1:  { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure1: { (error: Error) in
                
                self.loginFailure?(error)
            })
            
            
        }) { (error: Error!) in
            print("error occured")
            self.loginFailure?(error)
        }
        
    }
    
    func userDetails(success1: @escaping (User) -> (), failure1: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress:nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as? NSDictionary
            if let userDictionary = userDictionary {
                let user = User(dictionary: userDictionary)
                print("user name \(user.name!)")
                success1(user)
            }
            
        }, failure: { (task: URLSessionDataTask!, error: Error!) in
            failure1(error)
        })
        
    }
    
    func testHomeLine(success3: @escaping ([Tweet]) -> (), failure3: @escaping (Error) -> ()){
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (urlTask: URLSessionDataTask, response: Any?) in
            let dictionaries =  response as? [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries!)
            success3(tweets)
            
            
        }) { (urlTask: URLSessionDataTask?, error: Error) in
            failure3(error)
        }
    }
    
    func sendNewTweet(newTweetText: String){
    
        post("1.1/statuses/update.json", parameters: ["status": newTweetText], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("new tweet is succesful ")
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    func replyToTweet(replyTweetText: String, tweetId: String){
        
        post("1.1/statuses/update.json", parameters: ["status": replyTweetText, "in_reply_to_status_id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("reply tweet is succesful ")
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }
    
    
    func retweet(twitterId: String, apiOperationString: String){
        post("1.1/statuses/\(apiOperationString)/\(twitterId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
       
            print("retweet api is succesful ")
        }) { (task: URLSessionDataTask?, error: Error) in
        print(error.localizedDescription)
        }
    }
    
    
    func makeItFavorite(twitterId: String, apiOperationString: String){
        post("1.1/favorites/\(apiOperationString).json", parameters: ["id": twitterId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
             print(" favorites api is succesful ")
            
        }) { (task: URLSessionDataTask?, error: Error) in
           print(error.localizedDescription)
        }
    }
    
    func getPresentUserProfile(screenName: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
    
        get("1.1/users/show.json", parameters: ["screen_name": screenName], progress: nil, success: { (urlTask: URLSessionDataTask, response: Any?) in
            let dictionary =  response as? NSDictionary
            success(dictionary!)
            
        }) { (urlTask: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
        
    }
    
    func getUserTimeLine(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        
        
        get("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenName, "exclude_replies": true, "include_rts": false], progress: nil, success: { (urlTask: URLSessionDataTask, response: Any?) in
            let dictionaries =  response as? [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries!)
            success(tweets)
            
        }) { (urlTask: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        }
        
    }
    
}
