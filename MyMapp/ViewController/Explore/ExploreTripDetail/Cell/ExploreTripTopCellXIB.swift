//
//  ExploreTripTopCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class ExploreTripTopCellXIB: UITableViewCell {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewExpand: UIView!
    @IBOutlet weak var labelSubTitle: LessMoreCustomizeLabel!

    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var trealingViewExpand: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrainOfMainStackView: NSLayoutConstraint!
    @IBOutlet weak var userIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        
        labelSubTitle.textColor = UIColor.App_BG_SecondaryDark2_Color
        labelSubTitle.numberOfLines = 0
        labelSubTitle.seeMoreLessColor = UIColor.grayLightReadLessMore
        labelSubTitle.setTextFont = UIFont.Montserrat.Medium(14)
        labelSubTitle.seeMoreLessFont = UIFont.Montserrat.Medium(12.7)
        labelSubTitle.isNeedToUnderlineSeeMoreSeeLess = false

    }
    
    @IBAction func controllExpandTap(_ sender:UIControl){
        
    }
}
