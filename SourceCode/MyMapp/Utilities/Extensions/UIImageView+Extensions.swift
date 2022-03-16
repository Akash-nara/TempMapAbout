//
//  UIImageView+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 24/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(url: String, placeholder: UIImage?) {
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .highPriority, completed: {(image, error, type, url) in
        })
    }
}
extension UIImageView {
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
    
    
}


extension UIImage {
    
    // returns a scaled version of the image
    func imageScaledToSize(size : CGSize, isOpaque : Bool) -> UIImage? {
        
        // begin a context of the desired size
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        
        // draw image in the rect with zero origin and size of the context
        let imageRect = CGRect(origin: .zero, size: size)
        self.draw(in: imageRect)
        
        // get the scaled image, close the context and return the image
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage? {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resized(By coefficient:CGFloat) -> UIImage? {
        
        guard coefficient >= 0 && coefficient <= 1 else {
            
            print("The coefficient must be a floating point number between 0 and 1")
            return nil
        }
        
        let newWidth = size.width * coefficient
        let newHeight = size.height * coefficient
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    var getWidth: CGFloat {
        get {
            let width = self.size.width
            return width
        }
    }
    
    var getHeight: CGFloat {
        get {
            let height = self.size.height
            return height
        }
    }
    
    func drawOutlie(imageKeof: CGFloat = 1.011, color: UIColor = .App_BG_silver_Color)-> UIImage? {
        let outlinedImageRect = CGRect(x: 0.0, y: 0.0, width: size.width * imageKeof, height: size.height * imageKeof)
        let imageRect = CGRect(x: self.size.width * (imageKeof - 1) * 0.5, y: self.size.height * (imageKeof - 1) * 0.5, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(outlinedImageRect.size, false, imageKeof)
        draw(in: outlinedImageRect)
        let context = UIGraphicsGetCurrentContext()
        context!.setBlendMode(.sourceIn)
        context!.setFillColor(color.cgColor)
        context!.fill(outlinedImageRect)
        draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
}

