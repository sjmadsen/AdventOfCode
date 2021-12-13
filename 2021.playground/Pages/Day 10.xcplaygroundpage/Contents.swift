//: [Previous](@previous)

import Foundation
import AdventKit

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")

// Part 1
let closing: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
input
    .compactMap {
        var stack = [Character]()
        for character in $0 {
            switch character {
            case "(", "[", "{", "<": stack.append(closing[character]!)
            case ")", "]", "}", ">":
                if stack.removeLast() != character {
                    return character
                }
            default: break
            }
        }
        return nil
    }
    .map(corruptedScore)
    .reduce(0, +)

func corruptedScore(delimiter: Character) -> Int {
    switch delimiter {
    case ")": return 3
    case "]": return 57
    case "}": return 1197
    case ">": return 25137
    default: return 0
    }
}

// Part 2
input
    .compactMap { line -> String? in
        var stack = [Character]()
        for character in line {
            switch character {
            case "(", "[", "{", "<": stack.append(closing[character]!)
            case ")", "]", "}", ">":
                if stack.removeLast() != character {
                    return nil
                }
            default: break
            }
        }
        return String(stack.reversed())
    }
    .map { (completion: String) -> Int in
        completion.reduce(0) {
            $0 * 5 + incompleteScore(delimiter: $1)
        }
    }
    .median()

func incompleteScore(delimiter: Character) -> Int {
    switch delimiter {
    case ")": return 1
    case "]": return 2
    case "}": return 3
    case ">": return 4
    default: return 0
    }
}

//: [Next](@next)
