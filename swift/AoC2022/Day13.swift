//
//  Day13.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/13/22.
//

import Foundation

class Day13: Day {
    let sample = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

    enum Element: Comparable {
        case int(Int)
        case list([Element])

        static func < (lhs: Element, rhs: Element) -> Bool {
            switch (lhs, rhs) {
            case (.int(let left), .int(let right)):
                return left < right
            case (.int, .list):
                return .list([lhs]) < rhs
            case (.list, .int):
                return lhs < .list([rhs])
            case (.list(let left), .list(let right)):
                for i in 0..<min(left.count, right.count) {
                    if left[i] < right[i] {
                        return true
                    } else if left[i] > right[i] {
                        return false
                    }
                }
                return left.count < right.count
            }
        }
    }

    let input: [(Element, Element)]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day13", withExtension: "input")!)
//        sample
            .trimmed
            .split(substring: "\n\n")
            .map {
                let packets = String($0)
                    .split(separator: "\n")
                    .map {
                        var offset = $0.startIndex
                        return Day13.parse(line: $0, offset: &offset)
                    }
                return (packets.first!, packets.last!)
            }
        super.init()
    }

    static func parse<S: StringProtocol>(line: S, offset: inout String.Index) -> Element {
        var packet = [Element]()
        while offset < line.endIndex {
            if line[offset] == "[" {
                offset = line.index(after: offset)
                packet.append(parse(line: line[offset...], offset: &offset))
            } else if line[offset] == "]" {
                offset = line.index(after: offset)
                return .list(packet)
            } else {
                let scanner = Scanner(string: String(line[offset...]))
                var int = 0
                if scanner.scanInt(&int) {
                    packet.append(.int(int))
                    offset = line.index(offset, offsetBy: scanner.scanLocation)
                } else {
                    offset = line.index(after: offset)
                }
            }
        }
        return .list(packet)
    }

    override func compute() async {
        let part1_result = input
            .enumerated()
            .filter { (_, element) in
                element.0 < element.1
            }
            .map { $0.offset + 1 }
            .reduce(0, +)
        await MainActor.run {
            part1 = String(part1_result)
        }

        let sorted = (input + [(Element.list([.list([.int(2)])]), Element.list([.list([.int(6)])]))])
            .flatMap { [$0.0, $0.1] }
            .sorted()

        let part2_result = (sorted.firstIndex(of: .list([.list([.int(2)])]))! + 1) * (sorted.firstIndex(of: .list([.list([.int(6)])]))! + 1)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
