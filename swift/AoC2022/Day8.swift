//
//  Day8.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/8/22.
//

import Foundation

class Day8: Day {
    let sample = """
30373
25512
65332
33549
35390
"""

    let input: [[Int]]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day8", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                $0.map { Int(String($0))! }
            }
        super.init()
    }

    func isVisible(_ grid: [[Int]], _ row: Int, _ col: Int) -> Bool {
        guard row > 0 && row < grid.count - 1 && col > 0 && col < grid[0].count - 1 else { return true }
        let treeHeight = grid[row][col]
        if grid[row][..<col].allSatisfy({ $0 < treeHeight }) {
            return true
        }
        if grid[row][(col + 1)...].allSatisfy({ $0 < treeHeight }) {
            return true
        }
        let column = column(grid, col)
        if column[..<row].allSatisfy({ $0 < treeHeight }) {
            return true
        }
        if column[(row + 1)...].allSatisfy({ $0 < treeHeight }) {
            return true
        }
        return false
    }

    func column(_ grid: [[Int]], _ col: Int) -> [Int] {
        var slice = [Int]()
        for row in 0..<grid.count {
            slice.append(grid[row][col])
        }
        return slice
    }

    func scenicScore(_ grid: [[Int]], _ row: Int, _ col: Int) -> Int {
        guard row > 0 && row < grid.count - 1 && col > 0 && col < grid[0].count - 1 else { return 0 }
        let treeHeight = grid[row][col]
        let rowScore = visibleCount(grid[row][..<col].reversed(), treeHeight) * visibleCount(grid[row][(col + 1)...], treeHeight)
        let column = column(grid, col)
        let colScore = visibleCount(column[..<row].reversed(), treeHeight) * visibleCount(column[(row + 1)...], treeHeight)
        return rowScore * colScore
    }

    func visibleCount<S: Sequence>(_ trees: S, _ height: Int) -> Int where S.Element == Int {
        var count = 0
        for tree in trees {
            if tree >= height {
                return count + 1
            }
            count += 1
        }
        return count
    }

    override func compute() async {
        var visible = 0
        for row in 0..<input.count {
            for col in 0..<input[0].count {
                visible += isVisible(input, row, col) ? 1 : 0
            }
        }
        let part1_result = visible
        await MainActor.run {
            part1 = String(part1_result)
        }

        var maxScore = 0
        for row in 1..<(input.count - 1) {
            for col in 1..<(input[0].count - 1) {
                maxScore = max(maxScore, scenicScore(input, row, col))
            }
        }
        let part2_result = maxScore
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
