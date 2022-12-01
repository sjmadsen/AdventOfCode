//
//  Day14.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day14: Day {
    let sample = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

    let input: [[String]]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day14", withExtension: "input")!)
            .trimmed
            .split(separator: "\n", omittingEmptySubsequences: false)
            .split(separator: "")
            .map { $0.map(String.init) }
        super.init()
    }

    override func compute() async {
        let template = String(input[0][0])
        let rules = input[1]
            .reduce([String: String]()) {
                let mapping = $1.split(substring: " -> ")
                var rules = $0
                rules[String(mapping[0])] = String(mapping[1])
                return rules
            }

        func substitute(polymer: [String: Int]) -> [String: Int] {
            var newPolymer = polymer
            for (pair, insert) in rules where polymer[pair] != nil {
                newPolymer["\(pair[pair.startIndex])\(insert)", default: 0] += polymer[pair]!
                newPolymer["\(insert)\(pair[pair.index(pair.startIndex, offsetBy: 1)])", default: 0] += polymer[pair]!
                newPolymer[pair]! -= polymer[pair]!
            }
            return newPolymer
        }

        func counts(template: String, polymer: [String: Int]) -> [String: Int] {
            var counts = polymer
                .reduce([String: Int]()) {
                    var counts = $0
                    counts[String($1.key.prefix(1)), default: 0] += $1.value
                    return counts
                }
            counts[String(template.suffix(1)), default: 0] += 1
            return counts
        }

        let pairs = template
            .map { String($0) }
            .adjacentPairs()
            .reduce([String: Int]()) {
                var pairCount = $0
                pairCount["\($1.0)\($1.1)", default: 0] += 1
                return pairCount
            }

        let polymer =
        (1...10)
            .reduce(pairs) { polymer, _ in
                substitute(polymer: polymer)
            }
        var frequency = counts(template: template, polymer: polymer)
        var minMax = frequency.minAndMax { $0.value < $1.value }!
        let p1 = minMax.max.value - minMax.min.value
        await MainActor.run {
            part1 = String(p1)
        }

        let polymer40 =
        (1...40)
            .reduce(pairs) { polymer, _ in
                substitute(polymer: polymer)
            }
        frequency = counts(template: template, polymer: polymer40)
        minMax = frequency.minAndMax { $0.value < $1.value }!
        let p2 = minMax.max.value - minMax.min.value
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
