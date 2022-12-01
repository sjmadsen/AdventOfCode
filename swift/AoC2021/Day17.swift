//
//  Day17.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/17/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day17: Day {
    let sample = "target area: x=20..30, y=-10..-5"

    let input: String
    let targetX: ClosedRange<Int>
    let targetY: ClosedRange<Int>

    override init() {
        func parseRange<S: StringProtocol>(from string: S) -> ClosedRange<Int> {
            let minMax = string.dropFirst(2).split(substring: "..")
            return Int(minMax[0])!...Int(minMax[1])!
        }

        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day17", withExtension: "input")!)
            .trimmed
        let ranges = input.dropFirst(13)
            .split(substring: ", ")
        targetX = parseRange(from: ranges[0])
        targetY = parseRange(from: ranges[1])
        super.init()
    }

    override func compute() async {
        let xVelocities = 1...targetX.upperBound
        let yVelocities = (targetY.lowerBound...(-targetY.lowerBound))
        let validVelocities = product(xVelocities, yVelocities)
            .compactMap { (xVelocity, yVelocity) -> ((Int, Int), Int)? in
                guard let maxY = simulate(xVelocity: xVelocity, yVelocity: yVelocity) else { return nil }
                return ((xVelocity, yVelocity), maxY)
            }
        let p1 = validVelocities
            .map { $0.1 }
            .max()!
        await MainActor.run {
            part1 = String(p1)
        }

        let p2 = validVelocities
            .uniqued(on: { Point(x: $0.0.0, y: $0.0.1) })
            .count
        await MainActor.run {
            part2 = String(p2)
        }
    }

    func simulate(xVelocity: Int, yVelocity: Int) -> Int? {
        var xVelocity = xVelocity
        var yVelocity = yVelocity
        var point = Point(x: xVelocity, y: yVelocity)
        var maxY = 0
        while point.x <= targetX.upperBound && point.y >= targetY.lowerBound {
            maxY = max(maxY, point.y)
            if (targetX, targetY) ~= point {
                return maxY
            }
            if xVelocity != 0 {
                xVelocity -= (xVelocity / abs(xVelocity))
            }
            yVelocity -= 1
            point += Point(x: xVelocity, y: yVelocity)
        }
        return nil
    }
}
