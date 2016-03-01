//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/12/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style:.Plain, target:nil, action:nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        // Do any additional setup after loading the view.
        
        TwitterClient.sharedInstance.homeTImelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        
        User.currentUser?.logout()
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count;
        }
        return 0;
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        cell.selectionStyle = .None
        let tweet = tweets![indexPath.row]
        
        cell.tweetLabel.text = tweet.tweetText
        cell.userNameLabel.text = tweet.user!.name
        cell.handleLabel.text = "@\(tweet.user!.handle!)"
        
        
        cell.profileImageView.setImageWithURL((tweet.user!.profileImageURL)!)
        
        
        
        cell.timeCreatedLabel.text = calculateTimeStamp(tweet.createdAt.timeIntervalSinceNow)
        cell.retweetCountLabel.text = String(tweet.retweetCount!)
        cell.favoriteCountLabel.text = String(tweet.favoriteCount!)
        
        cell.retweetCountLabel.text! == "0" ? (cell.retweetCountLabel.hidden = true) : (cell.retweetCountLabel.hidden = false)
        cell.favoriteCountLabel.text! == "0" ? (cell.favoriteCountLabel.hidden = true) : (cell.favoriteCountLabel.hidden = false)
        
        if (tweet.retweeted) == true {
            cell.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
            
        } else {
            cell.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
        }
        
        
        if (tweet.favorited) == true {
            cell.favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
            
        } else {
            cell.favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
        }

        
 
        return cell
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
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
        cell.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
        
        let path = tweet.id

        let retweeted = tweet.retweeted
        if retweeted == false {
            TwitterClient.sharedInstance.retweet(path, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweets![indexPath!.row].retweetCount = self.tweets![indexPath!.row].retweetCount! + 1
                tweet.retweeted = true
                cell.retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
                self.tableView.reloadData()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance.unretweet(path, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweets![indexPath!.row].retweetCount  = self.tweets![indexPath!.row].retweetCount! - 1
                tweet.retweeted = false
                cell.retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
       
        
        let path = tweet.id
        
        let favorited = tweet.favorited
        if favorited == false {
            TwitterClient.sharedInstance.favorite(path, params: nil) { (error) -> () in
                print("Liking")
                self.tweets![indexPath!.row].favoriteCount = self.tweets![indexPath!.row].favoriteCount! + 1
                tweet.favorited = true
                 cell.favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
                self.tableView.reloadData()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance.unfavorite(path, params: nil , completion: { (error) -> () in
                print("Unlinking")
                self.tweets![indexPath!.row].favoriteCount  = self.tweets![indexPath!.row].favoriteCount! - 1
                tweet.favorited = false
                 cell.favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.viewDidLoad()
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SegueToTweetDetails") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        }
        else if (segue.identifier) == "SegueToComposeTweet" {
            
            let user = User.currentUser
            
            let composeTweetViewController = segue.destinationViewController as! ComposeTweetViewController
            composeTweetViewController.user = user
        } else if (segue.identifier) == "SegueToProfilePage" {
            

            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetsTableViewCell
            
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let user = tweet.user
            
            let profilePageViewController = segue.destinationViewController as! ProfilePageViewController
            profilePageViewController.user = user

        }

    }
    
    
    
    


}
