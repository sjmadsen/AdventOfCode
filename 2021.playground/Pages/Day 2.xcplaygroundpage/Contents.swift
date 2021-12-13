//: [Previous](@previous)

import Foundation

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n").filter { !$0.isEmpty }

// Part 1
var position = 0
var depth = 0
input.forEach {
    let parts = $0.split(separator: " ")
    switch (parts[0], Int(parts[1])!) {
    case ("forward", let n): position += n
    case ("down", let n):    depth += n
    case ("up", let n):      depth -= n
    default:                 break
    }
}

print("position \(position), depth \(depth), [\(position * depth)]")

// Part 2
position = 0
depth = 0
var aim = 0
input.forEach {
    let parts = $0.split(separator: " ")
    switch (parts[0], Int(parts[1])!) {
    case ("forward", let n):
        position += n
        depth += aim * n
    case ("down", let n): aim += n
    case ("up", let n):   aim -= n
    default:              break
    }
}

print("position \(position), depth \(depth), [\(position * depth)]")

//: [Next](@next)
