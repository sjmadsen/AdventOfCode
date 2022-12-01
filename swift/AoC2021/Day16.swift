//
//  Day16.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI
import AdventKit
import Algorithms

class Day16: Day {
    let sample = "A0016C880162017C3686B18A3D4780"

    let input: String

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day16", withExtension: "input")!)
            .trimmed
            .map {
                "000\(String(Int(String($0), radix: 16)!, radix: 2))".suffix(4)
            }
            .joined(separator: "")
        super.init()
    }

    override func compute() async {
        func decode(bitStream: String) -> (Packet?, String) {
            guard bitStream.count > 6 else { return (nil, bitStream) }
            var bits = bitStream
            let version = Int(bits.consume(3), radix: 2)!
            let type = Int(bits.consume(3), radix: 2)!
            if type == 4 {
                var binary = ""
                repeat {
                    let chunk = bits.consume(5)
                    binary += chunk[chunk.index(chunk.startIndex, offsetBy: 1)...]
                    if chunk.prefix(1) != "1" {
                        break
                    }
                } while true
                return (Literal(version: version, value: Int(binary, radix: 2)!), bits)
            } else {
                let subpackets = decodeSubpackets(bits: &bits)
                switch type {
                case 0: return (Sum(version: version, subpackets: subpackets), bits)
                case 1: return (Product(version: version, subpackets: subpackets), bits)
                case 2: return (Minimum(version: version, subpackets: subpackets), bits)
                case 3: return (Maximum(version: version, subpackets: subpackets), bits)
                case 5: return (GreaterThan(version: version, subpackets: subpackets), bits)
                case 6: return (LessThan(version: version, subpackets: subpackets), bits)
                case 7: return (EqualTo(version: version, subpackets: subpackets), bits)
                default: return (nil, bits)
                }
            }
        }

        func decodeSubpackets(bits: inout String) -> [Packet] {
            if bits.consume(1) == "0" {
                let totalLength = Int(bits.consume(15), radix: 2)!
                var subPacketBits = String(bits.consume(totalLength))
                var subpackets = [Packet]()
                repeat {
                    let (packet, remaining) = decode(bitStream: subPacketBits)
                    guard let packet = packet else { break }
                    subpackets.append(packet)
                    subPacketBits = remaining
                } while true
                return subpackets
            } else {
                let count = Int(bits.consume(11), radix: 2)!
                var subpackets = [Packet]()
                for _ in 1...count {
                    let (packet, remaining) = decode(bitStream: bits)
                    subpackets.append(packet!)
                    bits = remaining
                }
                return subpackets
            }
        }

        func flatten(_ packets: [Packet]) -> [Packet] {
            packets.reduce([]) {
                switch $1 {
                case is Literal: return $0 + [$1]
                case let op as Operator: return $0 + [$1] + flatten(op.subpackets)
                default: return $0
                }
            }
        }

        let (packet, _) = decode(bitStream: input)
        let p1 = flatten([packet!])
            .reduce(0) { $0 + $1.version }
        await MainActor.run {
            part1 = String(p1)
        }

        let p2 = packet!.value
        await MainActor.run {
            part2 = String(p2)
        }
    }
}

protocol Packet {
    var version: Int { get }
    var value: Int { get }
}

protocol Operator: Packet {
    var subpackets: [Packet] { get }
}

struct Literal: Packet {
    let version: Int
    let value: Int
}

struct Sum: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets.reduce(0) { $0 + $1.value }
    }
}

struct Product: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets.reduce(1) { $0 * $1.value }
    }
}

struct Minimum: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets.map(\.value).min()!
    }
}

struct Maximum: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets.map(\.value).max()!
    }
}

struct GreaterThan: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets[0].value > subpackets[1].value ? 1 : 0
    }
}

struct LessThan: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets[0].value < subpackets[1].value ? 1 : 0
    }
}

struct EqualTo: Operator {
    let version: Int
    let subpackets: [Packet]

    var value: Int {
        subpackets[0].value == subpackets[1].value ? 1 : 0
    }
}

extension String {
    mutating func consume(_ k: Int = 1) -> Substring {
        defer { self.removeFirst(k) }
        return self[startIndex..<index(startIndex, offsetBy: k)]
    }
}
