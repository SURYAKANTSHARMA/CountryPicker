//
//  Tweet+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by SuryaKant Sharma on 04/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }

    @NSManaged public var text: String?
    @NSManaged public var id: String?

}
