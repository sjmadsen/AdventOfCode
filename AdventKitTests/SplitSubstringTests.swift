//
//  SplitSubstringTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/6/21.
//

import XCTest
import Nimble
import AdventKit

class SplitSubstringTests: XCTestCase {
    func testSplitBySubstring() {
        expect("foo + bar + baz".split(substring: " + ")) == ["foo", "bar", "baz"]
        expect(" + bar + baz".split(substring: " + ")) == ["", "bar", "baz"]
        expect("foo + bar + ".split(substring: " + ")) == ["foo", "bar", ""]
        expect("foo + bar +".split(substring: " + ")) == ["foo", "bar +"]
        expect("".split(substring: " ")) == []
    }
}
