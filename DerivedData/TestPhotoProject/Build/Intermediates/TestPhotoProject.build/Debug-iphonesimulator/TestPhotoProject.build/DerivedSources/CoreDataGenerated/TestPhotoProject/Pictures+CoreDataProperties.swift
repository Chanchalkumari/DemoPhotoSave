//
//  Pictures+CoreDataProperties.swift
//  
//
//  Created by Chanchal on 10/07/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Pictures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pictures> {
        return NSFetchRequest<Pictures>(entityName: "Pictures");
    }

    @NSManaged public var pictures: NSData?

}
