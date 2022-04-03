//
//  SavedAdviceChildCell.swift
//  MyMapp
//
//  Created by smartsense ConsultingSolutions on 03/04/22.
//

import UIKit

class SavedAdviceChildCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var buttonSaveToggle: UIButton!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelTips: UILabel!
    @IBOutlet weak var constraintBottomTopTipView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

        buttonSaveToggle.setImage(UIImage(named: "ic_SavedUnselected"), for: .normal)
        buttonSaveToggle.setImage(UIImage(named: "iconsSavedTip"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cellConfig(data: TravelAdviceDataModel, isLastCell: Bool) {
        imageViewProfilePic.backgroundColor = UIColor.green
        labelUsername.text = "labelUsername"
        labelTips.text = "labelTips labelTips labelTips labelTips labelTips labelTips"
        buttonSaveToggle.isSelected = data.isSaved
        constraintBottomTopTipView.constant = isLastCell ? 0 : 11
    }
    
}
