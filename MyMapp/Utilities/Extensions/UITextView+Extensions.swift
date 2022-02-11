//
//  UITextView+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 28/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

extension UITextView {
    func trimSpace() {
        self.text = self.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func lowercased() {
        self.text = self.text!.lowercased()
    }
}

