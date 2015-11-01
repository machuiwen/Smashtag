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
    
    var searchText: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    
    private func updateUI() {
        if let context = managedObjectContext where searchText != nil {
            let request = NSFetchRequest(entityName: "Mention")
            request.sortDescriptors = [
                NSSortDescriptor(key: "popularity", ascending: false),
                NSSortDescriptor(key: "text", ascending: true, selector: "localizedCaseInsensitiveCompare:")
            ]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ AND popularity > 1", searchText!)
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
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
            }
        }
        return cell
    }
    
}