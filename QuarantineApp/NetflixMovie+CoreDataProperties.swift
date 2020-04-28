//
//  NetflixMovie+CoreDataProperties.swift
//  
//
//  Created by iosdev on 27.4.2020.
//
//

import Foundation
import CoreData


extension NetflixMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetflixMovie> {
        return NSFetchRequest<NetflixMovie>(entityName: "NetflixMovie")
    }

    @NSManaged public var title: String?
    @NSManaged public var imbdrating: Double
    @NSManaged public var desc: String?
    @NSManaged public var imgurl: String?

}
