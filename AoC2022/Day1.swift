//
//  Day1.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/1/22.
//

import SwiftUI
import AdventKit

class Day1: Day {
    let sample = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

    let input: [[Int]]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day1", withExtension: "input")!)
            .trimmed
            .split(substring: "\n\n")
            .map {
                String($0)
                    .split(substring: "\n")
                    .map { Int($0)! }
            }
        super.init()
    }

    override func compute() async {
        let caloriesPerElf = input
            .map { $0.reduce(0, +) }

        await MainActor.run {
            part1 = String(
                caloriesPerElf.max()!
            )
        }

        await MainActor.run {
            part2 = String(
                caloriesPerElf
                    .sorted()
                    .suffix(3)
                    .reduce(0, +)
            )
        }
    }
}
