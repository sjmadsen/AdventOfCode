//
//  Day6.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit

class Day6: Day {
    let sample = "3,4,3,1,2"
    let input: [Int]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day6", withExtension: "input")!)
            .trimmed
            .split(separator: "\n")[0]
            .split(separator: ",")
            .map { Int($0)! }
        super.init()
    }

    override func compute() async {
        var fish = convertInput(input)
        for _ in 1...80 {
            fish = age(fish)
        }

        let p1 = fish.keys.reduce(0) { $0 + fish[$1, default: 0] }
        await MainActor.run {
            part1 = String(p1)
        }

        fish = convertInput(input)
        for _ in 1...256 {
            fish = age(fish)
        }

        let p2 = fish.keys.reduce(0) { $0 + fish[$1, default: 0] }
        await MainActor.run {
            part2 = String(p2)
        }
    }

    func convertInput(_ array: [Int]) -> [Int: Int] {
        var dict = [Int: Int]()
        for element in array {
            dict[element, default: 0] += 1
        }
        return dict
    }

    func age(_ fish: [Int: Int]) -> [Int: Int] {
        var newFish = [Int: Int]()
        if let count = fish[0] {
            newFish[8] = count
            newFish[6] = count
        }
        for count in 1...8 {
            newFish[count - 1, default: 0] += fish[count] ?? 0
        }
        return newFish
    }
}
