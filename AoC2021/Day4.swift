//
//  Day4.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit

class Day4: Day {
    let sample = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""
    let input: [String]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day4", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")
            .map(String.init)
        super.init()
    }

    override func compute() async {
        let drawnNumbers = input[0].split(separator: ",").map { Int($0)! }
        var boards = originalBoards
        part1: for n in drawnNumbers {
            for b in 0..<boards.count {
                boards[b].mark(number: n)
                if boards[b].winner {
                    let p1 = boards[b].squares.filter { !$0.called }.map(\.number).reduce(0, +) * n
                    await MainActor.run {
                        part1 = String(p1)
                    }
                    break part1
                }
            }
        }

        boards = originalBoards
        var winners = [Int]()
        for n in drawnNumbers {
            for b in 0..<boards.count {
                guard !boards[b].winner else { continue }
                boards[b].mark(number: n)
                if boards[b].winner {
                    winners.append(boards[b].squares.filter { !$0.called }.map(\.number).reduce(0, +) * n)
                }
            }
        }
        let p2 = winners.last!
        await MainActor.run {
            part2 = String(p2)
        }
    }

    var originalBoards: [Board] {
        input[1...].chunks(ofCount: 5).map(parseBoard)
    }

    func parseBoard<T: RandomAccessCollection>(_ lines: T) -> Board where T.Element: StringProtocol {
        Board(
            squares: lines
                .flatMap {
                    $0.split(separator: " ")
                        .map { Int($0)! }
                }
                .map { Board.Square(number: $0) }
        )
    }
}

struct Board {
    struct Square {
        let number: Int
        var called = false
    }

    var squares: [Square]

    subscript(_ x: Int, _ y: Int) -> Square {
        squares[y * 5 + x]
    }

    mutating func mark(number: Int) {
        for i in 0..<squares.count {
            if squares[i].number == number {
                squares[i].called = true
                break
            }
        }
    }

    var winner: Bool {
        for i in 0...4 {
            if (self[i,0].called && self[i,1].called && self[i,2].called && self[i,3].called && self[i,4].called) ||
                (self[0,i].called && self[1,i].called && self[2,i].called && self[3,i].called && self[4,i].called) {
                return true
            }
        }
        return false
    }
}
