//
//  TripPageDetailimage.swift
//  MyMapp
//
//  Created by Chirag Pandya on 09/12/21.
//

import UIKit

class TripPageDetailimage: UICollectionViewCell {
    
    @IBOutlet weak var imgviewBG: UIImageView!
    @IBOutlet weak var imgConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgviewBG.contentMode = .scaleToFill
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           
            setNeedsLayout()
            layoutIfNeeded()
           
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var frame = layoutAttributes.frame
            frame.size.height = ceil(size.height)
            layoutAttributes.frame = frame
            return layoutAttributes
        }

}
