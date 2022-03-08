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
    
    @IBOutlet weak var buttonLikeUnLike: UIButton!
    @IBOutlet weak var buttonSavedBooked: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelUserName.text = "ZdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlX"
        labelCountryName.text = "JdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlZ"
        
    }
}
