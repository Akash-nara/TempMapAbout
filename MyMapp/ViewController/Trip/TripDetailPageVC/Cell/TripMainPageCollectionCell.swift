//
//  TripMainPageCollectionCell.swift
//  MyMapp
//
//  Created by Akash on 01/02/22.
//

import Foundation
import UIKit
import SkeletonView

class TripMainPageCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgviewZoom: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var sketonView: UIView!

    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func configureSkelton(){
        sketonView.isSkeletonable = true
        self.sketonView.layer.cornerRadius = 15
        self.sketonView.clipsToBounds = true
    }
    func startAnimating() {
        sketonView.isHidden = false
        self.sketonView.showAnimatedSkeleton()
    }

    func stopAnimating() {
        self.sketonView.hideSkeleton()
        sketonView.isHidden = true
    }

}
