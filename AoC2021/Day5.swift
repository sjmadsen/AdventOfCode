//
//  Day5.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI

class Day5: Day {
    let sample = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""
    let input: [String]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day5", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .filter { !$0.isEmpty }
            .map(String.init)
        super.init()
    }

    override func compute() async {
        let segments = input.map { line -> Segment in
            let coordinates = String(line).split(substring: " -> ")
                .flatMap {
                    $0.split(separator: ",")
                        .map { Int($0)! }
                }
            return Segment(x1: coordinates[0], y1: coordinates[1], x2: coordinates[2], y2: coordinates[3])
        }

        var grid = [String: Int]()
        for segment in segments {
            switch segment.direction {
            case .horizontal:
                let (x1, x2) = [segment.x1, segment.x2].minAndMax()!
                for x in x1...x2 {
                    grid["\(x),\(segment.y1)", default: 0] += 1
                }
            case .vertical:
                let (y1, y2) = [segment.y1, segment.y2].minAndMax()!
                for y in y1...y2 {
                    grid["\(segment.x1),\(y)", default: 0] += 1
                }
            case .diagonal:
                break
            }
        }

        let p1 = grid.keys.reduce(0) {
            $0 + (grid[$1]! > 1 ? 1 : 0)
        }
        await MainActor.run {
            part1 = String(p1)
        }

        grid = [:]
        for segment in segments {
            switch segment.direction {
            case .horizontal:
                let (x1, x2) = [segment.x1, segment.x2].minAndMax()!
                for x in x1...x2 {
                    grid["\(x),\(segment.y1)", default: 0] += 1
                }
            case .vertical:
                let (y1, y2) = [segment.y1, segment.y2].minAndMax()!
                for y in y1...y2 {
                    grid["\(segment.x1),\(y)", default: 0] += 1
                }
            case .diagonal:
                let xs = segment.x1 < segment.x2 ? Array(segment.x1...segment.x2) : (segment.x2...segment.x1).reversed()
                let ys = segment.y1 < segment.y2 ? Array(segment.y1...segment.y2) : (segment.y2...segment.y1).reversed()
                for position in zip(xs, ys) {
                    grid["\(position.0),\(position.1)", default: 0] += 1
                }
            }
        }
        let p2 = grid.keys.reduce(0) {
            $0 + (grid[$1]! > 1 ? 1 : 0)
        }

        await MainActor.run {
            part2 = String(p2)
        }
    }
}

struct Segment {
    enum Direction {
        case horizontal
        case vertical
        case diagonal
    }

    let x1, y1, x2, y2: Int

    var direction: Direction {
        if x1 == x2 {
            return .vertical
        } else if y1 == y2 {
            return .horizontal
        } else {
            return .diagonal
        }
    }
}
