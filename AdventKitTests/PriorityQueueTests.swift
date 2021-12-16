//
//  PriorityQueueTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/16/21.
//

import XCTest
import Nimble
import AdventKit

class PriorityQueueTests: XCTestCase {
    func testInitializeByArrayLiteral() {
        expect(PriorityQueue([1, 2, 3]).map { $0 }) == [1, 2, 3]
        expect(PriorityQueue([3, 2, 1]).map { $0 }) == [1, 2, 3]
    }

    func testInitializeWithNotComparable() {
        struct S {
            let value: Int
        }

        expect(PriorityQueue([S(value: 1), S(value: 2), S(value: 3)], compare: { $0.value < $1.value }).map(\.value)) == [1, 2, 3]
        expect(PriorityQueue([S(value: 1), S(value: 2), S(value: 3)], compare: { $0.value > $1.value }).map(\.value)) == [3, 2, 1]
    }

    func testInsert() {
        var queue = PriorityQueue([10, 20, 30])
        queue.insert(25)
        expect(queue.map { $0 }) == [10, 20, 25, 30]
    }

    func testRemove() {
        var queue = PriorityQueue<Int>()
        expect(queue.remove()).to(beNil())

        queue.insert(1)
        expect(queue.remove()) == 1
        expect(queue.isEmpty) == true
    }
}
