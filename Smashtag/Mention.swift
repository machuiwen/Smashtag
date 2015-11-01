//
//  Mention.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/31/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Mention: NSManagedObject
{
    // utility method to create (or find in database)
    // a Mention with the characteristics of the passed Twitter.Tweet.IndexedKeyword
    // in the database with the given context

    class func mentionWithTwitterInfo(twitterInfo: Twitter.Tweet.IndexedKeyword, inManagedObjectContext context: NSManagedObjectContext) -> Mention?
    {
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "text ==[c] %@", twitterInfo.keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
            mention.text = twitterInfo.keyword
            if twitterInfo.keyword[twitterInfo.keyword.startIndex] == "@"  {
                mention.type = "User"
            } else if twitterInfo.keyword[twitterInfo.keyword.startIndex] == "#" {
                mention.type = "Hashtag"
            }
            return mention
        }
        return nil
    }
    
    // add a Tweet object to a Mention object
    func addTweetObject(value: Tweet) {
        self.mutableSetValueForKey("tweets").addObject(value)
    }
    
    // remove a Tweet object from a Mention object
    func removeTweetObject(value: Tweet) {
        self.mutableSetValueForKey("tweets").removeObject(value)
    }
    
    // add a SearchTerm object to a Mention object
    func addSearchTermObject(value: SearchTerm) {
        self.mutableSetValueForKey("searchTerms").addObject(value)
    }
    
    // remove a SearchTerm object from a Mention object
    func removeSearchTermObject(value: SearchTerm) {
        self.mutableSetValueForKey("searchTerms").removeObject(value)
    }
    
}
