//
//  StoreRecords+CoreDataProperties.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 1.03.23.
//
//

import Foundation
import CoreData

extension StoreRecords {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreRecords> {
        return NSFetchRequest<StoreRecords>(entityName: "StoreRecords")
    }

    @NSManaged public var records: Data?

}

extension StoreRecords: Identifiable {
}
