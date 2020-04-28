//
//  Games+CoreDataProperties.swift
//  
//
//  Created by iosdev on 27.4.2020.
//
//

import Foundation
import CoreData


extension Games {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Games> {
        return NSFetchRequest<Games>(entityName: "Games")
    }

    @NSManaged public var title: String?
    @NSManaged public var developer: String?
    @NSManaged public var avg2weeks: Int64
    @NSManaged public var appid: Int64

}
