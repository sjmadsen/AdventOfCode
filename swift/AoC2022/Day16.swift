//
//  Day16.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/16/22.
//

import Foundation
import Algorithms

class Day16: Day {
    let sample = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""

    struct Room {
        let name: String
        let flowRate: Int
        let tunnels: [String]
        var valveOpen: Bool
    }

    let graph: [String: Room]
    var travelTime: [String: Int]

    override init() {
        let regex = /Valve (.+) has flow rate=(\d+); tunnels? leads? to valves? (.+)$/
        graph =
        try! String(contentsOf: Bundle.main.url(forResource: "day16", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .map {
                let match = $0.firstMatch(of: regex)!
                let name = String(match.1)
                let flowRate = Int(match.2)!
                let tunnels = match.3.split(substring: ", ").map(String.init)
                return Room(name: name, flowRate: flowRate, tunnels: tunnels, valveOpen: false)
            }
            .reduce([String: Room]()) {
                var dict = $0
                dict[$1.name] = $1
                return dict
            }
        travelTime = [:]
        super.init()
    }

    func computeTravelTimes(from room: String, visited: Set<String> = []) {
        guard !visited.contains(room) else { return }
        for destination in graph[room]!.tunnels {
            travelTime["\(room):\(destination)"] = 1
            travelTime["\(destination):\(room)"] = 1
            computeTravelTimes(from: destination, visited: visited.union([room]))
            let otherRooms = Set(graph.keys).subtracting(graph[room]!.tunnels + [room])
            for other in otherRooms {
                guard let fromDestination = travelTime["\(destination):\(other)"] else { continue }
                if let currentTime = travelTime["\(room):\(other)"] {
                    travelTime["\(room):\(other)"] = min(currentTime, fromDestination + 1)
                    travelTime["\(other):\(room)"] = min(currentTime, fromDestination + 1)
                } else {
                    travelTime["\(room):\(other)"] = fromDestination + 1
                    travelTime["\(other):\(room)"] = fromDestination + 1
                }
            }
        }
    }

    func findMaxTotalFlow(volcano: [String: Room], in room: String, path: [String] = [], totalFlow: Int = 0, minute: Int = 0) -> (Int, [String]) {
        guard minute < 30 else { return (totalFlow, path) }
        let totalFlow = totalFlow + (30 - minute) * graph[room]!.flowRate
        let path = path + [room]
        var volcano = volcano
        volcano[room]!.valveOpen = true
        let best = volcano
            .filter { !$0.value.valveOpen && $0.value.flowRate > 0 }
            .filter {
                guard let travel = travelTime["\(room):\($0.key)"] else { return false }
                return minute + travel < 29
            }
            .map {
                let travel = travelTime["\(room):\($0.key)"]!
                return findMaxTotalFlow(volcano: volcano, in: $0.key, path: path, totalFlow: totalFlow, minute: minute + travel + 1)
            }
            .max {
                $0.0 < $1.0
            }
        if let best {
            return best
        } else {
            return (totalFlow, path)
        }
    }

    func findMaxTotalFlowWithElephant(volcano: [String: Room], me: String, elephant: String, myPath: [String] = [], elephantPath: [String] = [], totalFlow: Int = 0, myMinute: Int = 4, elephantMinute: Int = 4, useTaskGroup: Bool = false) async -> (Int, [String], [String]) {
        var openValves = volcano
            .filter { !$0.value.valveOpen && $0.value.flowRate > 0 }
        if myMinute < 30, elephantMinute < 30 {
            let totalFlow = totalFlow + (30 - myMinute) * graph[me]!.flowRate + (30 - elephantMinute) * graph[elephant]!.flowRate
            let myPath = myPath + [me]
            let elephantPath = elephantPath + [elephant]
            var volcano = volcano
            volcano[me]!.valveOpen = true
            volcano[elephant]!.valveOpen = true
            openValves = openValves
                .filter {
                    guard let myTravel = travelTime["\(me):\($0.key)"],
                          let elephantTravel = travelTime["\(elephant):\($0.key)"]
                    else { return false }
                    return myMinute + myTravel < 30 || elephantMinute + elephantTravel < 30
                }
            if openValves.count >= 2 {
                let combinations = openValves
                    .combinations(ofCount: 2)
                var results = [(Int, [String], [String])]()
                if useTaskGroup {
                    print("Open valves: \(openValves.map(\.key))")
                    print("\(combinations.count) total combinations")
                    let volcano = volcano
                    await withTaskGroup(of: (Int, [String], [String]).self) {
                        for destinations in combinations {
                            $0.addTask {
                                print("Trying \(destinations[0].key) and \(destinations[1].key)")
                                return await self.findMaxTotalFlowWithElephant(volcano: volcano, destinations: destinations, me: me, elephant: elephant, myPath: myPath, elephantPath: elephantPath, totalFlow: totalFlow, myMinute: myMinute, elephantMinute: elephantMinute)
                            }
                        }

                        for await value in $0 {
                            results.append(value)
                        }
                    }
                } else {
                    for combination in combinations {
                        results.append(
                            await findMaxTotalFlowWithElephant(volcano: volcano, destinations: combination, me: me, elephant: elephant, myPath: myPath, elephantPath: elephantPath, totalFlow: totalFlow, myMinute: myMinute, elephantMinute: elephantMinute)
                        )
                    }
                }
                return results.max { $0.0 < $1.0 }!
            } else if openValves.count == 1 {
                let destination = openValves.first!
                let myTravel = travelTime["\(me):\(destination.key)"]!
                let elephantTravel = travelTime["\(elephant):\(destination.key)"]!
                let iGo = findMaxTotalFlow(volcano: volcano, in: destination.key, path: myPath, totalFlow: totalFlow, minute: myMinute + myTravel + 1)
                let elephantGoes = findMaxTotalFlow(volcano: volcano, in: destination.key, path: elephantPath, totalFlow: totalFlow, minute: elephantMinute + elephantTravel + 1)
                return iGo.0 > elephantGoes.0 ? (iGo.0, iGo.1, elephantPath) : (elephantGoes.0, myPath, elephantGoes.1)
            } else {
                return (totalFlow, myPath, elephantPath)
            }
        } else if myMinute < 30 {
            let finish = findMaxTotalFlow(volcano: volcano, in: me, path: myPath, totalFlow: totalFlow, minute: myMinute)
            return (finish.0, finish.1, elephantPath)
        } else if elephantMinute < 30 {
            let finish = findMaxTotalFlow(volcano: volcano, in: elephant, path: elephantPath, totalFlow: totalFlow, minute: elephantMinute)
            return (finish.0, myPath, finish.1)
        } else {
            return (totalFlow, myPath, elephantPath)
        }
    }

    func findMaxTotalFlowWithElephant(volcano: [String: Room], destinations: [Dictionary<String, Room>.Element], me: String, elephant: String, myPath: [String], elephantPath: [String], totalFlow: Int, myMinute: Int, elephantMinute: Int) async -> (Int, [String], [String]) {
        var maximum = (0, [String](), [String]())
        for destination in destinations.permutations() {
            let myTravel = travelTime["\(me):\(destination[0].key)"]!
            let elephantTravel = travelTime["\(elephant):\(destination[1].key)"]!
            if myMinute + myTravel < 30, elephantMinute + elephantTravel < 30 {
                let flow = await findMaxTotalFlowWithElephant(volcano: volcano,
                                                              me: destination[0].key,
                                                              elephant: destination[1].key,
                                                              myPath: myPath,
                                                              elephantPath: elephantPath,
                                                              totalFlow: totalFlow,
                                                              myMinute: myMinute + myTravel + 1,
                                                              elephantMinute: elephantMinute + elephantTravel + 1)
                if me == elephant {
                    return flow
                }
                maximum = maximum.0 > flow.0 ? maximum : flow
            } else if myMinute + myTravel < 30 {
                let flow = findMaxTotalFlow(volcano: volcano, in: destination[0].key, path: myPath, totalFlow: totalFlow, minute: myMinute + myTravel + 1)
                maximum = maximum.0 > flow.0 ? maximum : (flow.0, flow.1, elephantPath)
            } else if elephantMinute + elephantTravel < 30 {
                let flow = findMaxTotalFlow(volcano: volcano, in: destination[1].key, path: elephantPath, totalFlow: totalFlow, minute: elephantMinute + elephantTravel + 1)
                maximum = maximum.0 > flow.0 ? maximum : (flow.0, myPath, flow.1)
            }
        }
        return maximum
    }

    func pathValue(_ path: [String], minute: Int) -> Int {
        var from = path.first!
        var value = 0
        var minute = minute
        for to in path[1...] {
            let destination = graph[to]!
            let travel = travelTime["\(from):\(to)"]!
            minute += travel + 1
            value += (30 - minute) * destination.flowRate
            from = to
        }
        return value
    }

    override func compute() async {
        computeTravelTimes(from: "AA")
        print("\(travelTime.count) paths")
        let part1_result = findMaxTotalFlow(volcano: graph, in: "AA")
        await MainActor.run {
            part1 = String(part1_result.0)
        }

        let part2_result = await findMaxTotalFlowWithElephant(volcano: graph, me: "AA", elephant: "AA", useTaskGroup: true)
        print("\(part2_result.1)")
        print("\(part2_result.2)")
        await MainActor.run {
            part2 = String(part2_result.0)
        }
    }
}
