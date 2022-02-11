//
//  UITextField+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara on 28/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func trimSpace() {
        self.text = self.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func lowercased() {
        self.text = self.text!.lowercased()
    }
    
    func getText() -> String {
        guard let currentText = text else { return "" }
        return currentText.trimSpace()
    }
    
    func getShouldChangedText(range:NSRange, replacementString:String) -> String {
        guard let currentText = text else { return "" }
        return currentText.trimSpaceAndNewline
    }
    
    func getSearchText(range:NSRange, replacementString:String) -> String {
        if let textFieldString = self.text, let swtRange = Range(range, in: textFieldString) {
            let fullString = textFieldString.replacingCharacters(in: swtRange, with: replacementString)
            return fullString
        }
        return ""
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
