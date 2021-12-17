//
//  Day10.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day10: Day {
    let sample = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

    let input: [String]

    override init() {
        input = 
            try! String(contentsOf: Bundle.main.url(forResource: "day10", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map(String.init)
        super.init()
    }

    override func compute() async {
        let corruptedScore: [Character: Int] = [
            ")": 3,
            "]": 57,
            "}": 1197,
            ">": 25137
        ]

        let closing: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
        let p1 = input
            .compactMap {
                var stack = [Character]()
                for character in $0 {
                    switch character {
                    case "(", "[", "{", "<": stack.append(closing[character]!)
                    case ")", "]", "}", ">":
                        if stack.removeLast() != character {
                            return character
                        }
                    default: break
                    }
                }
                return nil
            }
            .map { corruptedScore[$0, default: 0] }
            .reduce(0, +)

        await MainActor.run {
            part1 = String(p1)
        }

        let incompleteScore: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]

        let p2 = input
            .compactMap { line -> String? in
                var stack = [Character]()
                for character in line {
                    switch character {
                    case "(", "[", "{", "<": stack.append(closing[character]!)
                    case ")", "]", "}", ">":
                        if stack.removeLast() != character {
                            return nil
                        }
                    default: break
                    }
                }
                return String(stack.reversed())
            }
            .map { (completion: String) -> Int in
                completion.reduce(0) {
                    $0 * 5 + incompleteScore[$1, default: 0]
                }
            }
            .median()

        await MainActor.run {
            part2 = String(p2)
        }
    }
}
