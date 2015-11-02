//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/25/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    // MARK: Public API
    
    var tweet: Twitter.Tweet? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Private data structure
    
    private struct SectionInfo {
        var titleForHeader: String
        var cellType: String
        var numberOfRows: Int
        var segueIdentifier: String?
    }
    
    private var sections: [SectionInfo] {
        get {
            if let t = tweet {
                return [
                    SectionInfo(titleForHeader: "Images", cellType: "ImageCell", numberOfRows: t.media.count, segueIdentifier: "Show Image"),
                    SectionInfo(titleForHeader: "Hashtags", cellType: "TextCell", numberOfRows: t.hashtags.count, segueIdentifier: "Search Hashtag"),
                    SectionInfo(titleForHeader: "Users", cellType: "TextCell", numberOfRows: t.userMentions.count + 1, segueIdentifier: "Search User"),
                    SectionInfo(titleForHeader: "Urls", cellType: "TextCell", numberOfRows: t.urls.count, segueIdentifier: "Show Webpage")
                ]
            } else {
                return [SectionInfo]()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sections[indexPath.section].cellType, forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            if let url = tweet?.media[indexPath.row].url {
                if let imageCell = cell as? ImageTableViewCell {
                    imageCell.imageURL = url
                }
            }
        case 1:
            cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
        case 2:
            if indexPath.row == 0 {
                if let tweeter = tweet?.user.screenName {
                    cell.textLabel?.text = "@" + tweeter
                }
            } else {
                cell.textLabel?.text = tweet?.userMentions[indexPath.row - 1].keyword
            }
        case 3:
            cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].titleForHeader
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.hidden = sections[section].numberOfRows == 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section != 0 || tweet == nil {
            return UITableViewAutomaticDimension
        } else {
            return tableView.frame.width / CGFloat(tweet!.media[indexPath.row].aspectRatio)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let segueIdentifier = sections[indexPath.section].segueIdentifier {
            performSegueWithIdentifier(segueIdentifier, sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let tweetvc = destinationvc as? TweetTableViewController {
            if let mention = sender as? UITableViewCell {
                if segue.identifier == "Search User" {
                    tweetvc.searchText = mention.textLabel?.text
                    /*
                    // HW4 extra credit, introduce confusion in HW5
                    if let user = mention.textLabel?.text {
                        tweetvc.searchText = user + " OR " + user.substringFromIndex(user.startIndex.advancedBy(1))
                    }
                    */
                } else if segue.identifier == "Search Hashtag" {
                    tweetvc.searchText = mention.textLabel?.text
                }
            }
        } else if let imagevc = destinationvc as? ImageViewController {
            if let imageCell = sender as? ImageTableViewCell {
                imagevc.image = imageCell.myImage
            }
        } else if let webvc = destinationvc as? WebViewController {
            if let urlCell = sender as? UITableViewCell {
                webvc.urlPath = urlCell.textLabel?.text
            }
        }
    }
    
    @IBAction private func goBackToRootView(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
