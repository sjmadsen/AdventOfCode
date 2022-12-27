//
//  Day25.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/25/22.
//

import Foundation

class Day25: Day {
    let sample = """
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
"""

    let input: [String]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day25", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map(String.init)
        super.init()
    }

    func fromSnafu(_ s: String) -> Int {
        let digits: [Character: Int] = ["2": 2, "1": 1, "0": 0, "-": -1, "=": -2]
        var multiplier = 1
        var n = 0
        for c in s.reversed() {
            n += digits[c]! * multiplier
            multiplier *= 5
        }
        return n
    }

    func toSnafu(_ n: Int) -> String {
        let digits: [Int: String] = [2: "2", 1: "1", 0: "0", 4: "-", 3: "="]
        var n = n
        var s = ""
        while n > 2 {
            let remainder = n % 5
            s = digits[remainder]! + s
            switch remainder {
            case 0, 1, 2:
                break
            case 3, 4:
                n += 5 - remainder
            default: break
            }
            n /= 5
        }
        if n == 1 {
            s = "1\(s)"
        } else if n == 2 {
            s = "2\(s)"
        }
        return s
    }

    override func compute() async {
        let part1_result = toSnafu(
            input
                .map(fromSnafu)
                .reduce(0, +)
        )
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = 0
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
