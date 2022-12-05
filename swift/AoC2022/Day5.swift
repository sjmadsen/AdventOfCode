//
//  Day5.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/5/22.
//

import Foundation

class Day5: Day {
    let sample = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""

    var stacks = [[String]]()
    let instructions: [String]

    override init() {
        var input =
        try! String(contentsOf: Bundle.main.url(forResource: "day5", withExtension: "input")!)
//        sample
            .split(substring: "\n")
            .split(separator: "")
        instructions = input[1].map(String.init)
        let numberOfStacks = Int(input[0].popLast()!.split(separator: " ").last!)!
        stacks = [[String]](repeating: [], count: numberOfStacks)
        for line in input[0] {
            let line = Array(line)
            var index = 1
            while index < line.count {
                let crate = line[index]
                if crate != " " {
                    stacks[(index - 1) / 4].insert(String(crate), at: 0)
                }
                index += 4
            }
        }
        super.init()
    }

    override func compute() async {
        var newStacks = stacks
        for line in instructions {
            let numbers = line.split(separator: " ")
                .compactMap { Int($0) }
            let toMove = numbers[0]
            let from = numbers[1] - 1
            let to = numbers[2] - 1
            for _ in 0..<toMove {
                let crate = newStacks[from].popLast()!
                newStacks[to].append(crate)
            }
        }
        let part1_result = newStacks.reduce("") {
            $0.appending($1.last!)
        }
        await MainActor.run {
            part1 = part1_result
        }

        newStacks = stacks
        for line in instructions {
            let numbers = line.split(separator: " ")
                .compactMap { Int($0) }
            let toMove = numbers[0]
            let from = numbers[1] - 1
            let to = numbers[2] - 1
            let crates = newStacks[from].suffix(toMove)
            newStacks[from].removeLast(toMove)
            newStacks[to].append(contentsOf: crates)
        }
        let part2_result = newStacks.reduce("") {
            $0.appending($1.last!)
        }
        await MainActor.run {
            part2 = part2_result
        }
    }
}
