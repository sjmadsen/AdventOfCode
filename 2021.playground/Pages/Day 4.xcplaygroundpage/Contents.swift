//: [Previous](@previous)

import Foundation
import Algorithms

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")

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

// Part 1
let drawnNumbers = input[0].split(separator: ",").map { Int($0)! }
let originalBoards = input[1...].chunks(ofCount: 5).map(parseBoard)
var boards = originalBoards

part1: for n in drawnNumbers {
    for b in 0..<boards.count {
        boards[b].mark(number: n)
        if boards[b].winner {
            print(boards[b].squares.filter { !$0.called }.map(\.number).reduce(0, +) * n)
            break part1
        }
    }
}

// Part 2
boards = originalBoards
for n in drawnNumbers {
    for b in 0..<boards.count {
        guard !boards[b].winner else { continue }
        boards[b].mark(number: n)
        if boards[b].winner {
            print(boards[b].squares.filter { !$0.called }.map(\.number).reduce(0, +) * n)
        }
    }
}

//: [Next](@next)
