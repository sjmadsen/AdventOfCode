//
//  CountTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/13/21.
//

import XCTest
import Nimble
import AdventKit

class CountTests: XCTestCase {
    func testCountWhere() {
        expect([1,2,3,4,5,6].count { $0.isMultiple(of: 2) }) == 3
        expect([Int]().count { _ in true }) == 0
    }
}
