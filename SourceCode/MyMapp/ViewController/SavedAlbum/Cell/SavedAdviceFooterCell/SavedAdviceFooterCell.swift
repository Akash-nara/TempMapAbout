//
//  SavedAdviceFooterCell.swift
//  MyMapp
//
//  Created by smartsense ConsultingSolutions on 03/04/22.
//

import UIKit

class SavedAdviceFooterCell: UITableViewCell {

    static func getHeight(isOpenCell: Bool) -> CGFloat {
        return isOpenCell ? 35 : 15
    }

    @IBOutlet weak var viewBottom: UIView!
    
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
        viewBottom.isHidden = !isOpenCell
    }
    
}
