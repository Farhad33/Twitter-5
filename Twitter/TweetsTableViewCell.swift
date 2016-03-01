//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Majid Rahimi on 2/12/16.
//  Copyright © 2016 Majid Rahimi. All rights reserved.
//

import UIKit
import AFNetworking


class TweetsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweetID: String = ""


    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        userNameLabel.preferredMaxLayoutWidth = userNameLabel.frame.size.width
        
        handleLabel.preferredMaxLayoutWidth = handleLabel.frame.size.width
        timeCreatedLabel.preferredMaxLayoutWidth = timeCreatedLabel.frame.size.width
        
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
