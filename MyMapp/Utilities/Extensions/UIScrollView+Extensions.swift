//
//  UIScrollView+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara on 07/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func addBounceViewAtTop(withColor color: UIColor = UIColor.red) {
        // top space, when pull happens
        var frame = self.bounds
        frame.origin.y = -frame.size.height
        let grayView = UIView(frame: frame)
        grayView.backgroundColor = color
        self.addSubview(grayView)
    }
}
