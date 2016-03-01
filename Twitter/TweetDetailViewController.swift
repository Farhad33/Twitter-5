//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/18/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style:.Plain, target:nil, action:nil)

        
        profileImageView.setImageWithURL(tweet!.user!.profileImageURL!)
        userNameLabel.text = tweet!.user?.name
        handleLabel.text = tweet!.user?.handle
        timeCreatedLabel.text = calculateTimeStamp(tweet!.createdAt.timeIntervalSinceNow)
        tweetLabel.text = tweet?.tweetText
        
        retweetCountLabel.text = String(tweet!.retweetCount!)
        favoriteCountLabel.text = String(tweet!.favoriteCount!)
        
        
        if (tweet!.retweeted) == true {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
            
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
        }
        
        
        if (tweet!.favorited) == true {
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
            
        } else {
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
        
        let path = tweet!.id
        
        let retweeted = tweet!.retweeted
        if retweeted == false {
            TwitterClient.sharedInstance.retweet(path, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweet!.retweetCount = self.tweet!.retweetCount! + 1
                self.tweet!.retweeted = true
                self.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                self.viewDidLoad()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance.unretweet(path, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweet!.retweetCount  = self.tweet!.retweetCount! - 1
                self.tweet!.retweeted = false
                self.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
                self.viewDidLoad()
            })
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        let path = tweet!.id
        
        let favorited = tweet!.favorited
        if favorited == false {
            TwitterClient.sharedInstance.favorite(path, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweet!.favoriteCount = self.tweet!.favoriteCount! + 1
                self.tweet!.favorited = true
                self.favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                self.viewDidLoad()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance.unfavorite(path, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweet!.favoriteCount  = self.tweet!.favoriteCount! - 1
                self.tweet!.favorited = false
                self.favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                self.viewDidLoad()
            })
        }
    }
    
    
    
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
        
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier) == "SegueToReply" {
            let user = User.currentUser
            let tweet = self.tweet
            
            let composeTweetViewController = segue.destinationViewController as! ComposeTweetViewController
            composeTweetViewController.user = user
            composeTweetViewController.tweet = tweet
            composeTweetViewController.handleLabelText = (user?.handle)!
            composeTweetViewController.isReply = true
        } else {
            
        }
    
       
    }


}
