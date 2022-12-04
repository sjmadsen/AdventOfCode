//
//  Day4.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/4/22.
//

import Foundation
import Algorithms
import AdventKit

class Day4: Day {
    let sample = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

    let input: [(ClosedRange<Int>, ClosedRange<Int>)]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day4", withExtension: "input")!)
//        sample
            .trimmed
            .split(substring: "\n")
            .map {
                let ranges = String($0).split(substring: ",")
                    .map {
                        let range = String($0).split(substring: "-")
                        return Int(range[0])!...Int(range[1])!
                    }
                return (ranges[0], ranges[1])
            }
        super.init()
    }

    override func compute() async {
        let part1_result = input
            .count {
                ($0.0.contains($0.1.lowerBound) && $0.0.contains($0.1.upperBound))
                || ($0.1.contains($0.0.lowerBound) && $0.1.contains($0.0.upperBound))
            }
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = input
            .count { $0.0.overlaps($0.1) || $0.1.overlaps($0.0) }
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
