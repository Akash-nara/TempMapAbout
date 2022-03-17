//
//  FeaturedPlacesCVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit
import SwiftSVG

class FeaturedPlacesCVCell: UICollectionViewCell {
    
    static let cellSize = CGSize(width: 185, height: 230)
    
    @IBOutlet weak var imageViewPlace: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var buttonSaveToggle: UIButton!
    @IBOutlet weak var buttonRatings: UIButton!
    @IBOutlet weak var buttonVisitors: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewPlace.isSkeletonable = true
        
        //        imageViewPlace.backgroundColor = UIColor.green
        imageViewPlace.image = UIImage(named: "ic_Default_city_image_one")
        imageViewPlace.cornerRadius = 15
        imageViewPlace.clipsToBounds = true
        imageViewPlace.contentMode = .scaleToFill
        
        buttonSaveToggle.setImage(UIImage(named: "iconsSavedUnselected"), for: .normal)
        buttonSaveToggle.setImage(UIImage(named: "ic_down_blue_curve"), for: .selected)
        buttonSaveToggle.isSelected = false
        
        labelTitle.textColor = UIColor(named: "App_BG_SecondaryDark2_Color")
        labelTitle.numberOfLines = 1
        labelSubtitle.textColor = UIColor(named: "App_BG_SecondaryDark2_Color")
        labelSubtitle.numberOfLines = 1

//        let image = UIImage(named: "imgStarRating")?.withRenderingMode(.alwaysTemplate)
        buttonRatings.setImage(UIImage(named: "imgStarRating"), for: .normal)

        buttonRatings.titleLabel?.textColor = UIColor(named: "App_Bg_Seafoamblue_Color")
        buttonRatings.tintColor = UIColor.App_BG_SeafoamBlue_Color
        buttonVisitors.titleLabel?.textColor = UIColor(named: "App_Bg_Seafoamblue_Color")
        
//        buttonRatings.imageView?.image  = UIImage.init(named: "imgStarRating")?.withRenderingMode(.alwaysTemplate).sd_tintedImage(with: UIColor.App_BG_SeafoamBlue_Color)
        

        buttonSaveToggle.isUserInteractionEnabled = false
        buttonRatings.isUserInteractionEnabled = false
        buttonVisitors.isUserInteractionEnabled = false
    }
    
    func cellConfig(data: Any) {
        let jsn = JSON.init(data)
        
        labelTitle.text = jsn["name"].stringValue//"Las Rambla"
        labelSubtitle.text = jsn["formatted_address"].stringValue//"Catholic Church"
        
        buttonSaveToggle.isSelected = true
        buttonRatings.setTitle(" \(jsn["user_ratings_total"].intValue)", for: .normal)
        buttonVisitors.setTitle(" \(jsn["rating"].intValue)", for: .normal)
        
        imageViewPlace.showAnimatedSkeleton()
        if let photosObj = jsn["photos"].arrayValue.first, let key = photosObj["photo_reference"].string{
            let width = photosObj["width"].intValue
            let height = photosObj["height"].intValue
            let url = "https://maps.googleapis.com/maps/api/place/photo?photo_reference=\(key)&maxwidth=\(width)&maxheight=\(height)&key=\(appDelegateShared.googleKey)"
            imageViewPlace.sd_setImage(with: URL.init(string: url)) { img, eror, cache, url in
                self.imageViewPlace.hideSkeleton()
                self.imageViewPlace.image = img
            }
        }
    }
}
