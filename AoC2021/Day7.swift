//
//  Day7.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI

class Day7: Day {
    let sample = "16,1,2,0,4,2,7,1,2,14"
    let input: [Int]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day1", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")[0]
            .split(separator: ",")
            .map { Int($0)! }
        super.init()
    }

    override func compute() async {
        let p1 = (0...(input.max()!))
            .map { position in
                input.reduce(0) { $0 + abs($1 - position) }
            }
            .min()!
        await MainActor.run {
            part1 = String(p1)
        }

        let p2 = (0...(input.max()!))
            .map { position in
                input.reduce(0) { $0 + (0...abs($1 - position)).reduce(0, +) }
            }
            .min()!
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
