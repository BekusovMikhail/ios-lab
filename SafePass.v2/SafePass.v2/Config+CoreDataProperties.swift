//
//  Config+CoreDataProperties.swift
//  SafePass.v2
//
//  Created by Mihail on 12/12/21.
//
//

import Foundation
import CoreData


extension Config {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Config> {
        return NSFetchRequest<Config>(entityName: "Config")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}

extension Config : Identifiable {

}
