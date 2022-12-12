//
//  AoC2022App.swift
//  AoC2022
//
//  Created by Steve Madsen on 12/1/22.
//

import SwiftUI

class Day: ObservableObject {
    @MainActor @Published var part1 = ""
    @MainActor @Published var part2 = ""

    func compute() async {}
}

@main
struct AoC2022App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(day: Day12())
                .frame(width: 350, height: 100)
        }
    }
}
