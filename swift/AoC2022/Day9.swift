//
//  Day9.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/9/22.
//

import Foundation

class Day9: Day {
    let sample = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

    let input: [(String, Int)]

    struct Point: Equatable, Hashable {
        var x, y: Int
    }

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day9", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                let parts = $0.split(separator: " ")
                return (String(parts[0]), Int(String(parts[1]))!)
            }
        super.init()
    }

    func simulate(_ knots: [Point]) -> Int {
        var knots = knots
        var visited = Set<Point>([knots.last!])
        for (direction, distance) in input {
            for _ in 0..<distance {
                switch direction {
                case "U": knots[0] = Point(x: knots[0].x, y: knots[0].y + 1)
                case "D": knots[0] = Point(x: knots[0].x, y: knots[0].y - 1)
                case "L": knots[0] = Point(x: knots[0].x - 1, y: knots[0].y)
                case "R": knots[0] = Point(x: knots[0].x + 1, y: knots[0].y)
                default: break
                }
                var following = 0
                for i in 1..<knots.count {
                    if abs(knots[i].x - knots[following].x) + abs(knots[i].y - knots[following].y) > 2 {
                        knots[i].x += abs(knots[following].x - knots[i].x) / (knots[following].x - knots[i].x)
                        knots[i].y += abs(knots[following].y - knots[i].y) / (knots[following].y - knots[i].y)
                    } else if abs(knots[i].x - knots[following].x) + abs(knots[i].y - knots[following].y) == 2 {
                        if knots[i].x - knots[following].x == 0 {
                            knots[i].y += abs(knots[following].y - knots[i].y) / (knots[following].y - knots[i].y)
                        } else if knots[i].y - knots[following].y == 0 {
                            knots[i].x += abs(knots[following].x - knots[i].x) / (knots[following].x - knots[i].x)
                        }
                    }
                    following = i
                }
                visited.insert(knots.last!)
            }
        }
        return visited.count
    }

    override func compute() async {
        var knots = [Point](repeating: Point(x: 0, y: 0), count: 2)
        let part1_result = simulate(knots)
        await MainActor.run {
            part1 = String(part1_result)
        }

        knots = [Point](repeating: Point(x: 0, y: 0), count: 10)
        let part2_result = simulate(knots)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
