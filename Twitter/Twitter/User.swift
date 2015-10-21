//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

public struct User: CustomStringConvertible
{
    public let screenName: String
    public let name: String
    public let id: String
    public let verified: Bool
    public let profileImageURL: NSURL?
    
    public var description: String { let v = verified ? " ✅" : ""; return "@\(screenName) (\(name))\(v)" }
    
    // MARK: - Private Implementation
    
    init?(data: NSDictionary?) {
        let screenName = data?.valueForKeyPath(TwitterKey.ScreenName) as? String
        let name = data?.valueForKeyPath(TwitterKey.Name) as? String
        let id = data?.valueForKeyPath(TwitterKey.ID) as? String
        self.verified = data?.valueForKeyPath(TwitterKey.Verified)?.boolValue ?? false
        
        var profileImageURL: NSURL?
        if let urlString = data?.valueForKeyPath(TwitterKey.ProfileImageURL) as? String where urlString.characters.count > 0 {
            profileImageURL = NSURL(string: urlString)
        }
        self.profileImageURL = profileImageURL
        
        self.screenName = screenName ?? ""
        self.name = name ?? ""
        self.id = id ?? ""
        
        if name == nil || screenName == nil || id == nil {
            return nil
        }
    }
    
    var asPropertyList: AnyObject {
        var plist = [TwitterKey.Name:name, TwitterKey.ScreenName:screenName, TwitterKey.ID:id, TwitterKey.Verified:(verified ? "YES" : "NO")]
        plist[TwitterKey.ProfileImageURL] = profileImageURL?.absoluteString
        return plist
    }
    
    init() {
        screenName = "Unknown"
        name = "Unknown"
        id = "Unknown"
        verified = false
        profileImageURL = nil
    }
    
    struct TwitterKey {
        static let Name = "name"
        static let ScreenName = "screen_name"
        static let ID = "id_str"
        static let Verified = "verified"
        static let ProfileImageURL = "profile_image_url"
    }
}
