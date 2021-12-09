//
//  StatisticsTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/7/21.
//

import XCTest
import Nimble
import AdventKit

class StatisticsTests: XCTestCase {
    func testMode() {
        expect([16,1,2,0,4,2,7,1,2,14].mode()) == [2]
        expect([1,1,2,2].mode().sorted()) == [1,2]
        expect([Int]().mode()) == []
    }
}
