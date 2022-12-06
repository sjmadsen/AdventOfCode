//
//  Day6.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/6/22.
//

import Foundation

class Day6: Day {
//    let sample = "bvwbjplbgvbhsrlpgdmjqwftvncz"
//    let sample = "nppdvjthqldpwncqszvftbrmjlhg"
//    let sample = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    let sample = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    let input: [String.Element]

    override init() {
        input = Array(
        try! String(contentsOf: Bundle.main.url(forResource: "day6", withExtension: "input")!)
//                sample
            .trimmed
        )
        super.init()
    }

    override func compute() async {
        var i = 3
        while i < input.count {
            let suffix = input[(i - 3)...i]
            if Set(suffix).count == 4 {
                break
            }
            i += 1
        }
        let part1_result = i + 1
        await MainActor.run {
            part1 = String(part1_result)
        }

        i = 13
        while i < input.count {
            let suffix = input[(i - 13)...i]
            if Set(suffix).count == 14 {
                break
            }
            i += 1
        }
        let part2_result = i + 1
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
