//
//  AllNumber+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 28/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

extension Int {
    public func isZero() -> Bool {
        return self == 0
    }
}

extension Double {
    func isBetween(min: Double, max: Double) -> Bool {
        return self > min && self < max
    }
    
    func isBetweenAndIncluded(min: Double, max: Double) -> Bool {
        return self >= min && self <= max
    }
}

extension CGFloat {
    func isBetween(min: CGFloat, max: CGFloat) -> Bool {
        return self > min && self < max
    }
    
    func isBetweenAndIncluded(min: CGFloat, max: CGFloat) -> Bool {
        return self >= min && self <= max
    }
}

extension Bool {
    var isHiddenToAlpha: CGFloat {
        return self ? 0 : 1
    }
}

extension Array {
    func isLastIndex(_ index: Int) -> Bool {
        return index == self.count - 1
    }
    
    func isCount(_ number: Int) -> Bool {
        return self.count == number
    }
}

extension Array where Element == String {
    func removeEmptiesAndJoinWith(_ separator: String) -> String {
        var elements = self
        elements.removeAll(where: { $0.isEmpty })
        return elements.joined(separator: separator)
    }
}

