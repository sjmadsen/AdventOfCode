//
//  Day23.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/23/22.
//

import Foundation
import AdventKit

class Day23: Day {
    let sample = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"""

    let input: Set<Point>

    override init() {
        let lines =
        try! String(contentsOf: Bundle.main.url(forResource: "day23", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
        input = Set(
            lines.enumerated()
                .flatMap { y, line in
                    line.enumerated()
                        .compactMap { x, mark in
                            mark == "#" ? Point(x: x, y: y) : nil
                        }
                }
        )
        super.init()
    }

    struct Move {
        let isAt: Point
        let moveTo: Point
    }

    func move(_ elves: Set<Point>, _ round: Int) -> Set<Point> {
        var elves = elves
        let moves = elves.compactMap { elf in
            let adjacent = Set(adjacentElves(elves, elf))
            if !adjacent.isEmpty {
                let consider = rotate([
                    ([Point(x: elf.x - 1, y: elf.y - 1), Point(x: elf.x, y: elf.y - 1), Point(x: elf.x + 1, y: elf.y - 1)], Point(x: elf.x, y: elf.y - 1)),
                    ([Point(x: elf.x - 1, y: elf.y + 1), Point(x: elf.x, y: elf.y + 1), Point(x: elf.x + 1, y: elf.y + 1)], Point(x: elf.x, y: elf.y + 1)),
                    ([Point(x: elf.x - 1, y: elf.y - 1), Point(x: elf.x - 1, y: elf.y), Point(x: elf.x - 1, y: elf.y + 1)], Point(x: elf.x - 1, y: elf.y)),
                    ([Point(x: elf.x + 1, y: elf.y - 1), Point(x: elf.x + 1, y: elf.y), Point(x: elf.x + 1, y: elf.y + 1)], Point(x: elf.x + 1, y: elf.y))
                ], round)
                for move in consider {
                    if adjacent.intersection(move.0).isEmpty {
                        return Move(isAt: elf, moveTo: move.1)
                    }
                }
            }
            return nil
        }
        let allowed = moves
            .reduce([Point: Int]()) {
                var counts = $0
                counts[$1.moveTo, default: 0] += 1
                return counts
            }
            .filter {
                $0.value == 1
            }
            .map(\.key)
        for move in moves where allowed.contains(move.moveTo) {
            elves.remove(move.isAt)
            elves.insert(move.moveTo)
        }
        return elves
    }

    func adjacentElves(_ set: Set<Point>, _ p: Point) -> [Point] {
        [
            Point(x: p.x - 1, y: p.y - 1), Point(x: p.x, y: p.y - 1), Point(x: p.x + 1, y: p.y - 1),
            Point(x: p.x - 1, y: p.y),                                Point(x: p.x + 1, y: p.y),
            Point(x: p.x - 1, y: p.y + 1), Point(x: p.x, y: p.y + 1), Point(x: p.x + 1, y: p.y + 1)
        ].filter {
            set.contains($0)
        }
    }

    func rotate<T>(_ array: [T], _ count: Int) -> [T] {
        var count = count % array.count
        var array = array
        while count > 0 {
            array.append(array.removeFirst())
            count -= 1
        }
        return array
    }

    func countEmpty(_ elves: Set<Point>) -> Int {
        let xs = elves.map(\.x).minAndMax()!
        let ys = elves.map(\.y).minAndMax()!
        var count = 0
        for y in ys.min...ys.max {
            for x in xs.min...xs.max {
                if !elves.contains(Point(x: x, y: y)) {
                    count += 1
                }
            }
        }
        return count
    }

    func draw(_ elves: Set<Point>) {
        let xs = elves.map(\.x).minAndMax()!
        let ys = elves.map(\.y).minAndMax()!
        for y in ys.min...ys.max {
            print((xs.min...xs.max).map { x in
                elves.contains(Point(x: x, y: y)) ? "#" : "."
            }.joined())
        }
        print()
    }

    override func compute() async {
        var elves = input
        for round in 0..<10 {
            elves = move(elves, round)
        }
        let part1_result = countEmpty(elves)
        await MainActor.run {
            part1 = String(part1_result)
        }

        var round = 10
        while true {
            let movedElves = move(elves, round)
            if movedElves == elves {
                break
            }
            elves = movedElves
            round += 1
        }
        let part2_result = round + 1
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
