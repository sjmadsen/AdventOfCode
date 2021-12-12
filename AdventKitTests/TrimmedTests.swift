//
//  TrimmedTests.swift
//  AdventKitTests
//
//  Created by Steve Madsen on 12/12/21.
//

import XCTest
import Nimble
import AdventKit

class TrimmedTests: XCTestCase {
    func testTrimmed() {
        expect("".trimmed) == ""
        expect("foo".trimmed) == "foo"
        expect(" foo".trimmed) == "foo"
        expect("foo ".trimmed) == "foo"
        expect("foo bar".trimmed) == "foo bar"
        expect("\n\t foo \n\t".trimmed) == "foo"
    }
}
