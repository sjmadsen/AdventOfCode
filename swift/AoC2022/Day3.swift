//
//  Day3.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/3/22.
//


import SwiftUI
import Algorithms
import AdventKit

class Day3: Day {
    let sample = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

    let input: [String]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day3", withExtension: "input")!)
//        sample
            .trimmed
            .split(substring: "\n")
            .map(String.init)
        super.init()
    }

    override func compute() async {
        let alphabet = Array("-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let part1_result = input
            .map {
                let rucksack = Array($0)
                let first = Set(rucksack[..<(rucksack.count / 2)])
                let second = Set(rucksack[(rucksack.count / 2)...])
                let common = first.intersection(second)
                return alphabet.firstIndex(of: common.first!)!
            }
            .reduce(0, +)

        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = input
            .chunks(ofCount: 3)
            .map {
                var chunk = $0
                let initial = Set(chunk.removeFirst())
                let common = chunk.reduce(initial) {
                    $0.intersection(Set($1))
                }
                return alphabet.firstIndex(of: common.first!)!
            }
            .reduce(0, +)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
