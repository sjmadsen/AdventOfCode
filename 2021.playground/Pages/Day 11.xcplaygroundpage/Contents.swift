//: [Previous](@previous)

import Foundation
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!)
    .split(separator: "\n")
    .map {
        $0.map { Int(String($0))! }
    }

// Part 1
func flashes(octopi: [[Int]]) -> Set<Point> {
    product(0..<octopi[0].count, 0..<octopi.count)
        .reduce(Set<Point>()) {
            if octopi[$1.1][$1.0] > 9 {
                return $0.union([Point(x: $1.0, y: $1.1)])
            } else {
                return $0
            }
        }
}

func simulate(octopi: [[Int]]) -> [[Int]] {
    var step = octopi
    for (x, y) in product(0..<step[0].count, 0..<step.count) {
        step[y][x] += 1
    }

    var flashed = Set<Point>()
    var newFlashes = flashes(octopi: step)
    while !newFlashes.isEmpty {
        newFlashes.forEach {
            for (x, y) in product($0.x - 1...$0.x + 1, $0.y - 1...$0.y + 1) {
                if x >= 0 && x < step[0].count, y >= 0 && y < step.count {
                    step[y][x] += 1
                }
            }
        }
        flashed.formUnion(newFlashes)
        newFlashes = flashes(octopi: step).subtracting(flashed)
    }

    for point in flashed {
        step[point.y][point.x] = 0
    }
    return step
}

var step = input
(1...100)
    .map { _ in
        step = simulate(octopi: step)
        return step
            .map {
                $0.filter { $0 == 0 }.count
            }
            .reduce(0, +)
    }
    .reduce(0, +)

// Part 2
step = input
var stepNumber = 0
repeat {
    step = simulate(octopi: step)
    stepNumber += 1
} while !step.allSatisfy { $0.allSatisfy { $0 == 0 } }

print("Synchronized at step \(stepNumber)")

//: [Next](@next)
