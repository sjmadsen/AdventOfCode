//
//  Day12.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/12/22.
//

import Foundation
import AdventKit

class Day12: Day {
    let sample = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

    var input: [[Int]]
    let start: Point
    let goal: Point

    override init() {
        var start = Point()
        var goal = Point()
        let input =
        try! String(contentsOf: Bundle.main.url(forResource: "day12", withExtension: "input")!)
//        sample
            .trimmed
            .split(substring: "\n")
            .map(String.init)
        for y in 0..<input.count {
            if let x = Array(input[y]).firstIndex(of: "S") {
                start = Point(x: x, y: y)
            }
            if let x = Array(input[y]).firstIndex(of: "E") {
                goal = Point(x: x, y: y)
            }
        }
        self.start = start
        self.goal = goal

        self.input = input
            .map {
                String($0)
                    .map {
                        switch $0 {
                        case "S": return 0
                        case "E": return 25
                        default: return Int($0.asciiValue! - Character("a").asciiValue!)
                        }
                    }
            }
        super.init()
    }

    func reconstructPath(_ cameFrom: [Point: Point], _ current: Point) -> [Point] {
        var path = [Point]()
        var current: Point? = current
        while current != nil {
            path.insert(current!, at: 0)
            current = cameFrom[current!]
        }
        return path
    }

    func neighbors(_ point: Point) -> [Point] {
        var points = [Point]()
        if point.x > 0 {
            points.append(Point(x: point.x - 1, y: point.y))
        }
        if point.x < input[0].count - 1 {
            points.append(Point(x: point.x + 1, y: point.y))
        }
        if point.y > 0 {
            points.append(Point(x: point.x, y: point.y - 1))
        }
        if point.y < input.count - 1 {
            points.append(Point(x: point.x, y: point.y + 1))
        }
        return points
    }

    func cost(_ from: Point, _ to: Point) -> Double {
        if input[to.y][to.x] <= input[from.y][from.x] + 1 {
            return 1
        } else {
            return .infinity
        }
    }

    func aStar(_ start: Point, _ goal: Point, _ h: (Point) -> Double) -> [Point] {
        var cameFrom = [Point: Point]()
        var gScore = [start: 0.0]
        var fScore = [start: h(start)]
        var openSet = PriorityQueue<Point>([start], compare: { fScore[$0, default: .infinity] < fScore[$1, default: .infinity] })

        while let current = openSet.remove() {
            if current == goal {
                return reconstructPath(cameFrom, current)
            }
            for neighbor in neighbors(current) {
                let score = gScore[current, default: .infinity] + cost(current, neighbor)
                if score < gScore[neighbor, default: .infinity] {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = score
                    fScore[neighbor] = score + h(neighbor)
                    if !openSet.contains(neighbor) {
                        openSet.insert(neighbor)
                    }
                }
            }
        }
        return []
    }

    func heuristic(_ p: Point) -> Double {
        sqrt(pow(Double(goal.x - p.x), 2) + pow(Double(goal.y - p.y), 2))
    }

    override func compute() async {
        let part1_result = aStar(start, goal, heuristic).count - 1
        await MainActor.run {
            part1 = String(part1_result)
        }

        var starts = [Point]()
        for y in 0..<input.count {
            for x in 0..<input[y].count {
                if input[y][x] == 0 {
                    starts.append(Point(x: x, y: y))
                }
            }
        }
        let part2_result = starts
            .map { aStar($0, goal, heuristic).count - 1 }
            .filter { $0 > 0 }
            .min()!
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
