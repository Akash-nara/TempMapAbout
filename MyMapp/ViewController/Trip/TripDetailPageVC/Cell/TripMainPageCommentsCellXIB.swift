//
//  TripMainPageCommentsCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class TripMainPageCommentsCellXIB: UITableViewCell {

    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var buttonLiked: UIButton!
    @IBOutlet weak var imgUserCommented: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func loadCellData(model:TripCommmnets){
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
        let str = model.comment.isEmpty ? "Such a cool trip it seems. Thank you for sharing with us." :  model.comment
        let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
        guard let username = UserManager.getLoggedInUser()?.displayName else {
            return
        }

        let attributedString1 = NSMutableAttributedString(string:"\(username)  ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:str, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        lblComment.attributedText = attributedString1
        
        if let profilePicPath = UserManager.getLoggedInUser()?.profilePicPath{
            imgUserCommented.sd_setImage(with: URL.init(string: profilePicPath), placeholderImage: UIImage.init(named: "ic_user_image_defaulut_one"))
        }

        buttonLiked.setImage(UIImage(named: "iconsHeartSelected"), for: .selected)
        buttonLiked.setImage(UIImage(named: "ic_Heart_unselected"), for: .normal)
        buttonLiked.isSelected = model.likeUnLiked
    }
}
