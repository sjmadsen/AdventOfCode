//
//  Day20.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/20/22.
//

import Foundation

class Day20: Day {
    let sample = """
1
2
-3
3
-2
0
4
"""

    typealias Element = (position: Int, value: Int)
    let input: [Element]

    override init() {
        input =
        try! String(contentsOf: Bundle.main.url(forResource: "day20", withExtension: "input")!)
//        sample
            .trimmed
            .split(separator: "\n")
            .enumerated()
            .map { (position: $0, value: Int(String($1))!) }
        super.init()
    }

    func mix(_ list: [Element]) -> [Element] {
        var mixed = list
        for i in 0..<mixed.count {
            let old = mixed[i].position
            let new = offset(old, by: mixed[i].value, max: mixed.count)
            for j in 0..<mixed.count {
                if new < old, mixed[j].position >= new, mixed[j].position < old {
                    mixed[j].position = (mixed[j].position + 1) % mixed.count
                } else if new > old, mixed[j].position > old, mixed[j].position <= new {
                    mixed[j].position = (mixed[j].position - 1 + mixed.count) % mixed.count
                }
            }
            mixed[i].position = new
        }
        return mixed
    }

    func offset(_ index: Int, by offset: Int, max: Int) -> Int {
        var new = index + offset
        if new < 0 {
            new = new % (max - 1) + (max - 1)
        }
        if new >= max {
            new = new % (max - 1)
        }
        return new
    }

    func valueAt(_ index: Int, _ list: [Element]) -> Int {
        list[index % list.count].value
    }

    override func compute() async {
        let mixed = mix(input).sorted { $0.position < $1.position }
        print(mixed.sorted { $0.position < $1.position })
        var zero = mixed.firstIndex { $0.value == 0 }!
        let part1_result = valueAt(zero + 1000, mixed) + valueAt(zero + 2000, mixed) + valueAt(zero + 3000, mixed)
        await MainActor.run {
            part1 = String(part1_result)
        }

        var decrypted = input.map { (position: $0.position, value: $0.value * 811589153) }
        for _ in 1...10 {
            decrypted = mix(decrypted)
            print(decrypted.sorted { $0.position < $1.position }.map(\.value))
        }
        decrypted.sort { $0.position < $1.position }
        zero = decrypted.firstIndex { $0.value == 0 }!
        let part2_result = valueAt(zero + 1000, decrypted) + valueAt(zero + 2000, decrypted) + valueAt(zero + 3000, decrypted)
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
