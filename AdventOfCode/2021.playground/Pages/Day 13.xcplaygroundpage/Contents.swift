//: [Previous](@previous)

import Foundation
import AdventKit
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!)
    .trimmed
    .split(separator: "\n")

let separator = input.firstIndex(of: "")!
let dots = input[0..<separator]
    .map { line -> (x: Int, y: Int) in
        let position = line.split(separator: ",").map { Int(String($0))! }
        return (x: position[0], y: position[1])
    }
let folds = Array(input[(separator + 1)...])

let maxX = dots.map { $0.x }.max()!
let maxY = dots.map { $0.y }.max()!
var paper = [[Bool]](repeating: .init(repeating: false, count: maxX + 1), count: maxY + 1)
dots.forEach {
    paper[$0.y][$0.x] = true
}

// Part 1
enum Axis: String, RawRepresentable {
    case x, y
}

func fold(paper: [[Bool]], along axis: Axis, at value: Int) -> [[Bool]] {
    let maxX = paper[0].count - 1
    let maxY = paper.count - 1
    switch axis {
    case .x:
        var foldedPaper = [[Bool]](repeating: .init(repeating: false, count: value), count: maxY + 1)
        for position in product(0..<value, 0...maxY) {
            foldedPaper[position.1][position.0] = paper[position.1][position.0]
        }
        for position in product((value + 1)...maxX, 0...maxY) {
            foldedPaper[position.1][(value * 2) - position.0] = foldedPaper[position.1][(value * 2) - position.0] || paper[position.1][position.0]
        }
        return foldedPaper
    case .y:
        var foldedPaper = [[Bool]](repeating: .init(repeating: false, count: maxX + 1), count: value)
        for position in product(0...maxX, 0..<value) {
            foldedPaper[position.1][position.0] = paper[position.1][position.0]
        }
        for position in product(0...maxX, (value + 1)...maxY) {
            foldedPaper[(value * 2) - position.1][position.0] = foldedPaper[(value * 2) - position.1][position.0] || paper[position.1][position.0]
        }
        return foldedPaper
    }
}

var f = folds[0]
f.removeFirst(11)
let instructions = f.split(separator: "=")
let axis = Axis(rawValue: String(instructions[0]))!
let position = Int(instructions[1])!
let foldedPaper = fold(paper: paper, along: axis, at: position)
foldedPaper
    .map { $0.count { $0 == true } }
    .reduce(0, +)

// Part 2
let final = folds[1...]
    .reduce(foldedPaper) {
        let instructions = $1[$1.index($1.startIndex, offsetBy: 11)...].split(separator: "=")
        let axis = Axis(rawValue: String(instructions[0]))!
        let position = Int(instructions[1])!
        return fold(paper: $0, along: axis, at: position)
    }
print(
    final
        .map {
            $0.map { $0 ? "#" : "." }.joined(separator: "")
        }
        .joined(separator: "\n")
)

//: [Next](@next)
