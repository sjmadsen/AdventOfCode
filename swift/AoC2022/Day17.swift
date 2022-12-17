//
//  Day17.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/17/22.
//

import Foundation
import Algorithms

class Day17: Day {
    let sample = """
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""

    let input: [Character]
    let rockShapes = [
        [
            0b1111
        ],
        [
            0b10,
            0b111,
            0b10
        ],
        [
            0b001,
            0b001,
            0b111
        ],
        [
            0b1,
            0b1,
            0b1,
            0b1
        ],
        [
            0b11,
            0b11
        ]
    ]

    override init() {
        input = Array(
            try! String(contentsOf: Bundle.main.url(forResource: "day17", withExtension: "input")!)
//            sample
                .trimmed
        )
        super.init()
    }

    func dropRock(_ tower: inout [Int], rock: [Int], jets: inout Cycle<[Character]>.Iterator) {
        let leftMostBit = rock.map {
            Int(log2(Double($0 + 1))) - 1
        }.max()!
        var rock = rock.map { $0 << (4 - leftMostBit) } + [0, 0, 0]
        while rock.last == 0 {
            rock = shift(rock: rock, jet: jets.next()!)
            rock.removeLast()
        }

        var height = 0
        while tower.count >= height {
            let shiftedRock = shift(rock: rock, jet: jets.next()!)
            var rockOverlap = shiftedRock[max(0, rock.count - height)..<rock.count]
            var towerOverlap = tower[max(0, (height - rock.count))..<height]
            if !overlap(rockOverlap, towerOverlap) {
                rock = shiftedRock
            }

            if height == tower.count {
                break
            }
            rockOverlap = rock[max(0, rock.count - height - 1)...]
            towerOverlap = tower[max(0, (height + 1 - rock.count))...height]
            if overlap(rockOverlap, towerOverlap) {
                break
            }
            height += 1
        }

        for slice in rock.reversed() {
            if height > 0, height <= tower.count {
                tower[height - 1] |= slice
                height -= 1
            } else {
                tower.insert(slice, at: 0)
            }
        }
    }

    func shift(rock: [Int], jet: Character) -> [Int] {
        if jet == "<" {
            if rock.allSatisfy({ $0 < 63 }) {
                return rock.map {
                    $0 << 1
                }
            }
        } else {
            if rock.allSatisfy({ ($0 & 1) == 0 }) {
                return rock.map {
                    $0 >> 1
                }
            }
        }
        return rock
    }

    func overlap(_ rock: ArraySlice<Int>, _ tower: ArraySlice<Int>) -> Bool {
        zip(rock, tower).contains {
            $0 & $1 != 0
        }
    }

    struct State: Hashable {
        let rock: [Int]
        let tower: [Int]
    }

    func simulate(iterations: Int) -> Int {
        var repeating: [State: (iteration: Int, height: Int, repeats: Int)] = [:]
        var tower: [Int] = []
        var jets = input.cycled().makeIterator()
        var rocks = rockShapes.cycled().makeIterator()
        var truncated = 0
        var i = 0
        while i < iterations {
            let rock = rocks.next()!
            if (i % (input.count * rockShapes.count)) == 0 {
                print("checking at iteration \(i), tower height is \(tower.count + truncated)")
                let state = State(rock: rock, tower: tower)
                if let previous = repeating[state] {
                    if previous.repeats == 2 {
                        print("seen this before, at iteration \(previous.iteration), height was \(previous.height)")
                        let cycleLength = i - previous.iteration
                        let heightDelta = (tower.count + truncated) - previous.height
                        print("cycle of \(cycleLength), height delta \(heightDelta)")
                        while i + cycleLength <= iterations {
                            truncated += heightDelta
                            i += cycleLength
                        }
                        if i == iterations {
                            break
                        }
                        repeating[state] = (iteration: i, height: tower.count + truncated, repeats: 1)
                    } else {
                        repeating[state]!.repeats += 1
                    }
                } else {
                    repeating[state] = (iteration: i, height: tower.count + truncated, repeats: 1)
                }
            }
            dropRock(&tower, rock: rock, jets: &jets)
            let windowSize = 3
            let truncateAt = tower
                .lazy
                .windows(ofCount: windowSize)
                .map { ($0.startIndex, $0.reduce(0, |)) }
                .first { $0.1 == 127 }
            if let truncateAt = truncateAt?.0, truncateAt + windowSize < tower.count {
                truncated += tower.count - (truncateAt + windowSize)
                tower.removeLast(tower.count - (truncateAt + windowSize))
            }
            i += 1
        }
        return tower.count + truncated
    }

    func showBinary(_ slice: ArraySlice<Int>) -> String {
        slice[slice.startIndex..<slice.endIndex]
            .map {
                var s = ""
                var n = 64
                while n > 0 {
                    s += $0 & n != 0 ? "#" : "."
                    n >>= 1
                }
                return s
            }
            .joined(separator: "\n")
    }

    override func compute() async {
        let part1_result = simulate(iterations: 2022)
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = simulate(iterations: 1_000_000_000_000)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
