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
        labelCityName.text = "ZdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlX"
        labelCountryName.text = "JdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlZ"
        labelLikedCount.text = "100"
    }
    
    func getCellHeight(data: Any, cellWidth: CGFloat) -> CGFloat {
//        let cellObj = ExploreCollectionDataCell(frame: CGRect.zero)

        let username = "ZdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlX"
        let cityname = "ZdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlX"
        let countryname = "JdmakdlalkjnsljkfnfjlkFnfljfkn fljfk fljF fljkf fjlZ"
        let likedCount = "100"

        let usernameWidth = cellWidth - 53 //(13 + 25 + 10 + 5) = 53
        let cityWidth = cellWidth - 85 // (15 + 5 + 30 + 30 + 5) = 85
        
//        let likedCountWidth = likedCount.sized(labelLikedCount.font!).width
        let likedCountWidth = likedCount.sized(UIFont.systemFont(ofSize: 15)).width
        let countryWidth = cellWidth - (15 + 10 + likedCountWidth + 5)

        let usernameHeight = Utility.heightForView(username, font: labelUserName.font!, width: usernameWidth)
        let citynameHeight = Utility.heightForView(cityname, font: labelCityName.font!, width: cityWidth)
        let countrynameHeight = Utility.heightForView(countryname, font: labelCountryName.font!, width: countryWidth)
        
        // 15 + max(25, Username) + 15 + 140 + 15 + max(30, Cityname) + 5 + max(18, Countryname) + 15
        // 15 + 15 + 140 + 15 + 5 + 15 = 205
        let totalHeight = 205 + max(25, usernameHeight) + max(30, citynameHeight) + max(18, countrynameHeight)
        
        return totalHeight
    }

}
