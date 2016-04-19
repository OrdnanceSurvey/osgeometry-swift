//
//  OSGeometryTests.swift
//  OSGeometryTests
//
//  Created by Dave Hardiman on 19/04/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import XCTest
import Nimble
@testable import OSGeometry

class OSGeometryTests: XCTestCase {
    
    func testItIsPossibleToParseAMultiPolygon() {
        let geometry = Geometry.geometry(fromJSON: jsonFixtureForName("multipolygon"))
        expect(geometry?.type).to(equal("MultiPolygon"))
        expect(geometry?.crs.name).to(equal("urn:ogc:def:crs:EPSG::27700"))
        guard let mp = geometry as? MultiPolygon else {
            fail("Should be a multi polygon")
            return
        }
        expect(mp.coordinates).to(haveCount(1))
        let lineString = mp.coordinates.first?.first
        expect(lineString?.coordinates).to(haveCount(4))
        expect(lineString?.coordinates.first?.x).to(equal(439371.2))
        expect(lineString?.coordinates.first?.y).to(equal(144052.7))
    }

    func testItIsPossibleToParseAPolygon() {
        let geometry = Geometry.geometry(fromJSON: jsonFixtureForName("polygon"))
        expect(geometry?.type).to(equal("Polygon"))
        expect(geometry?.crs.name).to(equal("urn:ogc:def:crs:EPSG::27700"))
        guard let mp = geometry as? Polygon else {
            fail("Should be a polygon")
            return
        }
        expect(mp.coordinates).to(haveCount(1))
        let lineString = mp.coordinates.first
        expect(lineString?.coordinates).to(haveCount(4))
        expect(lineString?.coordinates.first?.x).to(equal(437272.93))
        expect(lineString?.coordinates.first?.y).to(equal(115593.34))
    }

    func testItIsPossibleToParseAPoint() {
        let geometry = Geometry.geometry(fromJSON: jsonFixtureForName("point"))
        expect(geometry?.type).to(equal("Point"))
        expect(geometry?.crs.name).to(equal("urn:ogc:def:crs:EPSG::27700"))
        guard let mp = geometry as? Point else {
            fail("Should be a point")
            return
        }
        expect(mp.coordinates.x).to(equal(437265))
        expect(mp.coordinates.y).to(equal(115324.36))
    }
}
