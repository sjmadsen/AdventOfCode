//: [Previous](@previous)

import Foundation

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

var fish = convertInput([3,4,3,1,2])
for _ in 1...80 {
    fish = age(fish)
}

print(fish.keys.reduce(0) { $0 + fish[$1, default: 0] })

let input = try String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "")!).split(separator: "\n")[0].split(separator: ",").map { Int($0)! }
fish = convertInput(input)
for _ in 1...80 {
    fish = age(fish)
}

print(fish.keys.reduce(0) { $0 + fish[$1, default: 0] })

fish = convertInput(input)
for _ in 1...256 {
    fish = age(fish)
}

print(fish.keys.reduce(0) { $0 + fish[$1, default: 0] })

//: [Next](@next)
