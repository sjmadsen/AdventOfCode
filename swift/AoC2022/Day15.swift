//
//  Day15.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/15/22.
//

import Foundation
import AdventKit

class Day15: Day {
    let sample = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""

    typealias Pair = (sensor: Point, beacon: Point)
    let input: [Pair]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day15", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                let colon = $0.firstIndex(of: ":")
                let sensor = Day15.parsePoint(String($0[$0.index($0.startIndex, offsetBy: 10)..<colon!]))
                let isAt = $0.firstRange(of: "is at ")!.lowerBound
                let beacon = Day15.parsePoint(String($0[($0.index(isAt, offsetBy: 6))...]))
                return (sensor: sensor, beacon: beacon)
            }
        super.init()
    }

    static func parsePoint(_ s: String) -> Point {
        let xy = s.split(substring: ", ")
        return Point(x: Int(xy[0][xy[0].index(at: 2)...])!, y: Int(xy[1][xy[1].index(at: 2)...])!)
    }

    func noBeacon(y: Int) -> Int {
        let relevant = input
            .filter { overlaps($0, row: y) }
        let beacons = relevant
            .map(\.beacon)
            .uniqued()
        guard let bounds = relevant
            .minAndMax(by: { $0.sensor.x < $1.sensor.x }) else { return 0 }
        var minX = bounds.min.sensor.x
        while bounds.min.sensor.manhattanDistance(from: Point(x: minX, y: y)) <= bounds.min.sensor.manhattanDistance(from: bounds.min.beacon) {
            minX -= 1
        }
        var maxX = bounds.max.sensor.x
        while bounds.max.sensor.manhattanDistance(from: Point(x: maxX, y: y)) <= bounds.max.sensor.manhattanDistance(from: bounds.max.beacon) {
            maxX += 1
        }
        return (minX...maxX).count { x in
            relevant.contains {
                $0.sensor.manhattanDistance(from: Point(x: x, y: y)) <= $0.sensor.manhattanDistance(from: $0.beacon)
            }
        } - beacons.count { $0.y == y }
    }

    func overlaps(_ pair: Pair, row: Int) -> Bool {
        pair.sensor.manhattanDistance(from: Point(x: pair.sensor.x, y: row)) <= pair.sensor.manhattanDistance(from: pair.beacon)
    }

    func coverage(pair: Pair, y: Int) -> ClosedRange<Int>? {
        let maxDistance = pair.sensor.manhattanDistance(from: pair.beacon)
        let yDistance = pair.sensor.manhattanDistance(from: Point(x: pair.sensor.x, y: y))
        guard yDistance < maxDistance else { return nil }
        let minX = pair.sensor.x - (maxDistance - yDistance)
        let maxX = pair.sensor.x + (maxDistance - yDistance)
        return minX...maxX
    }

    func findBeacon() -> Point {
        for y in 0...4_000_000 {
            let xs = input
                .reduce([0...4_000_000]) {
                    guard let covered = coverage(pair: $1, y: y) else { return $0 }
                    let candidates = $0.flatMap {
                        $0.subtracting(covered)
                    }
                        .filter { !$0.isEmpty }
                    return candidates
                }
            if let x = xs.first {
                return Point(x: x.first!, y: y)
            }
        }
        fatalError()
    }

    func tuningFrequency(_ p: Point) -> Int {
        p.x * 4_000_000 + p.y
    }

    override func compute() async {
        let part1_result = noBeacon(y: 2000000)
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = tuningFrequency(findBeacon())
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
