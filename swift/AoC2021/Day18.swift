//
//  Day18.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/18/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day18: Day {
    let sample = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""

    let input: [String]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day18", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map(String.init)

        super.init()
    }

    func parse(string str: String) -> (SnailfishNumber, String) {
        let left, right: SnailfishNumber.Element
        var string = String(str.dropFirst())
        if string.hasPrefix("[") {
            let (pair, remaining) = parse(string: string)
            left = .pair(pair)
            string = remaining
        } else {
            let scanner = Scanner(string: string)
            left = .number(scanner.scanInt()!)
        }
        string = String(string[string.index(string.firstIndex(of: ",")!, offsetBy: 1)...])
        if string.hasPrefix("[") {
            let (pair, remaining) = parse(string: string)
            right = .pair(pair)
            string = remaining
        } else {
            let scanner = Scanner(string: string)
            right = .number(scanner.scanInt()!)
        }
        string = String(string[string.index(string.firstIndex(of: "]")!, offsetBy: 1)...])
        return (SnailfishNumber(left: left, right: right), string)
    }

    override func compute() async {
        let numbers = input
            .map { parse(string: String($0)).0 }

        let p1 = numbers[1...].reduce(numbers[0], +).magnitude
        await MainActor.run {
            part1 = String(p1)
        }

        let p2 = numbers
            .combinations(ofCount: 2)
            .map { ($0[0] + $0[1]).magnitude }
            .max()!
        await MainActor.run {
            part2 = String(p2)
        }
    }
}

struct SnailfishNumber: CustomStringConvertible {
    indirect enum Element: CustomStringConvertible {
        case number(Int)
        case pair(SnailfishNumber)

        var description: String {
            switch self {
            case .number(let n): return "\(n)"
            case .pair(let n):   return "\(n)"
            }
        }

        var magnitude: Int {
            switch self {
            case .number(let n):  return n
            case .pair(let pair): return pair.left.magnitude * 3 + pair.right.magnitude * 2
            }
        }
    }

    var left, right: Element

    var description: String {
        "[\(left),\(right)]"
    }

    var magnitude: Int {
        left.magnitude * 3 + right.magnitude * 2
    }

    func reduced() -> SnailfishNumber {
        var reduction = self
        while reduction.explode() || reduction.split() {
        }
        return reduction
    }

    mutating func explode() -> Bool {
        func findExplosion(depth: Int = 1, element: inout Element) -> (left: Int?, right: Int?)? {
            switch element {
            case .number: return nil
            case .pair(var pair):
                if depth == 4 {
                    guard case .number(let left) = pair.left, case .number(let right) = pair.right
                    else { fatalError() }
                    element = .number(0)
                    return (left: left, right: right)
                } else {
                    defer { element = .pair(pair) }
                    if let explosion = findExplosion(depth: depth + 1, element: &pair.left) {
                        if let value = explosion.right, addToLeft(element: &pair.right, value: value) {
                            return (left: explosion.left, right: nil)
                        }
                        return (left: explosion.left, right: explosion.right)
                    }
                    if let explosion = findExplosion(depth: depth + 1, element: &pair.right) {
                        if let value = explosion.left, addToRight(element: &pair.left, value: value) {
                            return (left: nil, right: explosion.right)
                        }
                        return (left: explosion.left, right: explosion.right)
                    }
                    return nil
                }
            }
        }

        func addToLeft(element: inout Element, value: Int) -> Bool {
            switch element {
            case .number(let current):
                element = .number(current + value)
                return true
            case .pair(var pair):
                if addToLeft(element: &pair.left, value: value) || addToLeft(element: &pair.right, value: value) {
                    element = .pair(pair)
                    return true
                }
                return false
            }
        }

        func addToRight(element: inout Element, value: Int) -> Bool {
            switch element {
            case .number(let current):
                element = .number(current + value)
                return true
            case .pair(var pair):
                if addToRight(element: &pair.right, value: value) || addToRight(element: &pair.left, value: value) {
                    element = .pair(pair)
                    return true
                }
                return false
            }
        }

        if let explosion = findExplosion(element: &left) {
            if let n = explosion.right {
                _ = addToLeft(element: &right, value: n)
            }
            return true
        } else if let explosion = findExplosion(element: &right) {
            if let n = explosion.left {
                _ = addToRight(element: &left, value: n)
            }
            return true
        }
        return false
    }

    mutating func split() -> Bool {
        func recurse(element: inout Element) -> Bool {
            switch element {
            case .number(let n):
                guard n >= 10 else { return false }
                let roundedDown = floor(Double(n) / 2)
                let roundedUp = ceil(Double(n) / 2)
                element = .pair(SnailfishNumber(left: .number(Int(roundedDown)), right: .number(Int(roundedUp))))
                return true
            case .pair(var pair):
                defer { element = .pair(pair) }
                return recurse(element: &pair.left) || recurse(element: &pair.right)
            }
        }

        return recurse(element: &left) || recurse(element: &right)
    }

    static func +(lhs: SnailfishNumber, rhs: SnailfishNumber) -> SnailfishNumber {
        SnailfishNumber(left: .pair(lhs), right: .pair(rhs)).reduced()
    }
}
