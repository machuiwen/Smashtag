//
//  MediaItem.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// holds the network url and aspectRatio of an image attached to a Tweet
// created automatically when a Tweet object is created

public struct MediaItem
{
    public let url: NSURL
    public let aspectRatio: Double
    
    public var description: String { return (url.absoluteString ?? "no url") + " (aspect ratio = \(aspectRatio))" }
    
    // MARK: - Private Implementation
    
    init?(data: NSDictionary?) {
        var url: NSURL?
        var width = 0.0, height = 0.0
        if let urlString = data?.valueForKeyPath(TwitterKey.MediaURL) as? String {
            url = NSURL(string: urlString)
            height = data?.valueForKeyPath(TwitterKey.Height) as? Double ?? 0.0
            width = data?.valueForKeyPath(TwitterKey.Width) as? Double ?? 0.0
        }
        if height != 0 && width != 0 && url != nil {
            aspectRatio = width / height
            self.url = url!
        } else {
            return nil
        }
    }
    
    struct TwitterKey {
        static let MediaURL = "media_url_https"
        static let Width = "sizes.small.w"
        static let Height = "sizes.small.h"
    }
}
