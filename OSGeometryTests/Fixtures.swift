//
//  Fixtures.swift
//  OSGeometryTests
//
//  Created by Dave Hardiman on 15/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation
import OSJSON

private final class BundleHelper {}
func Bundle() -> NSBundle {
    return NSBundle(forClass: BundleHelper.self)
}

func fixtureForName(fixtureName: String, fileExtension: String = "json") -> NSData {
    return NSData(contentsOfURL: Bundle().URLForResource(fixtureName, withExtension: fileExtension)!)!
}

func jsonFixtureForName(fixtureName: String, fileExtension: String = "json") -> OSJSON {
    let data = fixtureForName(fixtureName, fileExtension: fileExtension)
    return JSON(data: data)!
}
