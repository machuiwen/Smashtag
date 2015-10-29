//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/26/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {
    
    // MARK: - Model
    
    private var recentSearches = SearchHistory()
    
    // MARK: - UI
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        cell.textLabel?.text = recentSearches.searchTextAtIndex(indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            recentSearches.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
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
