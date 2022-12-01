//
//  Day19.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/19/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day19: Day {
    let sample = """
"""

    let input: [[Vector3]]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day19", withExtension: "sample")!)
            .trimmed
            .split(substring: "\n---")
            .map {
                $0.split(separator: "\n")[1...]
                    .map {
                        let xyz = $0.split(separator: ",")
                        return Vector3(x: Int(xyz[0])!, y: Int(xyz[1])!, z: Int(xyz[2])!)
                    }
            }

        super.init()
    }

    override func compute() async {
        print(overlaps(input[0], input[1]))
        let p1 = 0
        await MainActor.run {
            part1 = String(p1)
        }

        let p2 = 0
        await MainActor.run {
            part2 = String(p2)
        }
    }

    func overlaps(_ s1: [Vector3], _ s2: [Vector3]) -> [Vector3] {
        var relativeS2 = [Vector3: [Vector3]]()
        for (b1, b2) in product(s1, s2) {
            relativeS2[b1 + -b2, default: []].append(b1)
        }
        let mode = relativeS2.keys.max { relativeS2[$0]!.count < relativeS2[$1]!.count }
        return []
    }
}

struct Vector3: Equatable, Hashable {
    let x, y, z: Int

    var length: Double {
        sqrt(Double(x*x + y*y + z*z))
    }

    static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static prefix func -(v: Vector3) -> Vector3 {
        Vector3(x: -v.x, y: -v.y, z: -v.z)
    }
}
