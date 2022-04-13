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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelTabName.font = UIFont.systemFont(ofSize: 17)
    }

    func cellConfig(data: TravelAdviceDataModel, selected: Bool) {
        labelTabName.text = data.title
        labelTabName.textColor = selected ? UIColor.App_BG_SeafoamBlue_Color : UIColor.black
        bottomIndicator.isHidden = !selected
    }
    
}
