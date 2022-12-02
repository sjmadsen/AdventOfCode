//
//  Day2.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/2/22.
//

import Foundation

class Day2: Day {
    let sample = """
A Y
B X
C Z
"""

    enum Play: Equatable {
        case rock
        case paper
        case scissors

        init?(rawValue: String) {
            switch rawValue {
            case "A", "X": self = .rock
            case "B", "Y": self = .paper
            case "C", "Z": self = .scissors
            default: return nil
            }
        }

        init?(other: Play, outcome: Outcome) {
            switch (other, outcome) {
            case (.rock, .win): self = .paper
            case (.rock, .draw): self = .rock
            case (.rock, .lose): self = .scissors
            case (.paper, .win): self = .scissors
            case (.paper, .draw): self = .paper
            case (.paper, .lose): self = .rock
            case (.scissors, .win): self = .rock
            case (.scissors, .draw): self = .scissors
            case (.scissors, .lose): self = .paper
            }
        }

        func outcome(_ other: Play) -> Outcome {
            switch (self, other) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): return .win
            case (.scissors, .rock), (.rock, .paper), (.paper, .scissors): return .lose
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors): return .draw
            }
        }

        var value: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }
    }

    enum Outcome: String {
        case lose = "X"
        case draw = "Y"
        case win = "Z"

        var value: Int {
            switch self {
            case .lose: return 0
            case .draw: return 3
            case .win: return 6
            }
        }
    }

    let input: [(them: Play, String)]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day2", withExtension: "input")!)
            .trimmed
            .split(substring: "\n")
            .map {
                let plays = $0
                    .split(substring: " ")
                return (them: Play(rawValue: String(plays[0]))!, String(plays[1]))
            }
        super.init()
    }

    override func compute() async {
        await MainActor.run {
            part1 = String(
                input
                    .map {
                        let me = Play(rawValue: $0.1)!
                        return me.outcome($0.them).value + me.value
                    }
                    .reduce(0, +)
            )
        }

        await MainActor.run {
            part2 = String(
                input
                    .map {
                        let me = Play(other: $0.them, outcome: Outcome(rawValue: $0.1)!)!
                        return me.outcome($0.them).value + me.value
                    }
                    .reduce(0, +)
            )
        }
    }
}
