//
//  SplitSubstring.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/6/21.
//

import Foundation

public extension String {
    func split(separator: String) -> [String.SubSequence] {
        var parts = [String.SubSequence]()
        var rangeStart = startIndex
        var rangeEnd = rangeStart
        while rangeEnd < endIndex {
            if self[rangeEnd...].hasPrefix(separator) {
                parts.append(self[rangeStart..<rangeEnd])
                rangeStart = index(rangeEnd, offsetBy: separator.count)
            }
            rangeEnd = index(rangeEnd, offsetBy: 1)
        }
        parts.append(self[rangeStart...])

        return parts
    }
}
