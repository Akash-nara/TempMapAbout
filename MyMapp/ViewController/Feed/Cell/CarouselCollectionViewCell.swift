//
//  CarouselCollectionViewCell.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!{
        didSet{
            self.image.selectedCorners(radius: 15, [.topLeft,.topRight,.bottomLeft,.bottomRight])
        }
    }
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.image.layer.cornerRadius = 15//max(self.frame.size.width, self.frame.size.height) / 2
//        self.layer.borderWidth = 10
//        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
        

    }
}

extension UIImage {
    
    func drawOutlie(imageKeof: CGFloat = 1, color: UIColor = .App_BG_SeafoamBlue_Color)-> UIImage? {
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
}

