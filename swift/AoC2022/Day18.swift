//
//  Day18.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/18/22.
//

import Foundation
import Algorithms
import AdventKit

class Day18: Day {
    let sample = """
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
"""

    let input: [Point3]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day18", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                let parts = $0.split(separator: ",")
                return Point3(x: Int(parts[0])!, y: Int(parts[1])!, z: Int(parts[2])!)
            }
        super.init()
    }

    func exposedSides(_ p: Point3, _ points: [Point3]) -> Int {
        [
            p - Point3(x: 1, y: 0, z: 0),
            p + Point3(x: 1, y: 0, z: 0),
            p - Point3(x: 0, y: 1, z: 0),
            p + Point3(x: 0, y: 1, z: 0),
            p - Point3(x: 0, y: 0, z: 1),
            p + Point3(x: 0, y: 0, z: 1)
        ].count {
            !points.contains($0)
        }
    }

    func findBounds(_ points: [Point3]) -> Point3Bounds {
        let xs = points.map(\.x).minAndMax()!
        let ys = points.map(\.y).minAndMax()!
        let zs = points.map(\.z).minAndMax()!
        return Point3Bounds(min: Point3(x: xs.min, y: ys.min, z: zs.min), max: Point3(x: xs.max, y: ys.max, z: zs.max))
    }

    func floodFill(_ bounds: Point3Bounds, solid: Set<Point3>, at point: Point3) -> Set<Point3> {
        var filled = Set<Point3>()
        var queue = [point]
        while !queue.isEmpty {
            let point = queue.removeFirst()
            if !solid.contains(point) && !filled.contains(point) && point.within(bounds) {
                filled.insert(point)
                queue.append(contentsOf: [
                    point - Point3(x: 1, y: 0, z: 0),
                    point + Point3(x: 1, y: 0, z: 0),
                    point - Point3(x: 0, y: 1, z: 0),
                    point + Point3(x: 0, y: 1, z: 0),
                    point - Point3(x: 0, y: 0, z: 1),
                    point + Point3(x: 0, y: 0, z: 1)
                ])
            }
        }
        return filled
    }

    func fillAirPockets(_ bounds: Point3Bounds, _ points: Set<Point3>, exterior: Set<Point3>) -> Set<Point3> {
        var points = points
        for z in bounds.zs {
            for y in bounds.ys {
                for x in bounds.xs {
                    let point = Point3(x: x, y: y, z: z)
                    if !points.contains(point) && !exterior.contains(point) {
                        points.insert(point)
                    }
                }
            }
        }
        return points
    }

    override func compute() async {
        let part1_result = input
            .map { exposedSides($0, input) }
            .reduce(0, +)
        await MainActor.run {
            part1 = String(part1_result)
        }

        var bounds = findBounds(input)
        bounds.min -= Point3(x: 1, y: 1, z: 1)
        bounds.max += Point3(x: 1, y: 1, z: 1)
        let steam = floodFill(bounds, solid: Set(input), at: bounds.min)
        let solid = Array(fillAirPockets(bounds, Set(input), exterior: steam))
        let part2_result = solid
            .map { exposedSides($0, solid) }
            .reduce(0, +)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}

struct Point3Bounds {
    var min: Point3
    var max: Point3

    var xs: ClosedRange<Int> { min.x...max.x }
    var ys: ClosedRange<Int> { min.y...max.y }
    var zs: ClosedRange<Int> { min.z...max.z }
}

extension Point3 {
    func within(_ cube: Point3Bounds) -> Bool {
        return cube.xs.contains(x) && cube.ys.contains(y) && cube.zs.contains(z)
    }
}
