//
//  Tweet.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// a simple container class which just holds the data in a Tweet
// IndexedKeywords are substrings of the Tweet's text
// for example, a hashtag or other user or url that is mentioned in the Tweet
// note carefully the comments on the range property in an IndexedKeyword
// Tweet instances are created by fetching from Twitter using a TwitterRequest

public class Tweet : CustomStringConvertible
{
    public let text: String
    public let user: User
    public let created: NSDate
    public let id: String
    public let media: [MediaItem]
    public let hashtags: [IndexedKeyword]
    public let urls: [IndexedKeyword]
    public let userMentions: [IndexedKeyword]
    
    public struct IndexedKeyword: CustomStringConvertible
    {
        public let keyword: String              // will include # or @ or http prefix
        public let nsrange: NSRange             // index into an NS[Attributed]String made from the Tweet's text
        
        public init?(data: NSDictionary?, inText text: String, prefix: String) {
            let indices = data?.valueForKeyPath(TwitterKey.Entities.Indices) as? NSArray
            if let start = (indices?.firstObject as? NSNumber)?.integerValue,
                let end = (indices?.lastObject as? NSNumber)?.integerValue {
                    // because of the vagaries of Unicode characters
                    // (some look like 2 or even 3 characters)
                    // we have to search around a bit to find embedded keywords in an NS[Attributed]String
                    let nstext = text as NSString
                    let length = end - start
                    var location = max(min(start + length / 2, nstext.length - length), 0)
                    while location >= 0 && location + length > start {
                        let nsrange = NSRange(location: location, length: length)
                        let keyword = nstext.substringWithRange(nsrange)
                        if keyword.hasPrefix(prefix) {
                            self.keyword = keyword
                            self.nsrange = nsrange
                            // success
                            return
                        }
                        location--
                    }
            }
            // fail
            return nil
        }
        
        public var description: String { get { return "\(keyword) (\(nsrange.location), \(nsrange.location+nsrange.length-1))" } }
    }
    
    public var description: String { return "\(user) - \(created)\n\(text)\nhashtags: \(hashtags)\nurls: \(urls)\nuser_mentions: \(userMentions)" + "\nid: \(id)" }
    
    // MARK: - Private Implementation
    
    init?(data: NSDictionary?) {
        var user: User?
        var text: String?
        var created: NSDate?
        var id: String?
        var media = [MediaItem]()
        var hashtags = [IndexedKeyword]()
        var urls = [IndexedKeyword]()
        var userMentions = [IndexedKeyword]()
        
        user = User(data: data?.valueForKeyPath(TwitterKey.User) as? NSDictionary)
        text = data?.valueForKeyPath(TwitterKey.Text) as? String
        if text != nil {
            created = (data?.valueForKeyPath(TwitterKey.Created) as? String)?.asTwitterDate
            id = data?.valueForKeyPath(TwitterKey.ID) as? String
            if let mediaEntities = data?.valueForKeyPath(TwitterKey.Media) as? NSArray {
                for mediaData in mediaEntities {
                    if let mediaItem = MediaItem(data: mediaData as? NSDictionary) {
                        media.append(mediaItem)
                    }
                }
            }
            let hashtagMentionsArray = data?.valueForKeyPath(TwitterKey.Entities.Hashtags) as? NSArray
            hashtags = Tweet.getIndexedKeywords(hashtagMentionsArray, inText: text!, prefix: "#")
            let urlMentionsArray = data?.valueForKeyPath(TwitterKey.Entities.URLs) as? NSArray
            urls = Tweet.getIndexedKeywords(urlMentionsArray, inText: text!, prefix: "http")
            let userMentionsArray = data?.valueForKeyPath(TwitterKey.Entities.UserMentions) as? NSArray
            userMentions = Tweet.getIndexedKeywords(userMentionsArray, inText: text!, prefix: "@")
        }
        
        // unfortunately, failable initializers don't allow any instance variables to be left unset
        // even if we are going to fail
        
        self.user = user ?? User()
        self.text = text ?? ""
        self.created = created ?? NSDate()
        self.id = id ?? ""
        self.media = media
        self.hashtags = hashtags
        self.urls = urls
        self.userMentions = userMentions
        
        // now we fail if any of our required fields couldn't be loaded up properly
        
        if user == nil || text == nil || created == nil || id == nil {
            return nil
        }
    }
    
    private static func getIndexedKeywords(dictionary: NSArray?, inText: String, prefix: String) -> [IndexedKeyword] {
        var results = [IndexedKeyword]()
        if let indexedKeywords = dictionary {
            for indexedKeywordData in indexedKeywords {
                if let indexedKeyword = IndexedKeyword(data: indexedKeywordData as? NSDictionary, inText: inText, prefix: prefix) {
                    results.append(indexedKeyword)
                }
            }
        }
        return results
    }
    
    struct TwitterKey {
        static let User = "user"
        static let Text = "text"
        static let Created = "created_at"
        static let ID = "id_str"
        static let Media = "entities.media"
        struct Entities {
            static let Hashtags = "entities.hashtags"
            static let URLs = "entities.urls"
            static let UserMentions = "entities.user_mentions"
            static let Indices = "indices"
        }
    }
}

private extension String {
    var asTwitterDate: NSDate? {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            return dateFormatter.dateFromString(self)
        }
    }
}
