//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 11/1/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation
import CoreData


class SearchTerm: NSManagedObject
{
    // utility method to create (or find in database)
    // a SearchTerm with the passed searchTerm String
    // in the database with the given context
    
    class func searchTermWithString(searchText: String, inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm?
    {
        let request = NSFetchRequest(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "text ==[c] %@", searchText)
        
        if let searchTerm = (try? context.executeFetchRequest(request))?.first as? SearchTerm {
            return searchTerm
        } else if let searchTerm = NSEntityDescription.insertNewObjectForEntityForName("SearchTerm", inManagedObjectContext: context) as? SearchTerm {
            searchTerm.text = searchText
            return searchTerm
        }
        return nil
    }
    
    // add a Tweet object to a SearchTerm object
    func addTweetObject(value: Tweet) {
        self.mutableSetValueForKey("tweets").addObject(value)
    }
    
    // remove a Tweet object from a SearchTerm object
    func removeTweetObject(value: Tweet) {
        self.mutableSetValueForKey("tweets").removeObject(value)
    }
    
    // add a Mention object to a SearchTerm object
    func addMentionObject(value: Mention) {
        self.mutableSetValueForKey("mentions").addObject(value)
    }
    
    // remove a Mention object from a SearchTerm object
    func removeMentionObject(value: Mention) {
        self.mutableSetValueForKey("mentions").removeObject(value)
    }
    
}
