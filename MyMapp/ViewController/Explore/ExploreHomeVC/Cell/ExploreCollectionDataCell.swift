//
//  ExploreCollectionDataCell.swift
//  MyMapp
//
//  Created by Akash on 07/03/22.
//

import UIKit

class ExploreCollectionDataCell: UICollectionViewCell {

    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var labelLikedCount: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCountryName: UILabel!
    @IBOutlet weak var imgTripThumnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
