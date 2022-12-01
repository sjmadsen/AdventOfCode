//
//  Day12.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day12: Day {
    let sample = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

    let input: [String]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day12", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map(String.init)
        super.init()
    }

    override func compute() async {
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

        func search(next cave: String, path: [String]) -> [[String]]? {
            guard cave != "end" else { return [path + ["end"]] }
            guard cave.uppercased() == cave || !path.contains(cave) else { return nil }
            return connections[cave]?
                .compactMap {
                    search(next: $0, path: path + [cave])
                }
                .reduce([], +)
        }

        let p1 = connections["start"]!
            .compactMap {
                search(next: $0, path: ["start"])
            }
            .reduce(0) {
                $0 + $1.count
            }
        await MainActor.run {
            part1 = String(p1)
        }

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

        let p2 = connections["start"]!
            .compactMap {
                search2(next: $0, path: ["start"])
            }
            .reduce(0) {
                $0 + $1.count
            }
        await MainActor.run {
            part2 = String(p2)
        }
    }
}
