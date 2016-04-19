//
//  Geometry.swift
//  OSGeometry
//
//  Created by Dave Hardiman on 14/03/2016
//  Copyright (c) Ordnance Survey. All rights reserved.
//

import Foundation
import OSJSON

@objc(OSGeometry)
public class Geometry: NSObject {

    // MARK: Properties
    public let crs: CRS
    public let type: String


    init(crs: CRS, type: String) {
        self.crs = crs
        self.type = type
        super.init()
    }


    //MARK: JSON initialiser
    public class func geometry(fromJSON json: JSON) -> Geometry? {
        guard let crsJSON = json.jsonForKey(Geometry.CrsKey),
            crs = CRS(json: crsJSON),
            type = json.stringValueForKey(Geometry.TypeKey)
            else {
                return nil
        }
        switch type {
        case "Polygon":
            guard let coordinates = json.arrayValueForKey(Geometry.CoordinatesKey) as? [[[Double]]] else {
                return nil
            }
            return Polygon(coordinates: coordinates.flatMap(lineStringFromArray), crs: crs, type: type)
        case "MultiPolygon":
            guard let coordinates = json.arrayValueForKey(Geometry.CoordinatesKey) as? [[[[Double]]]] else {
                return nil
            }
            return MultiPolygon(coordinates: coordinates.flatMap(lineStringArrayFromArray), crs: crs, type: type)
        case "Point":
            guard let coordinates = json.arrayValueForKey(Geometry.CoordinatesKey) as? [Double],
                coordinate = coordinateFromArray(coordinates) else {
                return nil
            }
            return Point(coordinates: coordinate, crs: crs, type: type)
        default:
            return nil
        }
    }
}

@objc(OSPolygon)
public class Polygon: Geometry {
    public let coordinates: [LineString]

    init(coordinates: [LineString], crs: CRS, type: String) {
        self.coordinates = coordinates
        super.init(crs: crs, type: type)
    }
}

@objc(OSMultiPolygon)
public class MultiPolygon: Geometry {
    public let coordinates: [[LineString]]

    init(coordinates: [[LineString]], crs: CRS, type: String) {
        self.coordinates = coordinates
        super.init(crs: crs, type: type)
    }
}

@objc(OSPoint)
public class Point: Geometry {
    public let coordinates: Coordinate

    init(coordinates: Coordinate, crs: CRS, type: String) {
        self.coordinates = coordinates
        super.init(crs: crs, type: type)
    }
}

@objc(OSCoordinate)
public class Coordinate: NSObject {
    public let x: Double
    public let y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
        super.init()
    }
}

@objc(OSLineString)
public class LineString: NSObject {
    public let coordinates: [Coordinate]

    init(coordinates: [Coordinate]) {
        self.coordinates = coordinates
        super.init()
    }
}

private func lineStringArrayFromArray(values: [[[Double]]]) -> [LineString]? {
    return values.flatMap(lineStringFromArray)
}

private func lineStringFromArray(values: [[Double]]) -> LineString? {
    return LineString(coordinates: values.flatMap(coordinateFromArray))
}

private func coordinateFromArray(values: [Double]) -> Coordinate? {
    guard values.count == 2 else {
        return nil
    }
    return Coordinate(x: values.first!, y: values.last!)
}

extension Geometry {
    // MARK: Declaration for string constants to be used to decode and also serialize.
    @nonobjc internal static let CoordinatesKey: String = "coordinates"
    @nonobjc internal static let CrsKey: String = "crs"
    @nonobjc internal static let TypeKey: String = "type"
    
}
