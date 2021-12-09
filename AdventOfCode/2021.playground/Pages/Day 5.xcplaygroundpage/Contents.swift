//: [Previous](@previous)

import Foundation
import AdventKit
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n").filter { !$0.isEmpty }

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

let segments = input.map { line -> Segment in
    let coordinates = String(line).split(separator: " -> ")
        .flatMap {
            $0.split(separator: ",")
                .map { Int($0)! }
        }
    return Segment(x1: coordinates[0], y1: coordinates[1], x2: coordinates[2], y2: coordinates[3])
}

// Part 1
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

grid.keys.reduce(0) {
    $0 + (grid[$1]! > 1 ? 1 : 0)
}

// Part 2
grid = [String: Int]()
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

grid.keys.reduce(0) {
    $0 + (grid[$1]! > 1 ? 1 : 0)
}

//: [Next](@next)
