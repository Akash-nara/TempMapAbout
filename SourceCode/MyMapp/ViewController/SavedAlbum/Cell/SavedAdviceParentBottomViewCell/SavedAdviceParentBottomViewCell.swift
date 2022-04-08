//
//  SavedAdviceParentBottomViewCell.swift
//  MyMapp
//
//  Created by Akash  on 03/04/22.
//

import UIKit

class SavedAdviceParentBottomViewCell: UITableViewCell {

    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var constraintBottomButton: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfig(isOpenCell: Bool) {
        buttonDropDown.cornerRadius = isOpenCell ? 0 : 20
        constraintBottomButton.constant = isOpenCell ? -1 : 0
    }
    
    
}
