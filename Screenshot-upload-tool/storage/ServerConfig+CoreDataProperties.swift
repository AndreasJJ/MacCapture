//
//  ServerConfig+CoreDataProperties.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 23.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//
//

import Foundation
import CoreData


extension ServerConfig {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerConfig> {
        return NSFetchRequest<ServerConfig>(entityName: "ServerConfig")
    }

    @NSManaged public var arguments: [String : String]?
    @NSManaged public var fileFormName: String?
    @NSManaged public var uploadUrl: URL?
    @NSManaged public var name: String?

}
