//
//  SavedAdviceParentCell.swift
//  MyMapp
//
//  Created by Akash  on 03/04/22.
//

import UIKit

class SavedAdviceParentCell: UITableViewCell {

    static func getCellHeight(sectionTitle: String) -> CGFloat {
        // 29 + 24 + 15 + 20
        sectionTitle.isEmpty ? 29 : 88
    }
    
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewSectionTitle: UIView!
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonArrow: UIButton!
    @IBOutlet weak var buttonDropDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

        labelSectionTitle.font = UIFont.Montserrat.SemiBold(20)
        labelSectionTitle.textColor = .App_BG_SecondaryDark2_Color
        labelSectionTitle.numberOfLines = 1

        buttonArrow.setImage(UIImage(named: "iconsArrowDown"), for: .normal)
        buttonArrow.setImage(UIImage(named: "iconsArrowUp"), for: .selected)

        viewParent.cornerRadius = 20

        cellConfigCore(isOpenCell: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigCore(isOpenCell: Bool) {
        if isOpenCell {
            labelTitle.font = UIFont.Montserrat.SemiBold(14)
            labelTitle.textColor = UIColor.App_BG_SecondaryDark2_Color
            viewParent.selectedCorners(radius: 20, [.topLeft, .topRight])
        } else {
            labelTitle.font = UIFont.Montserrat.Medium(14)
            labelTitle.textColor = UIColor.grayLightReadLessMore
            viewParent.selectedCorners(radius: 20, [.topLeft, .topRight, .bottomLeft, .bottomRight])
        }
        buttonArrow.isSelected = isOpenCell
    }
    
    func cellConfig(data: SavedAlbumDetailViewController.SectionModel) {
        cellConfigCore(isOpenCell: data.isOpenCell)
        labelSectionTitle.text = data.sectionTitle
        labelTitle.text = data.subTitle
        viewSectionTitle.isHidden = data.sectionTitle.isEmpty
    }
}
