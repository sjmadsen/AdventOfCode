//
//  Timed.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/15/21.
//

import Foundation

public func timed(closure: () -> Void) -> TimeInterval {
    let start = Date().timeIntervalSinceReferenceDate
    closure()
    return Date().timeIntervalSinceReferenceDate - start
}
