//
//  UIColor+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara on 30/12/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    static func getColorIntoHex(Hex:String) -> UIColor {
        if Hex.isEmpty {
            return UIColor.clear
        }
        let scanner = Scanner(string: Hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return UIColor.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
}
