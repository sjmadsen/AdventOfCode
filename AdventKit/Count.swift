//
//  Count.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/13/21.
//

import Foundation

public extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }
}
