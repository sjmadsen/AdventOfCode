//
//  Day1.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day1: Day {
    let sample = """
199
200
208
210
200
207
240
269
260
263
"""

    let input: [Int]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day1", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map { Int($0)! }
        super.init()
    }

    override func compute() async {
        await MainActor.run {
            part1 = String(input.adjacentPairs().reduce(0) {
                $1.0 < $1.1 ? $0 + 1 : $0
            })
        }

        let increases = input.windows(ofCount: 3).map {
            $0.reduce(0, +)
        }.adjacentPairs().reduce(0) {
            $1.0 < $1.1 ? $0 + 1 : $0
        }
        await MainActor.run {
            part2 = String(increases)
        }
    }
}
