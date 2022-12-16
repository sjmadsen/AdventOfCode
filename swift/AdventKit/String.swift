//
//  StringProtocol.swift
//  AdventKit
//
//  Created by Steve Madsen on 12/15/22.
//

import Foundation

public extension StringProtocol {
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
}
