//
//  ProfilePageViewController.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/22/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    var user: User?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL((user?.profileImageURL)!)
        userNameLabel.text = user?.name
        handleLabel.text = user?.handle
        tweetCountLabel.text = String(user!.statusesCount)
        followingCountLabel.text = String(user!.followingCount)
        followersCountLabel.text = String(user!.followersCount)
        
        let userID = user?.userID
        let banner = TwitterClient.sharedInstance.getUserBanner(userID!, params: nil) { (error) -> () in

    }
        print("banner for \(user!.name!) is here: \(banner)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
