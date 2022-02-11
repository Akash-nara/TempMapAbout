//
//  PlaceHolderTripCell.swift
//  MyMapp
//
//  Created by Akash on 31/01/22.
//

import UIKit

class PlaceHolderTripCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.text = "No trip found"
        title.font = UIFont.Montserrat.Medium(15)
        title.textColor = .App_BG_SecondaryDark2_Color
        
        subTitle.text = "Added trip will display here"
        subTitle.font = UIFont.Montserrat.Regular(13)
        subTitle.textColor = .App_BG_SecondaryDark2_Color
    }

}
