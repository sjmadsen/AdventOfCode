//
//  Day24.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/24/22.
//

import Foundation
import AdventKit

class Day24: Day {
    let sample = """
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
"""

    struct Blizzard: Equatable, Hashable {
        let position: Point
        let moving: Point

        func move(_ bounds: Bounds) -> Blizzard {
            var position = position + moving
            if !position.within(bounds) {
                if position.x < bounds.min.x {
                    position.x = bounds.max.x
                } else if position.x > bounds.max.x {
                    position.x = bounds.min.x
                }
                if position.y < bounds.min.y {
                    position.y = bounds.max.y
                } else if position.y > bounds.max.y {
                    position.y = bounds.min.y
                }
            }
            return Blizzard(position: position, moving: moving)
        }
    }

    let blizzards: Set<Blizzard>
    let start: Point
    let goal: Point
    let valley: Bounds

    override init() {
        let lines =
        try! String(contentsOf: Bundle.main.url(forResource: "day24", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map(Array.init)
        valley = Bounds(min: Point(x: 1, y: 1), max: Point(x: lines[1].count - 2, y: lines.count - 2))
        start = Point(x: lines[0].firstIndex(of: ".")!, y: 0)
        goal = Point(x: lines.last!.firstIndex(of: ".")!, y: lines.count - 1)
        blizzards = Set(
            lines.enumerated()
                .flatMap { y, line in
                    line.enumerated()
                        .compactMap { x, mark in
                            switch mark {
                            case "^": return Blizzard(position: Point(x: x, y: y), moving: Point(x: 0, y: -1))
                            case "v": return Blizzard(position: Point(x: x, y: y), moving: Point(x: 0, y: 1))
                            case "<": return Blizzard(position: Point(x: x, y: y), moving: Point(x: -1, y: 0))
                            case ">": return Blizzard(position: Point(x: x, y: y), moving: Point(x: 1, y: 0))
                            default:  return nil
                            }
                        }
                }
        )
        super.init()
    }

    func shortestPath(blizzards: Set<Blizzard>, start: Point, goal: Point) -> (Int, Set<Blizzard>) {
        var queue = Set([start])
        var blizzards = blizzards
        for minute in 0... {
            var nextQueue = Set<Point>()
            if queue.contains(goal) {
                return (minute, blizzards)
            }
            blizzards = Set(blizzards.map { $0.move(valley) })
            for position in queue {
                for possible in possibleMoves(position: position, blizzards: blizzards, bounds: valley, goal: goal) {
                    nextQueue.insert(possible)
                }
                if !blizzards.contains(where: { $0.position == position }) {
                    nextQueue.insert(position)
                }
            }
            queue = nextQueue
        }
        return (0, blizzards)
    }

    func possibleMoves(position: Point, blizzards: Set<Blizzard>, bounds: Bounds, goal: Point) -> [Point] {
        var possible = [Point]()
        var newPosition = position + Point(x: 0, y: -1)
        if newPosition == goal || newPosition.within(bounds) && !blizzards.contains(where: { $0.position == newPosition }) {
            possible.append(newPosition)
        }
        newPosition = position + Point(x: 0, y: 1)
        if newPosition == goal || (newPosition.within(bounds) && !blizzards.contains(where: { $0.position == newPosition })) {
            possible.append(newPosition)
        }
        newPosition = position + Point(x: -1, y: 0)
        if newPosition.within(bounds) && !blizzards.contains(where: { $0.position == newPosition }) {
            possible.append(newPosition)
        }
        newPosition = position + Point(x: 1, y: 0)
        if newPosition.within(bounds) && !blizzards.contains(where: { $0.position == newPosition }) {
            possible.append(newPosition)
        }
        return possible
    }

    func printMap(blizzards: Set<Blizzard>, bounds: Bounds) {
        for y in 0...bounds.max.y + 1 {
            var line = ""
            for x in 0...bounds.max.x + 1 {
                let p = Point(x: x, y: y)
                if p.within(bounds) {
                    let count = blizzards.count { $0.position == p }
                    if count == 0 {
                        line += "."
                    } else if count == 1, let blizzard = blizzards.first(where: { $0.position == p }) {
                        switch blizzard.moving {
                        case Point(x: 0, y: -1): line += "^"
                        case Point(x: 0, y: 1): line += "v"
                        case Point(x: -1, y: 0): line += "<"
                        case Point(x: 1, y: 0): line += ">"
                        default:  break
                        }
                    } else {
                        line += "\(count)"
                    }
                } else {
                    line += p == start || p == goal ? "." : "#"
                }
            }
            print(line)
        }
    }

    override func compute() async {
        print(valley)
        let trip1 = shortestPath(blizzards: blizzards, start: start, goal: goal)
        let part1_result = trip1.0
        await MainActor.run {
            part1 = String(part1_result)
        }

        let backtrack = shortestPath(blizzards: trip1.1, start: goal, goal: start)
        let trip2 = shortestPath(blizzards: backtrack.1, start: start, goal: goal)
        let part2_result = trip1.0 + backtrack.0 + trip2.0
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}

struct Bounds {
    let min: Point
    let max: Point
}

private extension Point {
    func within(_ b: Bounds) -> Bool {
        (b.min.x...b.max.x).contains(x) && (b.min.y...b.max.y).contains(y)
    }
}
