//: [Previous](@previous)

import Foundation

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")

// Part 1
input
    .map {
        $0.split(separator: " ")
            .split(separator: "|")
            .last!
            .reduce(0) {
                $0 + ([2, 3, 4, 7].contains($1.count) ? 1 : 0)
            }
    }
    .reduce(0, +)

// Part 2
// 0: 6 segments on abcefg (d off)
// 1: 2 segments on cf
// 2: 5 segments on acdeg  (b,f off)
// 3: 5 segments on acdfg  (b,e off)
// 4: 4 segments on bcdf
// 5: 5 segments on abdfg  (c,e off)
// 6: 6 segments on abdefg (c off)
// 7: 3 segments on acf
// 8: 7 segments on abcdefg
// 9: 6 segments on abcdfg (e off)

input
    .map {
        let line = $0.split(separator: " ")
            .map { String($0).map(String.init).sorted().joined() }
            .split(separator: "|")
        let signal = line[0]
        let output = line[1]
        var mapping = [Character: Set<Character>]()
        Array("abcdefg").forEach { mapping[$0] = Set("abcdefg") }
        signal.forEach {
            switch $0.count { // the number of "on" segments
            // 2, 3, and 4 segments "on" map to exactly one possible digit each, so we know which segments aren't possible
            case 2: $0.map { mapping[$0]?.subtract("abdeg") }
            case 3: $0.map { mapping[$0]?.subtract("bdeg") }
            case 4: $0.map { mapping[$0]?.subtract("aeg") }
            default: break
            }
        }

        // Collect all of the six segment signals.
        // "abfg" are always "on"
        // The segment common with the possibles that form a 1 tells us what maps to "f"
        let sixes = signal.filter { $0.count == 6 }
        let oneSegments = mapping.keys.filter { mapping[$0] == Set("cf") }
        if oneSegments.count > 1 {
            let f = sixes
                .map { Set($0) }
                .reduce(Set("abcdefg")) { $0.intersection($1) }
                .intersection(oneSegments)
            mapping[f.first!] = Set("f")
        }

        // Collect all of the five segment signals.
        // "adg" are always "on"
        // The segment common with the possibles that form a 4 tells us what maps to "d"
        let fives = signal.filter { $0.count == 5 }
        let fourSegments = mapping.keys.filter { mapping[$0] == Set("bcdf") }
        if fourSegments.count > 1 {
            let d = fives
                .map { Set($0) }
                .reduce(Set("abcdefg")) { $0.intersection($1) }
                .intersection(fourSegments)
            mapping[d.first!] = Set("d")
        }

        while mapping.contains(where: { (_, possibles) in possibles.count > 1 }) {
            // Any mapping with exactly one possibility can't be a candidate for another segment
            mapping.keys.filter { mapping[$0]!.count == 1 }
                .forEach { mapped in
                    Set("abcdefg")
                        .subtracting([mapped])
                        .forEach { wire in
                            let eliminate = Set(mapping[mapped]!)
                            mapping[wire]?.subtract(eliminate)
                        }
                }

            let ambiguous = mapping.filter({ $0.value.count >= 2 })
            if ambiguous.count == 2 {
                // Disambiguate between the two segments that map to "e" and "g"
                // "g" is always on for a six segment signal
                let g = sixes
                    .reduce(Set(ambiguous.map { $0.key })) {
                        $0.intersection($1)
                    }
                mapping[g.first!] = Set("g")
            }
        }

        return Int(output
                .map {
                    digit(for: $0, with: mapping)
                }
                .joined()
            )!
    }
    .reduce(0, +)

func digit(for segments: String, with mapping: [Character: Set<Character>]) -> String {
    let digits = [
        "abcefg": "0", "cf": "1", "acdeg": "2", "acdfg": "3", "bcdf": "4",
        "abdfg": "5", "abdefg": "6", "acf": "7", "abcdefg": "8", "abcdfg": "9"
    ]

    let converted = segments.map { String(mapping[$0]!.first!) }.sorted().joined()
    return digits[converted]!
}

func debug(_ mapping: [Character: Set<Character>]) {
    print(mapping
        .map {
            [$0.key: String($0.value.sorted())]
        })
}

//: [Next](@next)
