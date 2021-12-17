//
//  Day11.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day11: Day {
    let sample = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

    let input: [[Int]]

    override init() {
        input = 
            try! String(contentsOf: Bundle.main.url(forResource: "day11", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map { $0.map { Int(String($0))! } }
        super.init()
    }

    override func compute() async {
        func flashes(octopi: [[Int]]) -> Set<Point> {
            product(0..<octopi[0].count, 0..<octopi.count)
                .reduce(Set<Point>()) {
                    if octopi[$1.1][$1.0] > 9 {
                        return $0.union([Point(x: $1.0, y: $1.1)])
                    } else {
                        return $0
                    }
                }
        }

        func simulate(octopi: [[Int]]) -> [[Int]] {
            var step = octopi
            for (x, y) in product(0..<step[0].count, 0..<step.count) {
                step[y][x] += 1
            }

            var flashed = Set<Point>()
            var newFlashes = flashes(octopi: step)
            while !newFlashes.isEmpty {
                newFlashes.forEach {
                    for (x, y) in product($0.x - 1...$0.x + 1, $0.y - 1...$0.y + 1) {
                        if x >= 0 && x < step[0].count, y >= 0 && y < step.count {
                            step[y][x] += 1
                        }
                    }
                }
                flashed.formUnion(newFlashes)
                newFlashes = flashes(octopi: step).subtracting(flashed)
            }

            for point in flashed {
                step[point.y][point.x] = 0
            }
            return step
        }

        var step = input
        let p1 = (1...100)
            .map { _ in
                step = simulate(octopi: step)
                return step
                    .map {
                        $0.filter { $0 == 0 }.count
                    }
                    .reduce(0, +)
            }
            .reduce(0, +)
        await MainActor.run {
            part1 = String(p1)
        }

        step = input
        var stepNumber = 0
        repeat {
            step = simulate(octopi: step)
            stepNumber += 1
        } while !step.allSatisfy { $0.allSatisfy { $0 == 0 } }
        let p2 = stepNumber
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
