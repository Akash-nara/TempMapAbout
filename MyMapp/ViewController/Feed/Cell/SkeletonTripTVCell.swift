//
//  SkeletonTripTVCell.swift
//  MyMapp
//
//  Created by Akash on 17/02/22.
//

import UIKit
import SkeletonView

class SkeletonTripTVCell: UITableViewCell {

    @IBOutlet weak var stripeOne: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.stripeOne.layer.cornerRadius = 4.0
        self.stripeOne.clipsToBounds = true
        self.stripeOne.isSkeletonable = true
    }
    
    func startAnimating(index: Int) {
        self.stripeOne.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.stripeOne.hideSkeleton()
    }

}
