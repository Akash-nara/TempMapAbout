//
//  CarouselCollectionViewCell.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit
import SkeletonView

class CarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tripImage: UIImageView!{
        didSet{
            self.tripImage.selectedCorners(radius: 15, [.topLeft,.topRight,.bottomLeft,.bottomRight])
        }
    }
    
    @IBOutlet weak var sketonView: UIView!
    
    static let identifier = "CarouselCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sketonView.isSkeletonable = true
        self.sketonView.layer.cornerRadius = 15
        self.sketonView.clipsToBounds = true
//        self.tripImage.roundCornersWithBorder(corners: [.topLeft, .topRight, .bottomLeft,.bottomRight], radius: 15)
        tripImage.cornerRadius = 15
    }
    
    func startAnimating() {
        sketonView.isHidden = false
        self.sketonView.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.sketonView.hideSkeleton()
        sketonView.isHidden = true
    }
    
    func configureCell(model:TripDataModel.TripPhotoDetails.TripImage){
        
        tripImage.contentMode = .scaleToFill
        startAnimating()
        tripImage.sd_setImage(with: URL.init(string: model.image), placeholderImage: nil, options: .highPriority) { img, error, caceh, url in
            if let lodedImage = img{
                self.stopAnimating()
                self.tripImage.image = lodedImage.withRoundedCorners(radius: 15)
                self.tripImage.image = self.tripImage.image?.drawOutlie()
            }
        }
        //        tripImage.setImage(url: model.image, placeholder: nil)
    }
}
