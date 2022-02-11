//
//  UIView-Extensions.swift
//  MyMapp
//
//  Created by Akash Nara on 19/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

extension UIView {
    //MARK: - VIBRATE
    enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        @available(iOS 13.0, *)
        case soft
        @available(iOS 13.0, *)
        case rigid
        case selection
        case oldSchool
        
        public func vibrate() {
            switch self {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .light:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case .medium:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case .heavy:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case .soft:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            case .selection:
                UISelectionFeedbackGenerator().selectionChanged()
            case .oldSchool:
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func makeRoundByCorners(){
        self.cornerRadius = self.bounds.height / 2.0
    }
    
    enum enumCorners { case topLeft, topRight, bottomLeft, bottomRight }
    
    func selectedCorners(radius: CGFloat, _ corners: [enumCorners]){
        self.layer.cornerRadius = radius
        var arrayCorners = [CACornerMask]()
        corners.forEach { (corners) in
            switch corners {
            case .topLeft: arrayCorners.append(.layerMinXMinYCorner)
            case .topRight: arrayCorners.append(.layerMaxXMinYCorner)
            case .bottomLeft: arrayCorners.append(.layerMinXMaxYCorner)
            case .bottomRight: arrayCorners.append(.layerMaxXMaxYCorner)
            }
        }
        self.layer.maskedCorners = CACornerMask(arrayCorners)
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addDashedBorder(color: UIColor) {
        layoutIfNeeded()
        let shapeRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = color.cgColor
        yourViewBorder.frame = bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.lineWidth = 2
        yourViewBorder.lineJoin = CAShapeLayerLineJoin.round
        yourViewBorder.lineDashPattern = [4,4]
        yourViewBorder.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        yourViewBorder.accessibilityLabel = "addDashedBorder"
        layer.addSublayer(yourViewBorder)
    }
}

extension UIView {
    // centerX and centerY constraint
    func addCenterX(inSuperView superView: UIView){
        superView.addConstraint(NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: superView.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1.0, constant: 0))
    }
    func addCenterY(inSuperView superView: UIView, multiplier: CGFloat = 1.0){
        superView.addConstraint(NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: superView.safeAreaLayoutGuide, attribute: .centerY, multiplier: multiplier, constant: 0))
    }
    
    // Edusense Take These two methods, having relateToView params
    @discardableResult
    func addCenterX(inSuperView superView: UIView, relateToView relateView: UIView) -> NSLayoutConstraint {
        let centerXConstraint = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: relateView, attribute: .centerX, multiplier: 1.0, constant: 0)
        superView.addConstraint(centerXConstraint)
        return centerXConstraint
    }
    @discardableResult
    func addCenterY(inSuperView superView: UIView, relateToView relateView: UIView, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let centerYConstraint = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: relateView, attribute: .centerY, multiplier: multiplier, constant: 0)
        superView.addConstraint(centerYConstraint)
        return centerYConstraint
    }
    
    // width and height constraints
    @discardableResult
    func addWidth(constant: Double) -> NSLayoutConstraint {
        let widthConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(constant))
        self.addConstraint(widthConstraint)
        return widthConstraint
    }
    @discardableResult
    func addHeight(constant: Double) -> NSLayoutConstraint {
        let heightConstraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(constant))
        self.addConstraint(heightConstraint)
        return heightConstraint
    }
    
    // left, top, bottom, right constraints
    @discardableResult
    func addLeft(isSuperView superView: UIView, constant: Float) -> NSLayoutConstraint  {
        let leftConstraint = NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: superView.safeAreaLayoutGuide, attribute: .left, multiplier: 1.0, constant: CGFloat(constant))
        superView.addConstraint(leftConstraint)
        return leftConstraint
    }
    @discardableResult
    func addTop(isSuperView superView: UIView, constant: Float, toSafeArea: Bool = true) -> NSLayoutConstraint {
        let superViewLayout = toSafeArea ? superView.safeAreaLayoutGuide : superView
        let topConstraint = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: superViewLayout, attribute: .top, multiplier: 1.0, constant: CGFloat(constant))
        superView.addConstraint(topConstraint)
        return topConstraint
    }
    func addTop(isRelateTo relateView: UIView, isSuperView superView: UIView, constant: Float) {
        superView.addConstraint(NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: relateView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: CGFloat(constant)))
    }
    @discardableResult
    func addBottom(isSuperView superView: UIView, constant: Float, toSafeArea: Bool = true) -> NSLayoutConstraint {
        let superViewLayout = toSafeArea ? superView.safeAreaLayoutGuide : superView
        let bottomConstraint = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: superViewLayout, attribute: .bottom, multiplier: 1.0, constant: CGFloat(constant))
        superView.addConstraint(bottomConstraint)
        return bottomConstraint
        
    }
    @discardableResult
    func addRight(isSuperView superView: UIView, constant: Float) -> NSLayoutConstraint{
        let rightConstraint = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: superView.safeAreaLayoutGuide, attribute: .right, multiplier: 1.0, constant: CGFloat(constant))
        superView.addConstraint(rightConstraint)
        return rightConstraint
    }
    @discardableResult
    func addRight(isSuperView superView: UIView, constant: Float, relatedBy:NSLayoutConstraint.Relation) -> NSLayoutConstraint{
        let rightConstraint = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: relatedBy, toItem: superView.safeAreaLayoutGuide, attribute: .right, multiplier: 1.0, constant: CGFloat(constant))
        superView.addConstraint(rightConstraint)
        return rightConstraint
    }
    func addSurroundingZero(isSuperView superView: UIView, constant: Float = 0.0) {
        self.addLeft(isSuperView: superView, constant: constant)
        self.addRight(isSuperView: superView, constant: -constant)
        self.addTop(isSuperView: superView, constant: constant)
        self.addBottom(isSuperView: superView, constant: -constant)
    }
    func addSurroundingZeroToSuperView(isSuperView superView: UIView, constant: Float = 0.0) {
        self.addLeft(isSuperView: superView, constant: constant)
        self.addRight(isSuperView: superView, constant: -constant)
        self.addTop(isSuperView: superView, constant: constant, toSafeArea: false)
        self.addBottom(isSuperView: superView, constant: -constant, toSafeArea: false)
    }
    func addLeftRightWithZero(isSuperView superView: UIView) {
        self.addLeft(isSuperView: superView, constant: 0)
        self.addRight(isSuperView: superView, constant: 0)
    }
}

