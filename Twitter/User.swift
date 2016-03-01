//
//  User.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/10/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification =  "userDidLoginNotification"
let userDidLogoutNotification =  "userDidLogoutNotification"



class User: NSObject {
    var name: String?
    var handle: String?
    var profileImageURL: NSURL?
    var tagLine: String?
    var dictionary: NSDictionary
    var profileImageString: String?
    var statusesCount: Int
    var followersCount: Int
    var followingCount: Int
    var userID: Int

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        handle = dictionary["screen_name"] as? String
        tagLine = dictionary["description"] as? String
        statusesCount = dictionary["statuses_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        userID = dictionary["id"] as! Int
        
        print("\(handle!) has \(statusesCount) statuses, is following \(followingCount) people, and has \(followersCount) followers ")
        
        profileImageString = dictionary["profile_image_url"] as? String
        if profileImageString != nil {
            profileImageURL = NSURL(string: profileImageString!)
        }

    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do { let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch _ {
        
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)

                } catch _ {
                    
                }
            } else {
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
