//
//  Crs.swift
//  OSGeometry
//
//  Created by Dave Hardiman on 14/03/2016
//  Copyright (c) Ordnance Survey. All rights reserved.
//

import Foundation
import OSJSON

@objc(OSCRS)
public class CRS: NSObject, Decodable {

    // MARK: Properties
    public let name: String

    init(name: String) {
        self.name = name
        super.init()
    }

    //MARK: JSON initialiser
    convenience public required init?(json: JSON) {
        guard let propertiesJSON = json.jsonForKey(CRS.PropertiesKey),
            name = propertiesJSON.stringValueForKey("name")
            else {
                return nil
        }
        self.init(name: name)
    }
}

extension CRS {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    @nonobjc internal static let PropertiesKey: String = "properties"
    
}
