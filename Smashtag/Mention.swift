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
            mention.popularity = (mention.popularity?.integerValue ?? 0) + 1
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
            mention.text = twitterInfo.keyword
            mention.popularity = 1
            return mention
        }
        return nil
    }

}
