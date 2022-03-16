//
//  FeaturedPlacesCVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit
import SwiftSVG

class FeaturedPlacesCVCell: UICollectionViewCell {

    static let cellSize = CGSize(width: 185, height: 219)
    
    @IBOutlet weak var imageViewPlace: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var buttonSaveToggle: UIButton!
    @IBOutlet weak var buttonRatings: UIButton!
    @IBOutlet weak var buttonVisitors: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        imageViewPlace.backgroundColor = UIColor.green
        imageViewPlace.image = UIImage(named: "ic_Default_city_image_one")
        imageViewPlace.cornerRadius = 15
        imageViewPlace.clipsToBounds = true
        imageViewPlace.contentMode = .scaleToFill
        
        buttonSaveToggle.setImage(UIImage(named: "iconsSavedUnselected"), for: .normal)
        buttonSaveToggle.setImage(UIImage(named: "ic_down_blue_curve"), for: .selected)
        buttonSaveToggle.isSelected = false
        
        labelTitle.textColor = UIColor(named: "App_BG_SecondaryDark2_Color")
        labelSubtitle.textColor = UIColor(named: "App_BG_SecondaryDark2_Color")

        buttonRatings.titleLabel?.textColor = UIColor(named: "App_Bg_Seafoamblue_Color")
        buttonRatings.tintColor = UIColor(named: "App_Bg_Seafoamblue_Color")
        buttonVisitors.titleLabel?.textColor = UIColor(named: "App_Bg_Seafoamblue_Color")

        buttonSaveToggle.isUserInteractionEnabled = false
        buttonRatings.isUserInteractionEnabled = false
        buttonVisitors.isUserInteractionEnabled = false
    }

    func cellConfig(data: Any) {
        
        labelTitle.text = "Las Rambla"
        labelSubtitle.text = "Catholic Church"
        
        buttonSaveToggle.isSelected = true
        
        buttonRatings.setTitle(" \(4.3)", for: .normal)
        buttonVisitors.setTitle(" \(40)", for: .normal)
    }
    
}
