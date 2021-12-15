//
//  Point.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/15/21.
//

import Foundation

@frozen
public struct Point: Equatable, Hashable {
    public let x, y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    @inlinable
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
