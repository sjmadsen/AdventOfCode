//
//  Day22.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/22/22.
//

import Foundation

class Day22: Day {
    let sample = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"""

    enum Square: Character {
        case open = "."
        case wall = "#"
        case empty = " "
    }

    enum Facing {
        case up, right, down, left

        var value: Int {
            switch (self) {
            case .right: return 0
            case .down:  return 1
            case .left:  return 2
            case .up:    return 3
            }
        }

        func turn(_ direction: Character) -> Facing {
            switch (self, direction) {
            case (.up, "L"): return .left
            case (.up, "R"): return .right
            case (.right, "L"): return .up
            case (.right, "R"): return .down
            case (.down, "L"): return .right
            case (.down, "R"): return .left
            case (.left, "L"): return .down
            case (.left, "R"): return .up
            default: fatalError()
            }
        }
    }

    let grid: [[Square]]
    let path: String

    override init() {
        let lines =
        try! String(contentsOf: Bundle.main.url(forResource: "day22", withExtension: "input")!)
//        sample
            .split(substring: "\n\n")
        let rows = lines[0].split(separator: "\n")
        let width = rows.map(\.count).max()!
        grid = [[Square](repeating: .empty, count: width)] + rows
            .map {
                var row = $0.map {
                    Square(rawValue: $0)!
                }
                while row.count < width {
                    row.append(.empty)
                }
                return [.empty] + row + [.empty]
            }
        + [[Square](repeating: .empty, count: width)]
        path = String(lines[1]).trimmed

        super.init()
    }

    func walk(path: String, in grid: [[Square]]) -> (Int, Int, Facing) {
        var y = 1
        var x = grid[y].firstIndex(of: .open)!
        var facing = Facing.right
        let scanner = Scanner(string: path)
        var steps = 0

        while !scanner.isAtEnd {
            if scanner.scanInt(&steps) {
                move(grid, &x, &y, facing, steps)
            } else if let direction = scanner.scanCharacter() {
                facing = facing.turn(direction)
            }
        }

        return (x, y, facing)
    }

    func move(_ grid: [[Square]], _ x: inout Int, _ y: inout Int, _ facing: Facing, _ steps: Int) {
        var steps = steps
        while steps > 0 {
            switch facing {
            case .up:
                switch grid[y - 1][x] {
                case .open: y -= 1
                case .wall: return
                case .empty:
                    var wrapped = grid.count - 1
                    while grid[wrapped][x] == .empty {
                        wrapped -= 1
                    }
                    if grid[wrapped][x] == .open {
                        y = wrapped
                    } else if grid[wrapped][x] == .wall {
                        return
                    }
                }
            case .down:
                switch grid[y + 1][x] {
                case .open: y += 1
                case .wall: return
                case .empty:
                    var wrapped = 0
                    while grid[wrapped][x] == .empty {
                        wrapped += 1
                    }
                    if grid[wrapped][x] == .open {
                        y = wrapped
                    } else if grid[wrapped][x] == .wall {
                        return
                    }
                }
            case .left:
                switch grid[y][x - 1] {
                case .open: x -= 1
                case .wall: return
                case .empty:
                    var wrapped = grid[y].count - 1
                    while grid[y][wrapped] == .empty {
                        wrapped -= 1
                    }
                    if grid[y][wrapped] == .open {
                        x = wrapped
                    } else if grid[y][wrapped] == .wall {
                        return
                    }
                }
            case .right:
                switch grid[y][x + 1] {
                case .open: x += 1
                case .wall: return
                case .empty:
                    var wrapped = 0
                    while grid[y][wrapped] == .empty {
                        wrapped += 1
                    }
                    if grid[y][wrapped] == .open {
                        x = wrapped
                    } else if grid[y][wrapped] == .wall {
                        return
                    }
                }
            }
            steps -= 1
        }
    }

    override func compute() async {
        let (column, row, facing) = walk(path: path, in: grid)
        let part1_result = row * 1000 + column * 4 + facing.value
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = 0
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
