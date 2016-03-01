//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/22/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    
    var user: User?
    var tweet: Tweet?
    var handleLabelText: String?
    var tweetMessage: String = ""
    var isReply: Bool?

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var charCountLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTextView.delegate = self
        
        profileImageView.setImageWithURL((user?.profileImageURL)!)
        userNameLabel.text = user?.name
        handleLabel.text = "@" + (user?.handle)!
        
        if (isReply) == true {
            composeTextView.text = "@\((tweet?.user?.handle)!) "
            if  0 < (141 - composeTextView.text!.characters.count) {
                tweetButton.enabled = true
                charCountLabel.text = "\(140 - composeTextView.text!.characters.count)"
            }
            else{
                tweetButton.enabled = false
            }
            isReply = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    
    
    @IBAction func onTweet(sender: AnyObject) {
        tweetMessage = composeTextView.text
        let escapedTweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        
        if isReply == true {
            TwitterClient.sharedInstance.reply(escapedTweetMessage!, statusID: tweet!.id, params: nil , completion: { (error) -> () in
                print("replying")
                print(error)
            })
            isReply = false
            navigationController?.popViewControllerAnimated(true)
        } else {
            TwitterClient.sharedInstance.compose(escapedTweetMessage!, params: nil, completion: { (error) -> () in
                print("composing")
                print(error)
            })
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func textViewDidChange(textView: UITextView) {
        if  0 < (141 - composeTextView.text!.characters.count) {
            tweetButton.enabled = true
            charCountLabel.text = "\(140 - composeTextView.text!.characters.count)"
        }
        else{
            tweetButton.enabled = false
            charCountLabel.text = "\(140 - composeTextView.text!.characters.count)"
        }
    }

    

}
