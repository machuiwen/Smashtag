//
//  Mention+CoreDataProperties.swift
//  Smashtag
//
//  Created by Chuiwen Ma on 11/1/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mention {

    @NSManaged var popularity: NSNumber?
    @NSManaged var text: String?
    @NSManaged var type: String?
    @NSManaged var searchTerms: NSSet?
    @NSManaged var tweets: NSSet?

}
