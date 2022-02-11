//
//  UIFont+Extensions.swift
//  MyMapp
//
//  Created by Akash on 03/01/22.
//

import Foundation
import UIKit

extension UIFont {
    
    struct Montserrat {
        static let Regular = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-Regular",size: size)!
        }
        
        static let Medium = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-Medium",size: size)!
        }
        
        static let MediumItalic = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-MediumItalic",size: size)!
        }
        
        static let SemiBold = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-SemiBold",size: size)!
        }
        
        static let Bold = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-Bold",size: size)!
        }
        
        static let regularItalic = { (size: CGFloat) -> UIFont in
            return UIFont(name: "Montserrat-Italic",size: size)!
        }
    }
    
    struct System {
        
        static let regular = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size,weight: UIFont.Weight.regular)
        }
        static let bold = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size,weight: UIFont.Weight.bold)
        }
        static let light = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size,weight: UIFont.Weight.light)
        }
        static let medium = { (size: CGFloat) -> UIFont? in
            return UIFont.systemFont(ofSize: size,weight: UIFont.Weight.medium)
        }
    }
}

//MARK: - FONTS
func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.size.width
    let calculatedFontSize = screenWidth / 375 * FontSize
    return calculatedFontSize
}
