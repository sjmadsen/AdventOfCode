//
//  RangeTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/15/22.
//

import XCTest
import Nimble
import AdventKit

final class RangeTests: XCTestCase {
    func testSubtracting() {
        expect((0...10).subtracting(11...12)) == [0...10]
        expect((0...10).subtracting(9...10)) == [0...8]
        expect((0...10).subtracting(0...1)) == [2...10]
        expect((0...10).subtracting(5...6)) == [0...4, 7...10]
        expect((0...10).subtracting(-1...11)) == []
    }
}
