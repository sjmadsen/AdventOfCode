//
//  Trimmed.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/12/21.
//

import Foundation

public extension StringProtocol {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
