//
//  CityArrayItem+CoreDataProperties.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import Foundation
import CoreData


extension CityArrayItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityArrayItem> {
        return NSFetchRequest<CityArrayItem>(entityName: "CityArrayItem")
    }

    @NSManaged public var nameCity: String?

}

extension CityArrayItem : Identifiable {

}
