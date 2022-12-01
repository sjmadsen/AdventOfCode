//
//  Day9.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit

class Day9: Day {
    let sample = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""
    let input: [[Int]]
    let maxX: Int
    let maxY: Int

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day9", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map { $0.map { Int(String($0))! } }
        maxX = input[0].count
        maxY = input.count
        super.init()
    }

    override func compute() async {
        await MainActor.run {
            part1 = String(lowPoints.reduce(0) { $0 + input[$1.y][$1.x] } + lowPoints.count)
        }

        await MainActor.run {
            part2 = String(lowPoints
                            .map { basinSize(input, x: $0.x, y: $0.y) }
                            .sorted() { $1 < $0 }
                            .prefix(3)
                            .reduce(1, *)
            )
        }
    }

    lazy var lowPoints: [Point] = {
        var lowPoints = [Point]()
        for y in 0..<maxY {
            for x in 0..<maxX {
                if isLowPoint(input, x: x, y: y) {
                    lowPoints.append(Point(x: x, y: y))
                }
            }
        }
        return lowPoints
    }()

    func isLowPoint(_ input: [[Int]], x: Int, y: Int) -> Bool {
        let maxX = input[0].count
        let maxY = input.count
        let value = input[y][x]
        if (x == 0 || input[y][x - 1] > value)
            && (x == maxX - 1 || input[y][x + 1] > value)
            && (y == 0 || input[y - 1][x] > value)
            && (y == maxY - 1 || input[y + 1][x] > value) {
            return true
        }
        return false
    }

    func basinSize(_ input: [[Int]], x: Int, y: Int) -> Int {
        func recurse(x: Int, y: Int, basin: inout Set<Point>) {
            if x >= 0 && x < maxX && y >= 0 && y < maxY && input[y][x] != 9 && !basin.contains(Point(x: x, y: y)) {
                basin.insert(Point(x: x, y: y))
                recurse(x: x - 1, y: y, basin: &basin)
                recurse(x: x + 1, y: y, basin: &basin)
                recurse(x: x, y: y - 1, basin: &basin)
                recurse(x: x, y: y + 1, basin: &basin)
            }
        }

        var basin = Set<Point>()
        recurse(x: x, y: y, basin: &basin)
        return basin.count
    }
}
