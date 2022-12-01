//
//  PriorityQueue.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/16/21.
//

import Foundation

public struct PriorityQueue<Element> {
    private var elements: [Element]
    private let lessThan: (Element, Element) -> Bool

    public init(_ elements: [Element] = [], compare: @escaping (Element, Element) -> Bool) {
        self.elements = []
        self.lessThan = compare
        elements.forEach { insert($0) }
    }

    public var isEmpty: Bool {
        elements.isEmpty
    }

    mutating public func insert(_ element: Element) {
        elements.append(element)
        var index = elements.count - 1
        var parent = (index - 1) / 2
        while index > 0 && lessThan(element, elements[parent]) {
            elements.swapAt(index, parent)
            index = parent
            parent = (index - 1) / 2
        }
    }

    mutating public func remove() -> Element? {
        guard !isEmpty else { return nil }
        let element = elements.removeFirst()
        if elements.count > 1 {
            elements.swapAt(0, elements.count - 1)
            var index = 0
            repeat {
                if index * 2 + 1 < elements.count && lessThan(elements[index * 2 + 1], elements[index]) {
                    elements.swapAt(index, index * 2 + 1)
                    index = index * 2 + 1
                } else if index * 2 + 2 < elements.count && lessThan(elements[index * 2 + 2], elements[index]) {
                    elements.swapAt(index, index * 2 + 2)
                    index = index * 2 + 2
                } else {
                    break
                }
            } while true
        }
        return element
    }
}

public extension PriorityQueue where Element: Comparable {
    init(_ elements: [Element] = []) {
        self.elements = []
        self.lessThan = { $0 < $1 }
        elements.forEach { insert($0) }
    }
}

extension PriorityQueue: Sequence {
    public struct Iterator: IteratorProtocol {
        private var elements: PriorityQueue

        init(elements: PriorityQueue) {
            self.elements = elements
        }

        mutating public func next() -> Element? {
            elements.remove()
        }
    }

    __consuming public func makeIterator() -> Iterator {
        return Iterator(elements: self)
    }
}
