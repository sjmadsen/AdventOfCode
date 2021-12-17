//
//  ContentView.swift
//  AoC2021
//
//  Created by Steve Madsen on 12/16/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var day: Day
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Part 1")
                    .font(.title2)
                    .frame(width: 50, alignment: .leading)
                Text(day.part1)
                    .font(.title)
                    .textSelection(.enabled)
            }
            HStack(alignment: .firstTextBaseline) {
                Text("Part 2")
                    .font(.title2)
                    .frame(width: 50, alignment: .leading)
                Text(day.part2)
                    .font(.title)
                    .textSelection(.enabled)
            }
        }
        .onAppear {
            Task {
                await day.compute()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(day: Day1())
    }
}
