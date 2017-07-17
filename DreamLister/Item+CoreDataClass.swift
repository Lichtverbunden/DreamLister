//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ken Krippeler on 17.07.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import Foundation
import CoreData

//@objc(Item)
public class Item: NSManagedObject
{
    public override func awakeFromInsert()
    {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