extension UIView {
    func applyShadow(cornerRadius:CGFloat = 0, shadowOpacity:CGFloat = 0.3, size:CGSize = CGSize(width: 0, height: 0), shadowRadius:CGFloat = 1, shadowColor:UIColor = .black){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
    }
    
    func applyShadowWithAboveBordersOnly(cornerRadius:CGFloat = 0, shadowOpacity:CGFloat = 0.3, size:CGSize = CGSize(width: 0, height: 0), shadowRadius:CGFloat = 1, shadowColor:UIColor = .black){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func applyShadowWithBelowBordersOnly(cornerRadius:CGFloat = 0, shadowOpacity:CGFloat = 0.3, size:CGSize = CGSize(width: 0, height: 0), shadowRadius:CGFloat = 1, shadowColor:UIColor = .black){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func applyShadowJob(cornerRadius:CGFloat = 8.3){
        applyShadow(cornerRadius: cornerRadius, shadowOpacity: 0.16, size: CGSize(width: 0, height: 1), shadowRadius: 2)
    }
    
    func applyShadowJobWithAboveBordersOnly(cornerRadius:CGFloat = 8.3){
        applyShadowWithAboveBordersOnly(cornerRadius: cornerRadius, shadowOpacity: 0.16, size: CGSize(width: 0, height: 1), shadowRadius: 2)
    }
    
    func applyShadowJobWithBelowBordersOnly(cornerRadius:CGFloat = 8.3){
        applyShadowWithBelowBordersOnly(cornerRadius: cornerRadius, shadowOpacity: 0.16, size: CGSize(width: 0, height: 1), shadowRadius: 2)
    }
}

extension UIView {
    func setShadow(obj:Any, cornurRadius:CGFloat, ClipToBound:Bool, masksToBounds:Bool, shadowColor:String, shadowOpacity:Float, shadowOffset:CGSize, shadowRadius:CGFloat, shouldRasterize:Bool, shadowPath:CGRect) {
        if obj is UIView {
            let tempView:UIView = obj as! UIView
            tempView.clipsToBounds = ClipToBound
            tempView.layer.cornerRadius = cornurRadius
            tempView.layer.shadowOffset = shadowOffset
            tempView.layer.shadowOpacity = shadowOpacity
            tempView.layer.shadowRadius = shadowRadius
            tempView.layer.shadowColor = UIColor.lightGray.cgColor
            tempView.layer.masksToBounds =  masksToBounds
            tempView.layer.shouldRasterize = shouldRasterize
            tempView.layer.rasterizationScale = UIScreen.main.scale
            tempView.layer.shadowPath = UIBezierPath(roundedRect: tempView.bounds, cornerRadius: cornurRadius).cgPath
        }
    }
    
    func dropShadowButton() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.cornerRadius = 20
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeShadowButton() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shouldRasterize = true
        layer.cornerRadius = 20
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func LightdropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowWithColor(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func ShadowWithColor(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowWithRadius(cornerRadius:CGFloat,scale: Bool = true){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.cornerRadius = cornerRadius
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        Vibration.success.vibrate()
    }
    
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
}
