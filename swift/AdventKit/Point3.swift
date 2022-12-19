//
//  Point3.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/18/22.
//

import Foundation

@frozen
public struct Point3: Equatable, Hashable {
    public let x, y, z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Point3: AdditiveArithmetic {
    public static var zero: Point3 {
        Point3(x: 0, y: 0, z: 0)
    }

    public static func + (lhs: Point3, rhs: Point3) -> Point3 {
        Point3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func - (lhs: Point3, rhs: Point3) -> Point3 {
        Point3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}
