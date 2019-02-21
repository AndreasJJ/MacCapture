//
//  serverConfigStruct.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 21.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation

struct serverConfig {
    var uploadURL: URL
    var arguments: [String: String]
    var fileFormName: String
}
