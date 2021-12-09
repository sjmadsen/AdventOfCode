//
//  PivotTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/3/21.
//

import XCTest
import Nimble
import AdventKit

class PivotTests: XCTestCase {
    func testPivoted() {
        expect([[1,2,3], [4,5,6], [7,8,9]].pivoted()) == [[1,4,7], [2,5,8], [3,6,9]]
        expect([[1,2,3], [4,5,6]].pivoted()) == [[1,4], [2,5], [3,6]]
        expect([[1,2,3]].pivoted()) == [[1], [2], [3]]

        var empty: [[Character]] = []
        expect(empty.pivoted()) == []
        empty = [[]]
        expect(empty.pivoted()) == []

        expect([[1], [2,3]].pivoted()).to(throwAssertion())
    }
}
