//
//  Statistics.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/7/21.
//

import Foundation

public extension Collection where Element: Comparable {
    func median() -> Element {
        let sorted = sorted()
        return sorted[sorted.count / 2]
    }
}

public extension Collection where Element: Numeric & Hashable {
    func mode() -> [Element] {
        var counts = [Element: Int]()
        self.forEach { counts[$0, default: 0] += 1 }
        let sorted = counts.keys.sorted(by: { counts[$0]! > counts[$1]! })
        return sorted.prefix { counts[$0]! == counts[sorted[0]]! }
    }
}
