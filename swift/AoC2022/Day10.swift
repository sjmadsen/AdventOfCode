//
//  Day10.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/10/22.
//

import Foundation

class Day10: Day {
    let input: [[String]]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day10", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                String($0)
                    .split(separator: " ")
                    .map(String.init)
            }
        super.init()
    }

    func simulate(_ instructions: [[String]]) -> [Int] {
        var x = 1
        var xs: [Int] = []
        for instruction in instructions {
            if xs.count == 240 {
                break
            }
            xs.append(x)
            switch instruction[0] {
            case "noop":
                break
            case "addx":
                xs.append(x)
                x += Int(instruction[1])!
            default: break
            }
        }
        return xs
    }

    func drawScreen(_ signal: [Int]) {
        var s = ""
        for (offset, value) in signal.enumerated() {
            let offset = offset % 40
            if offset == 0 {
                s += "\n"
            }
            s += abs(value - offset) <= 1 ? "#" : "."
        }
        print(s)
    }

    override func compute() async {
        let xs = simulate(input)
        let part1_result =
        xs[19] * 20 +
        xs[59] * 60 +
        xs[99] * 100 +
        xs[139] * 140 +
        xs[179] * 180 +
        xs[219] * 220
        await MainActor.run {
            part1 = String(part1_result)
        }

        drawScreen(xs)

        let part2_result = 0
        await MainActor.run {
            part2 = String(part2_result)
        }
    }

    let sample = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""
}
