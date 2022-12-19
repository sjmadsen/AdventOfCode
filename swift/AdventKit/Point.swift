//
//  Point.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/15/21.
//

import Foundation

@frozen
public struct Point {
    public let x, y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func manhattanDistance(from other: Point) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }

    @inlinable
    public static func ~=<R: RangeExpression>(lhs: (R, R), rhs: Point) -> Bool where R.Bound == Int {
        lhs.0 ~= rhs.x && lhs.1 ~= rhs.y
    }
}

extension Point: Equatable {
    @inlinable
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Point: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Point: AdditiveArithmetic {
    public static var zero: Point {
        Point(x: 0, y: 0)
    }

    public static func + (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
