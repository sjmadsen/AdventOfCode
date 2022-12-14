//
//  Day14.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/14/22.
//

import Foundation
import Algorithms
import AdventKit

class Day14: Day {
    let sample = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

    let input: [(Point, Point)]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day14", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .flatMap {
                String($0)
                    .split(substring: " -> ")
                    .map {
                        let xy = String($0)
                            .split(separator: ",")
                            .map { Int(String($0))! }
                        return Point(x: xy[0], y: xy[1])
                    }
                    .windows(ofCount: 2)
                    .map {
                        ($0.first!, $0.last!)
                    }
            }
        super.init()
    }

    func constructCave() -> Set<Point> {
        var cave = Set<Point>()
        for (p1, p2) in input {
            rockLine(&cave, p1, p2)
        }
        return cave
    }

    func rockLine(_ cave: inout Set<Point>, _ p1: Point, _ p2: Point) {
        let increment: Point
        if p1.x == p2.x {
            increment = Point(x: 0, y: abs(p2.y - p1.y) / (p2.y - p1.y))
        } else {
            increment = Point(x: abs(p2.x - p1.x) / (p2.x - p1.x), y: 0)
        }
        var p = p1
        cave.insert(p)
        while p != p2 {
            p += increment
            cave.insert(p)
        }
    }

    func dropSand(_ cave: inout Set<Point>, abyss: Int) -> Bool {
        var position = Point(x: 500, y: 0)
        let below = Point(x: 0, y: 1)
        let belowLeft = Point(x: -1, y: 1)
        let belowRight = Point(x: 1, y: 1)
        while true {
            if position.y == abyss {
                return false
            }
            if !cave.contains(position + below) {
                position += below
            } else if !cave.contains(position + belowLeft) {
                position += belowLeft
            } else if !cave.contains(position + belowRight) {
                position += belowRight
            } else {
                cave.insert(position)
                return true
            }
        }
    }

    func dropSand(_ cave: inout Set<Point>, floor: Int) -> Bool {
        var position = Point(x: 500, y: 0)
        let below = Point(x: 0, y: 1)
        let belowLeft = Point(x: -1, y: 1)
        let belowRight = Point(x: 1, y: 1)
        while true {
            if position.y == floor - 1 {
                cave.insert(position)
                return true
            } else if !cave.contains(position + below) {
                position += below
            } else if !cave.contains(position + belowLeft) {
                position += belowLeft
            } else if !cave.contains(position + belowRight) {
                position += belowRight
            } else {
                cave.insert(position)
                return position != Point(x: 500, y: 0)
            }
        }
    }

    override func compute() async {
        var cave = constructCave()
        let abyss = cave
            .map(\.y)
            .max()!
        var grains = 0
        while true {
            if !dropSand(&cave, abyss: abyss) {
                break
            }
            grains += 1
        }
        let part1_result = grains
        await MainActor.run {
            part1 = String(part1_result)
        }

        cave = constructCave()
        grains = 0
        while true {
            if !dropSand(&cave, floor: abyss + 2) {
                break
            }
            grains += 1
        }
        let part2_result = grains + 1
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
