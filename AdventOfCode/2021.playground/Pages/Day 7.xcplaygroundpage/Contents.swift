//: [Previous](@previous)

import Foundation

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")[0].split(separator: ",").map { Int($0)! }
//let input = [16,1,2,0,4,2,7,1,2,14]

// Part 1
let fuel = (0...(input.max()!))
    .map { position in
        input.reduce(0) { $0 + abs($1 - position) }
    }
    .min()

// Part 2
(0...(input.max()!))
    .map { position in
        input.reduce(0) { $0 + (0...abs($1 - position)).reduce(0, +) }
    }
    .min()

//: [Next](@next)
