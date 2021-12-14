//: [Previous](@previous)

import Foundation
import Algorithms
import AdventKit

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!)
    .trimmed
    .split(separator: "\n")
    .split(separator: "")
let template = String(input[0][0])
let rules = input[1]
    .reduce([String: String]()) {
        let mapping = $1.split(separator: " -> ")
        var rules = $0
        rules[String(mapping[0])] = String(mapping[1])
        return rules
    }

// Part 1
func substitute(polymer: [String: Int]) -> [String: Int] {
    var newPolymer = polymer
    for (pair, insert) in rules where polymer[pair] != nil {
        newPolymer["\(pair[pair.startIndex])\(insert)", default: 0] += polymer[pair]!
        newPolymer["\(insert)\(pair[pair.index(pair.startIndex, offsetBy: 1)])", default: 0] += polymer[pair]!
        newPolymer[pair]! -= polymer[pair]!
    }
    return newPolymer
}

func counts(template: String, polymer: [String: Int]) -> [String: Int] {
    var counts = polymer
        .reduce([String: Int]()) {
            var counts = $0
            counts[String($1.key.prefix(1)), default: 0] += $1.value
            return counts
        }
    counts[String(template.suffix(1)), default: 0] += 1
    return counts
}

let pairs = template
    .map { String($0) }
    .adjacentPairs()
    .reduce([String: Int]()) {
        var pairCount = $0
        pairCount["\($1.0)\($1.1)", default: 0] += 1
        return pairCount
    }

let polymer =
    (1...10)
    .reduce(pairs) { polymer, _ in
        substitute(polymer: polymer)
    }
var frequency = counts(template: template, polymer: polymer)
var minMax = frequency.minAndMax { $0.value < $1.value }!
minMax.max.value - minMax.min.value

// Part 2
let polymer40 =
    (1...40)
    .reduce(pairs) { polymer, _ in
        substitute(polymer: polymer)
    }
frequency = counts(template: template, polymer: polymer40)
minMax = frequency.minAndMax { $0.value < $1.value }!
minMax.max.value - minMax.min.value

//: [Next](@next)
