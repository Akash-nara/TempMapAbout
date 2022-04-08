//
//  SavedAdviceChildCell.swift
//  MyMapp
//
//  Created by Akash  on 03/04/22.
//

import UIKit

class SavedAdviceChildCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var buttonSaveToggle: UIButton!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelTips: LessMoreCustomizeLabel!
    @IBOutlet weak var constraintBottomTopTipView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

        buttonSaveToggle.setImage(UIImage(named: "ic_SavedUnselected"), for: .normal)
        buttonSaveToggle.setImage(UIImage(named: "iconsSavedTip"), for: .selected)
        
        labelTips.textColor = UIColor.App_BG_SecondaryDark2_Color
        labelTips.numberOfLines = 0
        labelTips.seeMoreLessColor = UIColor.grayLightReadLessMore
        labelTips.setTextFont = UIFont.Montserrat.Medium(14)
        labelTips.seeMoreLessFont = UIFont.Montserrat.Medium(12.7)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cellConfig(data: TravelAdviceDataModel, isLastCell: Bool) {
        imageViewProfilePic.backgroundColor = UIColor.green
        labelUsername.text = data.userName
        labelTips.text = data.savedComment
        buttonSaveToggle.isSelected = data.isSaved
        constraintBottomTopTipView.constant = isLastCell ? 0 : 11
        imageViewProfilePic.setImage(url: data.userProfilePic, placeholder: UIImage.init(named: "not_icon"))
        imageViewProfilePic.setBorderWithColor()
    }
    
}
