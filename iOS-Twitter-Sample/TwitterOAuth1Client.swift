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
         
             //This works perfectly fine if i remove self.loginSuccess?() call statement
             
            self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let dictionaries =  response as? [NSDictionary]
                let tweets = Tweet.tweetWithArray(dictionaries: dictionaries!)
                print("i'm inside")
                
                for tweet in tweets {
                    print(tweet.text)
                }

            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
            })
 
            
            
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
    
    func getHomeTimeLine(success2: @escaping ([Tweet]) -> (), failure2: @escaping (Error) -> ()){
        
        print("i'm getting call")
    

        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries =  response as? [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries!)
            print("i'm inside")
            
            for tweet in tweets {
                print(tweet.text)
            }
            success2(tweets)
            
        }, failure: { (task: URLSessionDataTask!, error: Error!) in
            
            print("i'm inside failure")
            print(error.localizedDescription)
            failure2(error)
        })

    }

    
}
