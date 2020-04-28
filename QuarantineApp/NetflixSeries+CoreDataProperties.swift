//
//  NetflixSeries+CoreDataProperties.swift
//  
//
//  Created by iosdev on 27.4.2020.
//
//

import Foundation
import CoreData


extension NetflixSeries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetflixSeries> {
        return NSFetchRequest<NetflixSeries>(entityName: "NetflixSeries")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var imgurl: String?
    @NSManaged public var imbdrating: Double

}
