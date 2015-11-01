//
//  SearchTerm+CoreDataProperties.swift
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

extension SearchTerm {

    @NSManaged var text: String?
    @NSManaged var mentions: NSSet?
    @NSManaged var tweets: NSSet?

}
