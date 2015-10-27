//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/26/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - Public API
    
    var recentSearches: [String] {
        defaults.synchronize()
        return (defaults.arrayForKey("searches") as? [String]) ?? [String]()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return recentSearches.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        cell.textLabel?.text = recentSearches[recentSearches.count - 1 - indexPath.section].lowercaseString
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if let tweetvc = destinationvc as? TweetTableViewController {
            if let search = sender as? UITableViewCell {
                tweetvc.searchText = search.textLabel?.text
            }
        }
    }
    
}
