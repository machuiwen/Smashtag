//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 10/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class SearchHistory {
    
    // MARK: - Public API
    // Notice: for user, index 0 is the most recent search query
    //         for us, index 0 is the oldest search query
    
    // Add a new search query
    func add(searchText: String?) {
        if let query = searchText where !query.isEmpty {
            if let id = recentSearches.indexOf({ return $0.lowercaseString == query.lowercaseString }) {
                recentSearches.removeAtIndex(id)
            }
            recentSearches.append(query)
            if recentSearches.count > maximumQueryNumber {
                recentSearches.removeFirst(recentSearches.count - maximumQueryNumber)
            }
        }
    }
    
    // Remove a search query at certain index
    func removeAtIndex(index: Int) {
        if index >= 0 && index < recentSearches.count {
            recentSearches.removeAtIndex(recentSearches.count - 1 - index)
        }
    }
    
    // Return a search query at certain index
    func searchTextAtIndex(index: Int) -> String? {
        if index >= 0 && index < recentSearches.count {
            return recentSearches[recentSearches.count - 1 - index]
        } else {
            return nil
        }
    }
    
    // Get only property of the number of search queries
    var count: Int {
        return recentSearches.count
    }
    
    // Private data
    private let maximumQueryNumber = 100
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var recentSearches: [String] {
        get {
            return (defaults.arrayForKey("searches") as? [String]) ?? [String]()
        }
        set {
            defaults.setObject(newValue, forKey: "searches")
        }
    }
    
}