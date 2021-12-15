//: [Previous](@previous)

import Foundation

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")
    .map { $0.map { Int(String($0))! } }

// Part 1
func isLowPoint(_ input: [[Int]], x: Int, y: Int) -> Bool {
    let value = input[y][x]
    if (x == 0 || input[y][x - 1] > value)
        && (x == maxX - 1 || input[y][x + 1] > value)
        && (y == 0 || input[y - 1][x] > value)
        && (y == maxY - 1 || input[y + 1][x] > value) {
        return true
    }
    return false
}

let maxX = input[0].count
let maxY = input.count
var lowPoints = [Point]()
for y in 0..<maxY {
    for x in 0..<maxX {
        if isLowPoint(input, x: x, y: y) {
            lowPoints.append(Point(x: x, y: y))
        }
    }
}
print(lowPoints.reduce(0) { $0 + input[$1.y][$1.x] } + lowPoints.count)

// Part 2
func basinSize(_ input: [[Int]], x: Int, y: Int) -> Int {
    func recurse(x: Int, y: Int, basin: inout Set<Point>) {
        if x >= 0 && x < maxX && y >= 0 && y < maxY && input[y][x] != 9 && !basin.contains(Point(x: x, y: y)) {
            basin.insert(Point(x: x, y: y))
            recurse(x: x - 1, y: y, basin: &basin)
            recurse(x: x + 1, y: y, basin: &basin)
            recurse(x: x, y: y - 1, basin: &basin)
            recurse(x: x, y: y + 1, basin: &basin)
        }
    }

    var basin = Set<Point>()
    recurse(x: x, y: y, basin: &basin)
    return basin.count
}

lowPoints
    .map { basinSize(input, x: $0.x, y: $0.y) }
    .sorted() { $1 < $0 }
    .prefix(3)
    .reduce(1, *)

//: [Next](@next)
