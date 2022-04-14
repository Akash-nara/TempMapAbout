//
//  TabCVCell.swift
//  MyMapp
//
//  Created by smartsense ConsultingSolutions on 13/04/22.
//

import UIKit

class TabCVCell: UICollectionViewCell {

    @IBOutlet weak var labelTabName: UILabel!
    @IBOutlet weak var bottomIndicator: UIView!
    
    var fontLabel:UIFont!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelTabName.font = UIFont.Montserrat.Medium(15)
    }

    func cellConfig(data: TravelAdviceDataModel, selected: Bool) {
        labelTabName.text = data.title
        labelTabName.textColor = selected ? UIColor.App_BG_SeafoamBlue_Color : UIColor.black
        bottomIndicator.isHidden = !selected
        labelTabName.font = selected ?  UIFont.Montserrat.Bold(15) : UIFont.Montserrat.Medium(15)
        fontLabel = labelTabName.font
    }
    
}
