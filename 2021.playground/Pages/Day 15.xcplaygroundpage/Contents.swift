//: [Previous](@previous)

import Foundation
import AdventKit
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!)
    .trimmed
    .split(separator: "\n")
    .map { $0.map { Int(String($0))! } }

// Part 1
func distance(from a: Point, to b: Point) -> Float {
//    sqrtf(pow(Float(a.x - b.x), 2) + pow(Float(a.y - b.y), 2))
    // Returning 0 here makes A* behave like Dijkstra's algorithm, and it's faster
    0
}

// A* search algorithm
func findPath(graph: [[Int]], start: Point, goal: Point) -> [Point] {
    func reconstruct(from point: Point) -> [Point] {
        var path = [point]
        var current = point
        while cameFrom[current] != nil {
            current = cameFrom[current]!
            path.append(current)
        }
        return path.reversed()
    }
    func neighbors(of point: Point) -> [Point] {
        var points = [Point]()
        if point.x < graph[0].count - 1 {
            points.append(Point(x: point.x + 1, y: point.y))
        }
        if point.y < graph.count - 1 {
            points.append(Point(x: point.x, y: point.y + 1))
        }
        if point.y > 0 {
            points.append(Point(x: point.x, y: point.y - 1))
        }
        if point.x > 0 {
            points.append(Point(x: point.x - 1, y: point.y))
        }
        return points
    }

    var openSet = Set([start])
    var cameFrom = [Point: Point]()
    var gScore = [start: 0]
    var fScore = [start: distance(from: start, to: goal)]
    while !openSet.isEmpty {
        let current = openSet.min { fScore[$0, default: .infinity] < fScore[$1, default: .infinity] }!
        if current == goal {
            return reconstruct(from: current)
        }

        openSet.remove(current)
        for neighbor in neighbors(of: current) {
            let newGScore = gScore[current, default: .max] + graph[neighbor.y][neighbor.x]
            if newGScore < gScore[neighbor, default :.max] {
                cameFrom[neighbor] = current
                gScore[neighbor] = newGScore
                fScore[neighbor] = Float(newGScore) + distance(from: neighbor, to: goal)
                openSet.insert(neighbor)
            }
        }
    }
    return []
}

let path = findPath(graph: input, start: Point(x: 0, y: 0), goal: Point(x: input[0].count - 1, y: input.count - 1))
path[1...]
    .reduce(0) { $0 + input[$1.y][$1.x] }

// Part 2
let expanded =
    (0..<5).map { row in
        input.map { line in
                (0..<5).map { column -> [Int] in
                    let increment = column + row
                    return line.map { ($0 - 1 + increment) % 9 + 1 }
                }
                .joined()
                .map { $0 }
        }
    }
    .joined()
    .map { $0 }

// Note that this never completes in the playground with the full input data.
// Copy it into Dummy's main.swift and run it there.
let expandedPath = findPath(graph: expanded, start: Point(x: 0, y: 0), goal: Point(x: expanded[0].count - 1, y: expanded.count - 1))
expandedPath[1...]
    .reduce(0) { $0 + expanded[$1.y][$1.x] }

//: [Next](@next)
