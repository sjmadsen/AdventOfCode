//: [Previous](@previous)

import Foundation
import Algorithms
import AdventKit

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!)
    .trimmed
    .split(separator: "\n")

let connections = input
    .reduce([String: [String]]()) {
        var connections = $0
        let ends = $1.split(separator: "-").map(String.init)
        if ends[1] != "start" && ends[0] != "end" {
            connections[ends[0], default: []].append(ends[1])
        }
        if ends[0] != "start" && ends[1] != "end" {
            connections[ends[1], default: []].append(ends[0])
        }
        return connections
    }

// Part 1
func search(next cave: String, path: [String]) -> [[String]]? {
    guard cave != "end" else { return [path + ["end"]] }
    guard cave.uppercased() == cave || !path.contains(cave) else { return nil }
    return connections[cave]?
        .compactMap {
            search(next: $0, path: path + [cave])
        }
        .reduce([], +)
}

connections["start"]!
    .compactMap {
        search(next: $0, path: ["start"])
    }
    .reduce(0) {
        $0 + $1.count
    }

// Part 2
func search2(next cave: String, path: [String], visited: [String: Int] = [:]) -> [[String]]? {
    func visitCave() -> Bool {
        guard visited[cave] != nil, cave.uppercased() != cave else { return true }
        return visited
            .filter { $0.key.lowercased() == $0.key && $0.value == 2 }
            .isEmpty
    }

    guard cave != "end" else { return [path + ["end"]] }
    guard visitCave() else { return nil }
    return connections[cave]?
        .compactMap {
            var visited = visited
            visited[cave, default: 0] += 1
            return search2(next: $0, path: path + [cave], visited: visited)
        }
        .reduce([], +)
}

connections["start"]!
    .compactMap {
        search2(next: $0, path: ["start"])
    }
    .reduce(0) {
        $0 + $1.count
    }

//: [Next](@next)
