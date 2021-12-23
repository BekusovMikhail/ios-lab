//
//  Recording+CoreDataProperties.swift
//  SafePass.v2
//
//  Created by Mihail on 12/12/21.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var company: String?
    @NSManaged public var password: String?
    @NSManaged public var login: String?

}

extension Recording : Identifiable {

}
