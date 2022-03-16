//
//  TitleHeaderTVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit

class TitleHeaderTVCell: UITableViewCell {

    @IBOutlet weak var constraintLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintRight: NSLayoutConstraint!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelTitle.font = UIFont.Montserrat.SemiBold(20)
        labelTitle.textColor = .App_BG_SecondaryDark2_Color
        labelTitle.numberOfLines = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDefaultConstraint() {
        constraintLeft.constant = 25
        constraintRight.constant = 25
    }
    
    func cellConfig(title: String){
        setDefaultConstraint()
        labelTitle.text = title
    }
    
}
