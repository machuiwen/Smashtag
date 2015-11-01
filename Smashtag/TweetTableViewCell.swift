//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 10/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    // MARK: Public API
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: UI
    
    @IBOutlet private weak var tweetScreenNameLabel: UILabel!
    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetCreatedLabel: UILabel!
    @IBOutlet private weak var tweetProfileImageView: UIImageView!
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                // highlight hashtags, urls, and user mentions in the text of each tweet
                let myAttributedText = NSMutableAttributedString(string: tweetTextLabel.text!)
                for hashtag in tweet.hashtags {
                    myAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: hashtag.nsrange)
                }
                for url in tweet.urls {
                    myAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: url.nsrange)
                }
                for mention in tweet.userMentions {
                    myAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: mention.nsrange)
                }
                tweetTextLabel.attributedText = myAttributedText
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [ weak weakSelf = self ] in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        if profileImageURL == weakSelf?.tweet?.user.profileImageURL {
                            dispatch_async(dispatch_get_main_queue()) {
                                weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}
