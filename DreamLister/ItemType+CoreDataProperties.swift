//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ken Krippeler on 17.07.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
