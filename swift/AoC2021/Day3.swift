//
//  Day3.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit

class Day3: Day {
    let sample = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""
    let input: [[Character]]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day3", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map { $0.map { $0 } }
        super.init()
    }

    override func compute() async {
        let gamma = input
            .pivoted()
            .map { bits -> String in
                let set = NSCountedSet()
                bits.forEach { set.add(String($0)) }
                return set.count(for: "0") > set.count(for: "1") ? "0" : "1"
            }
            .joined()

        let epsilon = gamma
            .map {
                $0 == "0" ? "1" : "0"
            }
            .joined()

        let p1 = Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!
        await MainActor.run {
            part1 = String(p1)
        }

        func o2(list: Array<Array<Character>>, bit: Int) -> String {
            if list.count == 1 {
                return list[0].map { String($0) }.joined()
            }

            let set = NSCountedSet()
            list.forEach { set.add(String($0[bit])) }
            let keep: Character
            if set.count(for: "0") > set.count(for: "1") {
                keep = "0"
            } else {
                keep = "1"
            }
            return o2(list: list.filter { $0[bit] == keep }, bit: bit + 1)
        }

        func co2(list: Array<Array<Character>>, bit: Int) -> String {
            if list.count == 1 {
                return list[0].map { String($0) }.joined()
            }

            let set = NSCountedSet()
            list.forEach { set.add(String($0[bit])) }
            let keep: Character
            if set.count(for: "0") <= set.count(for: "1") {
                keep = "0"
            } else {
                keep = "1"
            }
            return co2(list: list.filter { $0[bit] == keep }, bit: bit + 1)
        }

        let o2Rating = o2(list: input, bit: 0)
        let co2Rating = co2(list: input, bit: 0)

        let p2 = Int(o2Rating, radix: 2)! * Int(co2Rating, radix: 2)!
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
