//
//  ThreeStripesWithGapInLastTVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 19/08/21.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit
import SkeletonView

class SkeletonTripCVCell: UICollectionViewCell {
        
    @IBOutlet weak var stripeOne: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.stripeOne.layer.cornerRadius = 4.0
        self.stripeOne.clipsToBounds = true
        
        self.stripeOne.isSkeletonable = true
    }
    
    func startAnimating(index: Int) {
//        self.viewOfSeparator.isHidden = false
//        if index == 0 {
//            self.viewOfSeparator.isHidden = true
//        }
        self.stripeOne.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.stripeOne.hideSkeleton()
    }
    
}
