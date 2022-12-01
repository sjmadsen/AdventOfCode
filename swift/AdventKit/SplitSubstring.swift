//
//  SplitSubstring.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/6/21.
//

import Foundation

public extension StringProtocol {
    func split<S: StringProtocol>(substring: S) -> [Self.SubSequence] {
        guard !isEmpty else { return [] }
        var parts = type(of: [self[...startIndex]]).init()
        var rangeStart = startIndex
        var rangeEnd = rangeStart
        while rangeEnd < endIndex {
            if self[rangeEnd...].hasPrefix(substring) {
                parts.append(self[rangeStart..<rangeEnd])
                rangeStart = index(rangeEnd, offsetBy: substring.count)
            }
            rangeEnd = index(rangeEnd, offsetBy: 1)
        }
        parts.append(self[rangeStart...])

        return parts
    }
}
