//
//  PopularMentionsTableViewController.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/31/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionsTableViewController: CoreDataTableViewController {
    
    // MARK: Model
    
    var searchText: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    // MARK: UI Updating
    
    private func updateUI() {
        if let context = managedObjectContext where searchText != nil {
            let request = NSFetchRequest(entityName: "Mention")
            request.sortDescriptors = [
                NSSortDescriptor(key: "type", ascending: false),
                NSSortDescriptor(key: "popularity", ascending: false),
                NSSortDescriptor(key: "text", ascending: true, selector: "localizedCaseInsensitiveCompare:")
            ]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ AND popularity > 1", searchText!)
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PopularMentionCell", forIndexPath: indexPath)
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
            var mentionText: String?
            var mentionPopularity: Int?
            mention.managedObjectContext?.performBlockAndWait {
                mentionText = mention.text
                mentionPopularity = mention.popularity?.integerValue
            }
            cell.textLabel?.text = mentionText
            // show the number of times the mention was mentioned
            if let t = mentionPopularity {
                cell.detailTextLabel?.text = (t == 1) ? "mentioned 1 time" : "mentioned \(t) times"
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        return cell
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc: UIViewController? = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController
        }
        if segue.identifier == "Show Search" {
            if let tweetvc = segue.destinationViewController as? TweetTableViewController {
                tweetvc.searchText = (sender as? UITableViewCell)?.textLabel?.text
            }
        }
    }
    
    @IBAction private func goBackToRootView(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
