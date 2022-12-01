//
//  PointTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/17/21.
//

import XCTest
import Nimble
import AdventKit

class PointTests: XCTestCase {
    func testAddition() {
        expect(Point(x: 1, y: 2) + Point(x: 3, y: 4)) == Point(x: 4, y: 6)
        expect(Point(x: 1, y: 2) - Point(x: 3, y: 4)) == Point(x: -2, y: -2)
    }

    func testContainment() {
        let range = (0...5, 5...10)
        expect(range ~= Point(x: 0, y: 0)) == false
        expect(range ~= Point(x: 5, y: 5)) == true
        expect(range ~= Point(x: 6, y: 5)) == false
    }
}
