//
//  Pivot.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/3/21.
//

import Foundation

public extension Array where Element: RandomAccessCollection {
    func pivoted() -> Array<Array<Element.Element>> {
        let innerCount = self.first?.count ?? 0
        var outer = Array<Array<Element.Element>>(repeating: [], count: innerCount)
        for i in self.indices {
            for (j, element) in self[i].enumerated() {
                outer[j].append(element)
            }
        }
        return outer
    }
}
