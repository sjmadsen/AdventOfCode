//
//  Day21.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/21/22.
//

import Foundation

class Day21: Day {
    let sample = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"""

    enum Value {
        case number(Int)
        case math(Equation)
        case humn
    }

    typealias Equation = (lhs: String, op: Operation, rhs: String)

    enum Operation: String {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
    }

    let input: [String: Value]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day21", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .reduce([:]) {
                var monkeys = $0
                let parts = $1.split(separator: ": ")
                let monkey = String(parts[0])
                let valueParts = parts[1].split(separator: " ")
                if valueParts.count == 1 {
                    monkeys[monkey] = .number(Int(String(valueParts[0]))!)
                } else {
                    monkeys[monkey] = .math((lhs: String(valueParts[0]), op: Operation(rawValue: String(valueParts[1]))!, rhs: String(valueParts[2])))
                }
                return monkeys
            }
        super.init()
    }

    func value(of name: String, in dict: inout [String: Value]) -> Int {
        switch dict[name]! {
        case .number(let value):
            return value
        case .math((let firstName, let operation, let secondName)):
            let firstValue = value(of: firstName, in: &dict)
            let secondValue = value(of: secondName, in: &dict)
            let value: Int
            switch operation {
            case .add: value = firstValue + secondValue
            case .subtract: value = firstValue - secondValue
            case .multiply: value = firstValue * secondValue
            case .divide: value = firstValue / secondValue
            }
            dict[name] = .number(value)
            return value
        case .humn:
            fatalError()
        }
    }

    func reduce(_ name: String, in dict: inout [String: Value]) -> Value {
        switch dict[name]! {
        case .number:
            break
        case .math(let equation):
            if equation.lhs == "humn" {
                _ = reduce(equation.rhs, in: &dict)
            } else if equation.rhs == "humn" {
                _ = reduce(equation.lhs, in: &dict)
            } else {
                let firstValue = reduce(equation.lhs, in: &dict)
                let secondValue = reduce(equation.rhs, in: &dict)
                let value: Int
                switch (firstValue, secondValue) {
                case (.number(let first), .number(let second)):
                    switch equation.op {
                    case .add: value = first + second
                    case .subtract: value = first - second
                    case .multiply: value = first * second
                    case .divide: value = first / second
                    }
                    dict[name] = .number(value)
                default:
                    break
                }
            }
        case .humn:
            break
        }
        return dict[name]!
    }

    func solveForHumn(dict: [String: Value]) -> Int {
        var dict = dict
        guard case .math(let equation) = dict["root"] else { return -1 }
        dict["humn"] = .humn
        switch (reduce(equation.lhs, in: &dict), reduce(equation.rhs, in: &dict)) {
        case (.number(let left), .math(let equation)):
            return simplify(equation, equals: left, dict: dict)
        case (.math(let equation), .number(let right)):
            return simplify(equation, equals: right, dict: dict)
        default:
            fatalError()
        }
    }

    func simplify(_ equation: Equation, equals value: Int, dict: [String: Value]) -> Int {
        var equation = equation
        var value = value
        while let lhs = dict[equation.lhs], let rhs = dict[equation.rhs] {
            switch (lhs, equation.op, rhs) {
            case (.number(let x), .add, .math(let remaining)), (.math(let remaining), .add, .number(let x)):
                value -= x
                equation = remaining
            case (.humn, .add, .number(let x)), (.number(let x), .add, .humn):
                return value - x
            case (.number(let x), .subtract, .math(let remaining)):
                value = x - value
                equation = remaining
            case (.math(let remaining), .subtract, .number(let x)):
                value += x
                equation = remaining
            case (.humn, .subtract, .number(let x)):
                return value + x
            case (.number(let x), .subtract, .humn):
                return -(value + x)
            case (.number(let x), .multiply, .math(let remaining)), (.math(let remaining), .multiply, .number(let x)):
                value /= x
                equation = remaining
            case (.humn, .multiply, .number(let x)), (.number(let x), .multiply, .humn):
                return value / x
            case (.number(let x), .divide, .math(let remaining)):
                value = x / value
                equation = remaining
            case (.math(let remaining), .divide, .number(let x)):
                value *= x
                equation = remaining
            case (.humn, .divide, .number(let x)):
                return value * x
            case (.number(let x), .divide, .humn):
                return x / value
            default:
                fatalError()
            }
        }
        fatalError()
    }

    override func compute() async {
        var dict = input
        let part1_result = value(of: "root", in: &dict)
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = solveForHumn(dict: input)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
