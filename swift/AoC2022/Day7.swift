//
//  Day7.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/7/22.
//

import Foundation

class Day7: Day {
    let sample = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

    class Directory {
        var name: String
        var files: [(name: String, size: Int)] = []
        var subdirectories: [Directory] = []

        init(name: String) {
            self.name = name
        }
    }

    let input: [String]

    override init() {
        input =
            try! String(contentsOf: Bundle.main.url(forResource: "day7", withExtension: "input")!)
//            sample
                .trimmed
                .split(separator: "\n")
                .map(String.init)
        super.init()
    }

    func parse() -> Directory {
        let root = Directory(name: "/")
        var dirStack = [root]
        var current = root
        for line in input {
            let parts = line.split(separator: " ")
            if parts[0] == "$" {
                switch parts[1] {
                case "cd":
                    switch parts[2] {
                    case "/": dirStack = [root]
                    case "..": dirStack.removeLast()
                    default:
                        let subdir = current.subdirectories.first { $0.name == parts[2] }!
                        dirStack.append(subdir)
                    }
                    current = dirStack.last!
                case "ls":
                    break
                default:
                    break
                }
            } else {
                if parts[0] == "dir" {
                    let dir = Directory(name: String(parts[1]))
                    current.subdirectories.append(dir)
                } else {
                    current.files.append((name: String(parts[1]), size: Int(parts[0])!))
                }
            }
        }
        return root
    }

    func recursiveFilter(_ directory: Directory, isIncluded: (Directory) -> Bool) -> [Directory] {
        let matchingSubdirectories = directory.subdirectories.reduce([]) {
            $0 + recursiveFilter($1, isIncluded: isIncluded)
        }
        return isIncluded(directory) ? [directory] + matchingSubdirectories : matchingSubdirectories
    }

    func depthSum(of directory: Directory) -> Int {
        let childrenSize = directory.subdirectories.reduce(0) { $0 + depthSum(of: $1) }
        let filesSize = directory.files.reduce(0) { $0 + $1.size }
        return childrenSize + filesSize
    }

    override func compute() async {
        let fs = parse()
        let part1_result = recursiveFilter(fs) {
            depthSum(of: $0) < 100000
        }
            .reduce(0) { $0 + depthSum(of: $1) }
        await MainActor.run {
            part1 = String(part1_result)
        }

        let unused = 70000000 - depthSum(of: fs)
        let part2_result = recursiveFilter(fs) {
            depthSum(of: $0) >= 30000000 - unused
        }
            .map { depthSum(of: $0) }
            .min()!
        await MainActor.run {
            part2 = String(part2_result)
        }
    }
}
