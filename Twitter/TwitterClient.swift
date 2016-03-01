//
//  TwitterClient.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/10/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "bEKFa4y3uJNaKQHwKL8nfwkg8"
let twitterConsumerSecret = "wENCqUOJMNMdmWwTYSTU0uew6VhkbUHteUYdtooUNvNuDnc9O3"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: (( user: User?, error: NSError?) -> ())?
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance  = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            
            )
        }
        
        return Static.instance
    }
    
    func homeTImelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
                
        })
    }
    
    func loginWithCompletion(completion: ( user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & rediect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemodustyn://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got requestToken")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
                UIApplication.sharedApplication().openURL(authURL!)
            }) {
                (error: NSError!) -> Void in
                print("Failed to get requestToken")
                self.loginCompletion!(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the accessToken")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                    
                        print("user: \(user.name)")
                        self.loginCompletion!(user: user, error: nil)
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                        print("error getting current user")
                        self.loginCompletion!(user: nil, error: error)
                })
                
            }) {
                (error: NSError!) -> Void in
                print("Failed to get accessToken")
                self.loginCompletion!(user: nil, error: error)
        }

    }
    
    
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                completion(error: error)
            }
        )
    }
    
    func unretweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("unretweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("cant unretweet")
                completion(error: error)
            }
        )
    }
    
    func favorite(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't like tweet")
                completion(error: error)
            }
        )
    }
    
    func unfavorite(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Unliked tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't unlike tweet")
                completion(error: error)
            }
        )
    }
    
    func getUserBanner(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("got user banner")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("did not get user banner")
                completion(error: error)
            }
        )
    }
    
    func compose(escapedTweet: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't compose")
                completion(error: error)
            }
        )
    }
    
    func reply(escapedTweet: String, statusID: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't reply")
                completion(error: error)
            }
        )
    }


}
