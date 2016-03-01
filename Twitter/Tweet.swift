//
//  Tweet.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/10/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var tweetText: String
    var createdAtString: String?
    var createdAt: NSDate
    var formattedDate: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var id: Int
    var retweeted: Bool
    var favorited: Bool
    

    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        tweetText = (dictionary["text"] as? String)!
        createdAtString = dictionary["created_at"] as? String
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)!
        
        formattedDate = formatter.stringFromDate(createdAt)

        
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        id = dictionary["id"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        
       
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
