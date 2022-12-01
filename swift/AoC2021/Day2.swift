//
//  Day2.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit

class Day2: Day {
    let sample = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""
    let input: [String]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day2", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map(String.init)
        super.init()
    }

    override func compute() async {
        var position = 0
        var depth = 0
        input.forEach {
            let parts = $0.split(separator: " ")
            switch (parts[0], Int(parts[1])!) {
            case ("forward", let n): position += n
            case ("down", let n):    depth += n
            case ("up", let n):      depth -= n
            default:                 break
            }
        }

        let p1 = position * depth
        await MainActor.run {
            part1 = String(p1)
        }

        position = 0
        depth = 0
        var aim = 0
        input.forEach {
            let parts = $0.split(separator: " ")
            switch (parts[0], Int(parts[1])!) {
            case ("forward", let n):
                position += n
                depth += aim * n
            case ("down", let n): aim += n
            case ("up", let n):   aim -= n
            default:              break
            }
        }
        let p2 = position * depth
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
