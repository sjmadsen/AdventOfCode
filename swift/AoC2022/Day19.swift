//
//  Day19.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/19/22.
//

import Foundation
import Algorithms

class Day19: Day {
    let sample = """
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
"""

    let input: [Blueprint]

    typealias Blueprint = (oreRobot: Int, clayRobot: Int, obsidianRobot: (ore: Int, clay: Int), geodeRobot: (ore: Int, obsidian: Int))

    struct State: Hashable {
        var ore = 0
        var clay = 0
        var obsidian = 0
        var geodes = 0
        var oreRobots = 1
        var clayRobots = 0
        var obsidianRobots = 0
        var geodeRobots = 0
    }

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day19", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map { Day19.parse(blueprint: String($0)) }
        super.init()
    }

    static func parse(blueprint: String) -> Blueprint {
        let regex = /ore robot costs (\d+).+clay robot costs (\d+).+obsidian robot costs (\d+) ore and (\d+).+geode robot costs (\d+) ore and (\d+)/
        let match = blueprint.firstMatch(of: regex)!
        return (oreRobot: Int(match.1)!, clayRobot: Int(match.2)!, obsidianRobot: (ore: Int(match.3)!, clay: Int(match.4)!), geodeRobot: (ore: Int(match.5)!, obsidian: Int(match.6)!))
    }

    func simulate(_ blueprint: Blueprint, limit: Int) -> State {
        var queue = Set([State()])
        for minute in 0..<limit {
            let remaining = limit - minute
            let maximum = queue
                .map {
                    $0.geodeRobots * remaining + (remaining * (remaining - 1) / 2) + $0.geodes
                }
                .max()!
            print("Minute \(minute + 1), \(queue.count) states to consider, best possible from here is \(maximum)")
            var nextQueue = Set<State>()
            while let state = queue.popFirst() {
                let bestPossible = state.geodeRobots * remaining + (remaining * (remaining - 1) / 2) + state.geodes
                if Double(bestPossible) < Double(maximum) * 0.8 {
                    continue
                }
                if state.ore >= blueprint.geodeRobot.ore, state.obsidian >= blueprint.geodeRobot.obsidian {
                    var state = state
                    state.ore -= blueprint.geodeRobot.ore
                    state.obsidian -= blueprint.geodeRobot.obsidian
                    state.ore += state.oreRobots
                    state.clay += state.clayRobots
                    state.obsidian += state.obsidianRobots
                    state.geodes += state.geodeRobots
                    state.geodeRobots += 1
                    nextQueue.insert(state)
                }
                if state.ore >= blueprint.obsidianRobot.ore, state.clay >= blueprint.obsidianRobot.clay {
                    var state = state
                    state.ore -= blueprint.obsidianRobot.ore
                    state.clay -= blueprint.obsidianRobot.clay
                    state.ore += state.oreRobots
                    state.clay += state.clayRobots
                    state.obsidian += state.obsidianRobots
                    state.geodes += state.geodeRobots
                    state.obsidianRobots += 1
                    nextQueue.insert(state)
                }
                if state.ore >= blueprint.clayRobot, state.clayRobots < blueprint.obsidianRobot.clay {
                    var state = state
                    state.ore -= blueprint.clayRobot
                    state.ore += state.oreRobots
                    state.clay += state.clayRobots
                    state.obsidian += state.obsidianRobots
                    state.geodes += state.geodeRobots
                    state.clayRobots += 1
                    nextQueue.insert(state)
                }
                if state.ore >= blueprint.oreRobot, state.oreRobots < [blueprint.oreRobot, blueprint.clayRobot, blueprint.obsidianRobot.ore, blueprint.geodeRobot.ore].max()! {
                    var state = state
                    state.ore -= blueprint.oreRobot
                    state.ore += state.oreRobots
                    state.clay += state.clayRobots
                    state.obsidian += state.obsidianRobots
                    state.geodes += state.geodeRobots
                    state.oreRobots += 1
                    nextQueue.insert(state)
                }

                var state = state
                state.ore += state.oreRobots
                state.clay += state.clayRobots
                state.obsidian += state.obsidianRobots
                state.geodes += state.geodeRobots
                nextQueue.insert(state)
            }
            queue = nextQueue
        }

        return queue.max { $0.geodes < $1.geodes }!
    }

    override func compute() async {
        let part1_result = input
            .enumerated()
            .map {
                let result = simulate($1, limit: 24)
                print($0 + 1, result, ($0 + 1) * result.geodes)
                return ($0 + 1) * result.geodes
            }
            .reduce(0, +)
        await MainActor.run {
            part1 = String(part1_result)
        }

        let part2_result = input.prefix(3)
            .enumerated()
            .map {
                let result = simulate($1, limit: 32)
                print($0, result)
                return result.geodes
            }
            .reduce(1, *)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
