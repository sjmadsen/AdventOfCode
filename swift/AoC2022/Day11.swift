//
//  Day11.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/11/22.
//

import Foundation

class Day11: Day {
    var input: [Monkey]
    var lcm = 1

    struct Monkey {
        var items: [Int]
        let operation: (Int) -> Int
        let test: (Int) -> Bool
        let divisor: Int
        let ifTrue: Int
        let ifFalse: Int
        var inspections = 0

        init(description: [String]) {
            var s = description[1]
            items = s[s.index(s.startIndex, offsetBy: 18)...]
                .split(substring: ", ")
                .map { Int(String($0))! }
            s = description[2]
            let parts = s[s.index(s.startIndex, offsetBy: 23)...].split(separator: " ")
            if parts[0] == "+" {
                if parts[1] == "old" {
                    operation = { $0 + $0 }
                } else {
                    let value = Int(String(parts[1]))!
                    operation = { $0 + value }
                }
            } else {
                if parts[1] == "old" {
                    operation = { $0 * $0 }
                } else {
                    let value = Int(String(parts[1]))!
                    operation = { $0 * value }
                }
            }
            s = description[3]
            divisor = Int(String(s[s.index(s.startIndex, offsetBy: 21)...]))!
            test = { [divisor] in ($0 % divisor) == 0 }
            s = description[4]
            ifTrue = Int(s[s.index(s.startIndex, offsetBy: 29)...])!
            s = description[5]
            ifFalse = Int(s[s.index(s.startIndex, offsetBy: 30)...])!
        }
    }

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day11", withExtension: "input")!)
//        sample
            .trimmed
            .split(substring: "\n\n")
            .map {
                Monkey(
                    description: String($0)
                        .split(separator: "\n")
                        .map(String.init)
                )
            }
        super.init()
        lcm = input.reduce(1) { $0 * $1.divisor }
    }

    func round(_ monkeys: inout [Monkey], relief: Int) {
        for i in 0..<monkeys.count {
            for item in monkeys[i].items {
                monkeys[i].inspections += 1
                let newValue = (monkeys[i].operation(item) / relief) % lcm
                if monkeys[i].test(newValue) {
                    monkeys[monkeys[i].ifTrue].items.append(newValue)
                } else {
                    monkeys[monkeys[i].ifFalse].items.append(newValue)
                }
            }
            monkeys[i].items = []
        }
    }

    override func compute() async {
        var monkeys = input
        for _ in 1...20 {
            round(&monkeys, relief: 3)
        }
        let part1_result = monkeys
            .map { $0.inspections }
            .max(count: 2)
            .reduce(1, *)
        await MainActor.run {
            part1 = String(part1_result)
        }

        monkeys = input
        for _ in 1...10000 {
            round(&monkeys, relief: 1)
        }
        let part2_result = monkeys
            .map { $0.inspections }
            .max(count: 2)
            .reduce(1, *)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }

    let sample = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""
}
