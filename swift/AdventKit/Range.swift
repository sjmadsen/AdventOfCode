//
//  Range.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/15/22.
//

import Foundation

public extension ClosedRange where Bound: BinaryInteger {
    func subtracting(_ other: ClosedRange) -> [ClosedRange] {
        guard overlaps(other) else { return [self] }
        if lowerBound >= other.lowerBound, upperBound <= other.upperBound {
            return []
        } else if contains(other.lowerBound - 1), upperBound <= other.upperBound {
            return [lowerBound...(other.lowerBound - 1)]
        } else if contains(other.upperBound + 1), lowerBound >= other.lowerBound {
            return [(other.upperBound + 1)...upperBound]
        } else {
            return [lowerBound...(other.lowerBound - 1), (other.upperBound + 1)...upperBound]
        }
    }
}
