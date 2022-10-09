//
//  Cities+CoreDataProperties.swift
//  Weather App
//
//  Created by Kato Drake Smith on 09/10/2022.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension Cities : Identifiable {

}
