//
//  AoC2021App.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI

class Day: ObservableObject {
    @MainActor @Published var part1 = ""
    @MainActor @Published var part2 = ""

    func compute() async {}
}

@main
struct AoC2021App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(day: Day16())
                .frame(width: 350, height: 100)
        }
    }
}
