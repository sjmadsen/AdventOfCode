//: [Previous](@previous)

import Cocoa
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n").compactMap { Int($0) }

// Part 1
input.adjacentPairs().reduce(0) {
    $1.0 < $1.1 ? $0 + 1 : $0
}

// Part 2
input.windows(ofCount: 3).map {
    $0.reduce(0, +)
}.adjacentPairs().reduce(0) {
    $1.0 < $1.1 ? $0 + 1 : $0
}

//: [Next](@next)
