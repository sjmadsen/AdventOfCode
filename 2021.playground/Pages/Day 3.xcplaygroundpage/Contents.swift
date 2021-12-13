//: [Previous](@previous)

import Foundation
import AdventKit

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n").filter { !$0.isEmpty }.map { $0.map { $0 } }

// Part 1
let gamma = input
    .pivoted()
    .map { bits -> String in
        let set = NSCountedSet()
        bits.forEach { set.add(String($0)) }
        return set.count(for: "0") > set.count(for: "1") ? "0" : "1"
    }
    .joined()

let epsilon = gamma
    .map {
        $0 == "0" ? "1" : "0"
    }
    .joined()

Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!

// Part 2
func o2(list: Array<Array<Character>>, bit: Int) -> String {
    if list.count == 1 {
        return list[0].map { String($0) }.joined()
    }

    let set = NSCountedSet()
    list.forEach { set.add(String($0[bit])) }
    let keep: Character
    if set.count(for: "0") > set.count(for: "1") {
        keep = "0"
    } else {
        keep = "1"
    }
    return o2(list: list.filter { $0[bit] == keep }, bit: bit + 1)
}

func co2(list: Array<Array<Character>>, bit: Int) -> String {
    if list.count == 1 {
        return list[0].map { String($0) }.joined()
    }

    let set = NSCountedSet()
    list.forEach { set.add(String($0[bit])) }
    let keep: Character
    if set.count(for: "0") <= set.count(for: "1") {
        keep = "0"
    } else {
        keep = "1"
    }
    return co2(list: list.filter { $0[bit] == keep }, bit: bit + 1)
}

let o2Rating = o2(list: input, bit: 0)
let co2Rating = co2(list: input, bit: 0)

Int(o2Rating, radix: 2)! * Int(co2Rating, radix: 2)!

//: [Next](@next)
