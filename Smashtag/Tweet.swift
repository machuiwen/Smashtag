//
//  Tweet.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/31/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Tweet: NSManagedObject
{
    // utility method to create (or find in database)
    // a Tweet with the characteristics of the passed Twitter.Tweet
    // in the database with the given context
    
    class func tweetWithTwitterInfoAndSearchTerm(twitterInfo: Twitter.Tweet, searchTerm: SearchTerm, inManagedObjectContext context: NSManagedObjectContext) -> Tweet?
    {
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "id == %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
            tweet.id = twitterInfo.id
            for mentionItem in (twitterInfo.userMentions + twitterInfo.hashtags) {
                if let mention = Mention.mentionWithTwitterInfo(mentionItem, inManagedObjectContext: context) {
                    tweet.addMentionObject(mention)
                    mention.addSearchTermObject(searchTerm)
                }
            }
            return tweet
        }
        return nil
    }
    
    // add a Mention object to a Tweet object
    func addMentionObject(value: Mention) {
        self.mutableSetValueForKey("mentions").addObject(value)
    }
    
    // remove a Mention object from a Tweet object
    func removeMentionObject(value:Mention) {
        self.mutableSetValueForKey("mentions").removeObject(value)
    }
    
    // add a SearchTerm object to a Tweet object
    func addSearchTermObject(value: SearchTerm) {
        self.mutableSetValueForKey("searchTerms").addObject(value)
    }
    
    // remove a SearchTerm object from a Tweet object
    func removeSearchTermObject(value: SearchTerm) {
        self.mutableSetValueForKey("searchTerms").removeObject(value)
    }
    
}
