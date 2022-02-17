//
//  FeedTableViewCell.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import UIKit
import SDWebImage

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postedUserPic: UIImageView!
    @IBOutlet weak var commentedUserPic: UIImageView!
    @IBOutlet weak var postedUserName: UILabel!
    @IBOutlet weak var postedUserAddress: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var labelExpDescription: UILabel!
    @IBOutlet weak var labelTotalLikeCount: UILabel!
    @IBOutlet weak var labelTotaBookmarkCount: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
        
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentedUserPic.setImage(url: APP_USER?.profilePicPath ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
    }
    
    func configureCell(modelData:TripDataModel){
        labelExpDescription.text = modelData.tripDescription
        postedUserAddress.text = modelData.city.cityName+","+modelData.city.countryName
        postedDate.text = modelData.dateFromatedOftrip
        labelTotalLikeCount.text = "\(modelData.likedTotalCount)"
        labelTotaBookmarkCount.text = "\(modelData.bookmarkedTotalCount)"
        buttonBookmark.isSelected = modelData.isBookmarked
        buttonLike.isSelected = modelData.isLiked
        
    }
}
