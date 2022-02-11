//
//  ClassOverloading.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 17/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

class IphoneSEConstraint: NSLayoutConstraint{
    @IBInspectable var SEConstant: CGFloat {
        get { return self.constant }
        set { self.constant = cueDevice.isDeviceSEOrLower ? newValue : constant }
    }
}

class SEStackView: UIStackView{
    @IBInspectable var SESpace: CGFloat {
        get { return self.spacing }
        set { if cueDevice.isDeviceSEOrLower { self.spacing = newValue } }
    }
}

